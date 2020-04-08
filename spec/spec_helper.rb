# frozen_string_literal: true

require 'bundler/setup'
require 'silent_stream'
require 'byebug'

# The gem does nothing unless this variable is set.
ENV['REQUIRE_BENCH'] = 'true'
ENV['REQUIRE_BENCH_SKIP_PATTERN'] = 'cmath|ostruct'

require 'require_bench'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include SilentStream
end
