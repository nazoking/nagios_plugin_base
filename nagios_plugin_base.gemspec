# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nagios_plugin_base/version'

Gem::Specification.new do |spec|
  spec.name          = "nagios_plugin_base"
  spec.version       = Nagios::PluginBase::VERSION
  spec.authors       = ["nazoking"]
  spec.email         = ["nazoking@gmail.com"]
  spec.summary       = %q{nagios plugin base class.}
  spec.description   = %q{nagios plugin base class.}
  spec.homepage      = "https://github.com/nazoking/nagios_plugin_base"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
