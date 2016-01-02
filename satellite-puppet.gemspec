# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'satellite_puppet/version'

Gem::Specification.new do |spec|
  spec.name          = "satellite-puppet"
  spec.version       = SatellitePuppet::VERSION
  spec.authors       = ["Dhaval Joshi"]
  spec.email         = ["d.joshi84@gmail.com"]
  spec.summary       = %q{TODO: From GIT repository upload puppet module to satellite repo}
  spec.description   = %q{TODO: Using puppet-blacksmith we can tag puppet module and directly push to satellite repository .}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rest-client"
  spec.add_development_dependency "json"
  spec.add_development_dependency "yaml"
  spec.add_development_dependency "puppet-blacksmith"
end
