# frozen_string_literal: true

# STD Libs
require 'benchmark'

# This Gem
require 'require_bench/version'

module RequireBench
  TIMINGS = Hash.new { |h, k| h[k] = 0.0 }
  skips = ENV['REQUIRE_BENCH_SKIP_PATTERN']
  if skips
    skip_pattern = case skips
                   when /,/ then
                     Regexp.union(*skips.split(','))
                   when /\|/ then
                     Regexp.union(*skips.split('|'))
                   end
    puts "[RequireBench] Using skip pattern: #{skip_pattern}"
  end
  SKIP_PATTERN = skip_pattern

  if ENV['REQUIRE_BENCH'] == 'true'
    def require_with_timing(file)
      $require_bench_semaphore = true
      ret = nil
      seconds = Benchmark.realtime { ret = Kernel.send(:require_without_timing, file) }
      printf("[RequireBench] %10f %s\n", seconds, file)
      path_parts = file.split('/')
      prefix = path_parts.first
      # requires that were fully qualified paths probably need to be identified
      #   by the full path
      prefix = file if prefix.nil? || prefix.empty?
      RequireBench::TIMINGS[prefix] += seconds
      ret
    ensure
      $require_bench_semaphore = nil
    end
    module_function :require_with_timing
  end
end

if ENV['REQUIRE_BENCH'] == 'true'
  # A Kernel hack that adds require timing to find require problems in app.
  module Kernel
    alias require_without_timing require

    def require(file)
      file_path = file.to_s

      # Global $ variable, which is always truthy while inside the hack, is to
      #   prevent a scenario that might result in infinite recursion.
      return require_without_timing(file_path) if $require_bench_semaphore
      if RequireBench::SKIP_PATTERN && file_path =~ RequireBench::SKIP_PATTERN
        return require_without_timing(file_path)
      end

      RequireBench.require_with_timing(file_path)
    end
  end
end
