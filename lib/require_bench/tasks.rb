# frozen_string_literal: true

# NOTE: Gem is only active if REQUIRE_BENCH=true is set in shell

# require 'require_bench/tasks'
# will give you the require_bench tasks.
#  Do it as early as possible during bootstrapping!
require "require_bench"

namespace :require_bench do
  desc "Print timings while booting app, determine slowest loading files"
  task hello: :environment do
    tot = 0.0
    vals = RequireBench::TIMINGS.to_a
    vals.sort_by! { |a| a[1] }.reverse!
    if !vals.empty?
      puts "\n[RequireBench] Slowest Loads by Library, in order"
      vals.each_with_index do |a, index|
        tot += a[1]
        printf("%2d. %10f %s\n", index + 1, a[1], a[0])
      end
      puts "=========="
      printf("%10f %s\n", tot, "TOTAL")
    else
      puts %(
require_bench did not track any requires, because it was required too late, of the configuration excluded everything.
Require in Rakefile, as follows
  require 'bundler/setup' # or for Rails - require_relative 'config/application'
  require 'require_bench/tasks'
Check ENV variable values for:
    REQUIRE_BENCH_SKIP_PATTERN
    REQUIRE_BENCH_INCLUDE_PATTERN
    REQUIRE_BENCH_NO_GROUP_PATTERN
Then run rake require_bench:hello again!
)
    end
  end
end
