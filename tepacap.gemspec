# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name              = "tepacap"
  s.version           = "0.0.1"
  s.platform          = Gem::Platform::RUBY
  s.has_rdoc          = true
  s.extra_rdoc_files  = ["README.md"]
  s.summary           = "Overload the run parallel command of Capistrano"
  s.description       = s.summary
  s.author            = "Pascal Morillon"
  s.email             = "pascal.morillon@irisa.fr"
  s.homepage          = "https://github.com/pmorillon/tepacap"

  s.add_dependency "net-ssh-gateway", ">= 1.1.0"
  s.add_dependency "net-ssh", ">= 2.1.4"
  s.add_dependency "thread_storm", ">= 0.7.0"
  s.add_dependency "term-ansicolor", ">=1.0.7"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rake"

  s.require_path      = ["lib"]
  s.files             = %w( README.md ) + Dir.glob("lib/**/*")
end

