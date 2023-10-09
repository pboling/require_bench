# frozen_string_literal: true

require 'silent_stream'
require 'byebug'
require 'colorize'
require 'lucky_case'

# The gem does nothing unless this variable is set.
ENV['REQUIRE_BENCH'] = 'true'
ENV['REQUIRE_BENCH_SKIP_PATTERN'] = 'skipped_bird|skipped_nested_bird|skipped|nested/ignored'
ENV['REQUIRE_BENCH_INCLUDE_PATTERN'] =
  'ostruct|logged_tiger|logged_skipped_lion|logged_duck|no_group_fox|no_group_cat|grouped|nested/collected'
ENV['REQUIRE_BENCH_NO_GROUP_PATTERN'] = 'no_group_fish|no_group_fly|separate|nested/disparate'
# default is "path,basename", which is how Regexp matching works naturally,
#   since the path precedes the basename in any filename string.
ENV['REQUIRE_BENCH_GROUP_PRECEDENCE'] = 'basename,path'

require 'require_bench'
require 'support/helpers/file_factory'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include SilentStream
  config.include FileFactory
end
