# frozen_string_literal: true

# STD Libs
require 'benchmark'

# This Gem
require 'require_bench/version'

module RequireBench
  TIMINGS = Hash.new { |h, k| h[k] = 0.0 }
  skips = ENV['REQUIRE_BENCH_SKIP_PATTERN']
  includes = ENV['REQUIRE_BENCH_INCLUDE_PATTERN']
  no_group = ENV['REQUIRE_BENCH_NO_GROUP_PATTERN']
  group_precedence = ENV['REQUIRE_BENCH_GROUP_PRECEDENCE'] || "path,basename"
  precedence = group_precedence.split(',')
  raise ArgumentError, "ENV['REQUIRE_BENCH_GROUP_PRECEDENCE'] is invalid." unless precedence.sort == %w(basename path)

  preferred_grouping = precedence.first
  prefer_not_path = preferred_grouping != 'path' # path correlates to default behavior of regexp matching

  if defined?(ColorizedString)
    require "require_bench/color_printer"
  else
    require "require_bench/printer"
  end
  PRINTER = Printer.new
  if skips && !skips.empty?
    skip_pattern = case skips
                   when /,/ then
                     Regexp.union(*skips.split(','))
                   when /\|/ then
                     Regexp.union(*skips.split('|'))
                   else
                     Regexp.new(skips)
                   end
    puts "[RequireBench] Using skip pattern: #{skip_pattern}"
  end
  if includes && !includes.empty?
    include_tokens = case includes
                     when /,/ then
                       includes.split(',')
                     when /\|/ then
                       includes.split('|')
                     else
                       Array(includes)
                     end
    include_pattern = Regexp.union(*include_tokens)
    include_tokens.reject! {|a| a.match?(/\//) } if prefer_not_path
    puts "[RequireBench] Using include pattern: #{include_pattern}"
  end
  if no_group && !no_group.empty?
    no_group_pattern = case no_group
                   when /,/ then
                     Regexp.union(*no_group.split(','))
                   when /\|/ then
                     Regexp.union(*no_group.split('|'))
                   else
                     Regexp.new(no_group)
                   end
    puts "[RequireBench] Using no group pattern: #{no_group_pattern}"
  end
  SKIP_PATTERN = skip_pattern
  INCLUDE_PATTERN = include_pattern
  INCLUDE_TOKENS = include_tokens
  NO_GROUP_PATTERN = no_group_pattern
  PREFER_NOT_PATH = prefer_not_path

  if ENV['REQUIRE_BENCH'] == 'true'
    def require_with_timing(file)
      $require_bench_semaphore = true
      ret = nil
      # Not sure if this is actually a useful abstraction...
      prefix = INCLUDE_TOKENS.detect { |t| File.basename(file).match?(t) } if PREFER_NOT_PATH

      seconds = Benchmark.realtime { ret = Kernel.send(:require_without_timing, file) }
      PRINTER.p(seconds, file)
      if prefix.nil? && (NO_GROUP_PATTERN.nil? || !NO_GROUP_PATTERN.match?(file))
        # This results in grouping all files with the same leading path part (e.g. "models", or "lib")
        #   into the same timing bucket.
        # requires that were fully qualified paths probably need to be identified
        #   by the full path
        prefix = if (match = INCLUDE_PATTERN&.match(file))
                   match[0]
                 else
                   # Generally this will target a library name, e.g. "rspec"
                   #    which sums all require timings from a single library together
                   file.partition('/').first
                 end
      end
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
      # byebug if file_path.match?(/no_group_fox/)

      # Global $ variable, which is always truthy while inside the hack, is to
      #   prevent a scenario that might result in infinite recursion.
      return require_without_timing(file_path) if $require_bench_semaphore

      measure = RequireBench::INCLUDE_PATTERN && file_path.match?(RequireBench::INCLUDE_PATTERN)
      skippy = RequireBench::SKIP_PATTERN && file_path.match?(RequireBench::SKIP_PATTERN)
      if !measure && skippy
        require_without_timing(file_path)
      elsif RequireBench::INCLUDE_PATTERN.nil? || measure
        RequireBench.require_with_timing(file_path)
      else
        require_without_timing(file_path)
      end
    end
  end
end
