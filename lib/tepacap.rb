require "thread_storm"
require "term/ansicolor"
require "timeout"

module Capistrano
  class Configuration
    module Actions
      module Invocation

        def run_tree(tree, options={}) #:nodoc:
          if tree.branches.empty? && tree.fallback
            logger.debug "executing #{tree.fallback}"
          elsif tree.branches.any?
            tree.each do |branch|
              logger.trace "-> #{branch}"
            end
          else
            raise ArgumentError, "attempt to execute without specifying a command"
          end

          return if dry_run || (debug && continue_execution(tree) == false)

          options = add_default_command_options(options)

          tree.each do |branch|
            if branch.command.include?(sudo)
              branch.callback = sudo_behavior_callback(branch.callback)
            end
          end

          # Starting overloading
          servers = find_servers_for_task(current_task, options)
          servers_names = servers.map { |x| x.host }

          if exists?(:ssh_config)
            ssh_config = fetch(:ssh_config)
          else
            ssh_config = true
          end

          logs = Hash.new { |h,k| h[k] = '' }
          errors = Hash.new { |h,k| h[k] = '' }
          ssh_session = {}
          threadpool = ThreadStorm.new :size => 60
          current_server = ""
          all_connected = false
          failed_servers = []

          # Ensure that all server are reacheable and establish a ssh connection.
          # Due to a bug in the ruby net-ssh-* libraries, we need to recreate a gateway and all previous ssh connections
          # when a ssh connection fails.
          until all_connected
            if exists?(:gateway)
              user, host, port = fetch(:gateway).match(/^(?:([^;,:=]+)@|)(.*?)(?::(\d+)|)$/)[1,3]
              gateway = Net::SSH::Gateway.new(host, user, :port => port, :config => ssh_config)
            end
            begin
              servers_names.each do |server|
                timeout(5) do
                  current_server = server
                  if exists?(:gateway)
                    ssh_session[server] = gateway.ssh(server, fetch(:user), :config => ssh_config)
                  else
                    ssh_session[server] = Net::SSH.start(server, fetch(:user), :config => ssh_config)
                  end
                  logger.debug "Connected to #{server}..."
                end
              end
              all_connected = true
            rescue Timeout::Error, Net::SSH::Disconnect, Exception => e
              logger.debug Term::ANSIColor.red("Removing #{current_server} (#{e.message})...")
              servers_names.delete current_server
              failed_servers << current_server
            end
          end

          # Execute command in parallel
          servers_names.each do |server|
            threadpool.execute do
              begin
                ssh_session[server].exec!(tree.fallback.command) do |channel, stream, data|
                  logs[server] << data
                  errors[server] << data if stream == :err
                  puts "[#{stream}][#{server}] #{data}" if data.chomp != ""
                end
              rescue Exception => e
                logger.debug Term::ANSIColor.red("[#{server}] " + e.message)
              end
            end
          end

          threadpool.join

          # Clean all ssh connections
          servers_names.each do |server|
            ssh_session[server].close
            gateway.close ssh_session[server].transport.port if exists?(:gateway)
          end
          gateway.shutdown! if exists?(:gateway)


          # Print the result sorting by hostname
          errors.sort.each do |error|
            puts Term::ANSIColor.red("---- stderr on #{error.first} #{"-" * (get_width - error.first.length - 16)} ")
            puts "#{error[1]}"
          end
          logs.sort.each do |key, value|
            puts Term::ANSIColor.intense_green("---- #{key} #{"-" * (get_width - key.length - 6)}")
            puts value
          end
          logger.important Term::ANSIColor.red("Servers unreachable : #{failed_servers.inspect}") if !failed_servers.empty?
        end

        private

        def get_width
          result = `tput cols`
          result.to_i
        end

      end
    end
  end
end
