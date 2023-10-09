# std libs
require "forwardable"

# third party libs
# You will need to have gem "colorize" installed!
# NOTE: You will need to require "colorized_string" in your own code,
#       in order for this alternate Printer class to load

class Printer
  attr_accessor :colors, :color
  extend Forwardable
  def_delegators :@colors, :rotate!, :first
  def initialize
    @colors = ColorizedString.colors.dup.reject {|x| x.match?(/black|white/) }
  end

  # Log statement when a file starts loading
  def s(file, type)
    printf "🚥 #{ColorizedString["[RequireBench-#{type}]"].colorize(first)} 📖 %s 🚥\n", file
    rotate!
  end

  # Log statement when a file completed loading
  def p(seconds, file, type)
    printf "🚥 #{ColorizedString["[RequireBench-#{type}]"].colorize(first)} ☑️ %10f %s 🚥\n", seconds, file
    rotate!
  end

  # Log statement when a file raises an error while loading
  def e(error, file, type)
    printf "🚥 #{ColorizedString["[RequireBench-#{type}]"].colorize(first)} ❌ '#{error.class}: #{error.message}' loading %s 🚥\n#{error.backtrace.join("\n")}", file
  end
end
