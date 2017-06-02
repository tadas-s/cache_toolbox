# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prefix_store/version'

Gem::Specification.new do |spec|
  spec.name          = 'prefix_store'
  spec.version       = PrefixStore::VERSION
  spec.authors       = ['Tadas Sasnauskas']
  spec.email         = ['tadas@yoyo.lt']

  spec.summary       = <<~SUMMARY
    Rails cache utility store writing to parent cache with a key prefix.
  SUMMARY
  spec.description   = ''
  spec.homepage      = 'https://github.com/tadas-s/prefix_store'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.49'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.0'
end
