# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticsearch/provider/version'

Gem::Specification.new do |spec|
  spec.name          = 'elasticsearch-provider'
  spec.version       = Elasticsearch::Provider::VERSION
  spec.authors       = ['Denis Sobolev']
  spec.email         = ['dns.sobol@gmail.com']

  spec.summary       = 'Elasticsearch wrapper for DSL and client library'
  spec.description   = 'Wrapper for elasticsearch-dsl, elasticsearch-client'
  spec.homepage      = 'https://github.com/umount/elasticsearch-provider'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'elasticsearch'
  spec.add_dependency 'elasticsearch-dsl'
  spec.add_dependency 'hashie'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
