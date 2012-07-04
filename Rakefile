require 'rubygems'
require 'rubygems/package_task'

gemspec = Gem::Specification.load(
  File.expand_path("../tepacap.gemspec", __FILE__)
)

Gem::PackageTask.new(gemspec) do |pkg|
  pkg.gem_spec = gemspec
end

