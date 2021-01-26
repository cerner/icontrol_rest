# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'icontrol_rest/version'

Gem::Specification.new do |spec|
  spec.name          = 'icontrol_rest'
  spec.version       = IcontrolRest::VERSION
  spec.authors       = ['Jerrod Carpenter']
  spec.email         = ['jscarpenter25@gmail.com']

  spec.summary       = 'Allows user to interact with iControl REST interface.'
  spec.description   = 'Allows user to interact with iControl REST interface.'
  spec.homepage      = 'https://github.com/cerner/icontrol_rest.git'

  spec.files         = Dir['bin/*', 'lib/**/*.rb', 'Gemfile', 'Rakefile', 'README.md']
  spec.require_paths = ['lib']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }

  spec.required_ruby_version = '>= 2.4.0'
  spec.add_dependency 'httparty', '~> 0.13'
  spec.add_dependency 'retriable', '~> 2.0'
end
