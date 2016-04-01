# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'standupmail-cli/version'

Gem::Specification.new do |spec|
  spec.name          = "standupmail-cli"
  spec.version       = StandupmailCli::VERSION
  spec.authors       = ["Benedikt Bingler"]
  spec.email         = ["ben@standupmail.com"]

  spec.summary       = "StandupMail command line tool."
  spec.description   = "Command line tool for sending StandupMail messages and receiving digests."
  spec.homepage      = "https://github.com/Wootech/standupmail-cli"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'rubocop', '~> 0.36'
  spec.add_runtime_dependency 'rest-client', '~> 1.0'
  spec.add_runtime_dependency 'json', '~> 1.8'
  spec.add_runtime_dependency 'thor', '~> 0.19.1'
  spec.add_runtime_dependency 'api-auth', '~> 1.5'
end
