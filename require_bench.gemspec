# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'require_bench/version'

Gem::Specification.new do |spec|
  spec.name          = 'require_bench'
  spec.version       = RequireBench::VERSION
  spec.authors       = ['Peter Boling']
  spec.email         = ['peter.boling@gmail.com']

  spec.summary       = 'Discover bootstrapping issues in Ruby by benchmarking "Kernel.require"'
  spec.description   = 'Ruby app loading slowly, or never? Discover bootstrapping issues in Ruby by benchmarking "Kernel.require"'
  spec.homepage      = 'https://github.com/pboling/require_bench'

  spec.files         = Dir[
    'lib/**/*',
    'LICENSE',
    'CODE_OF_CONDUCT.md',
    'README.md'
  ]
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.license       = 'MIT'

  spec.add_development_dependency 'byebug', '~> 11'
  spec.add_development_dependency 'colorize', '~> 1.1'
  spec.add_development_dependency 'lucky_case', '~> 1.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'rspec-block_is_expected', '~> 1.0'
  spec.add_development_dependency 'rspec-stubbed_env', '~> 1.0', '>= 1.0.1'
  spec.add_development_dependency 'rubocop-lts', '~> 2.1', '>= 2.1.1'
  spec.add_development_dependency 'rubocop-packaging', '~> 0.5', '>= 0.5.2'
  spec.add_development_dependency 'silent_stream', '~> 1.0', '>= 1.0.3'
end
