# frozen_string_literal: true

# Get the GEMFILE_VERSION without *require* "my_gem/version", for code coverage accuracy
# See: https://github.com/simplecov-ruby/simplecov/issues/557#issuecomment-825171399
load "lib/require_bench/version.rb"
gem_version = RequireBench::Version::VERSION
RequireBench::Version.send(:remove_const, :VERSION)

Gem::Specification.new do |spec|
  spec.name = "require_bench"
  spec.version = gem_version
  spec.authors = ["Peter Boling"]
  spec.email = ["peter.boling@gmail.com"]

  # See CONTRIBUTING.md
  spec.cert_chain = ["certs/pboling.pem"]
  spec.signing_key = File.expand_path("~/.ssh/gem-private_key.pem") if $PROGRAM_NAME.end_with?("gem")

  spec.summary = "Discover bootstrapping issues in Ruby by benchmarking 'Kernel.require' & 'load'"
  spec.description = "Ruby app loading slowly, or never? Discover bootstrapping issues in Ruby by logging/benchmarking/timing-out/rescuing 'Kernel.require' & 'load'"
  spec.homepage = "https://gitlab.com/pboling/#{spec.name}"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "#{spec.homepage}/-/tree/v#{spec.version}"
  spec.metadata["changelog_uri"] = "#{spec.homepage}/-/blob/v#{spec.version}/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/-/issues"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/#{spec.name}/#{spec.version}"
  spec.metadata["wiki_uri"] = "#{spec.homepage}/-/wikis/home"
  spec.metadata["funding_uri"] = "https://liberapay.com/pboling"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir[
    # Splats (alphabetical)
    "lib/**/*.rb",
    "sig/**/*.rbs",
    # Files (alphabetical)
    "CHANGELOG.md",
    "CODE_OF_CONDUCT.md",
    "CONTRIBUTING.md",
    "LICENSE.txt",
    "README.md",
    "SECURITY.md"
  ]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency("version_gem", ">= 1.1.3", "< 4")                # >= 2.2.0

  # Documentation
  spec.add_development_dependency("rbs", "~> 3.1")
  spec.add_development_dependency("redcarpet", "~> 3.6")
  spec.add_development_dependency("yard", "~> 0.9", ">= 0.9.34")
  spec.add_development_dependency("yard-junk", "~> 0.0")

  spec.add_development_dependency("byebug", "~> 11")
  spec.add_development_dependency("colorize", "~> 1.1")
  spec.add_development_dependency("lucky_case", "~> 1.1")
  spec.add_development_dependency("rake", "~> 13.0")
  spec.add_development_dependency("rspec", "~> 3.12")
  spec.add_development_dependency("rspec-block_is_expected", "~> 1.0")
  spec.add_development_dependency("rspec-stubbed_env", "~> 1.0", ">= 1.0.1")
  spec.add_development_dependency("rubocop-lts", "~> 8.1", ">= 8.1.1") # Lint & Style Support for Ruby 2.2+
  spec.add_development_dependency("rubocop-packaging", "~> 0.5", ">= 0.5.2")
  spec.add_development_dependency("silent_stream", "~> 1.0", ">= 1.0.3")
end
