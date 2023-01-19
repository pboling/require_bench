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

  def p(seconds, file)
    printf "🚥 #{ColorizedString['[RequireBench]'].colorize(first)} %10f %s 🚥\n", seconds, file
  end
end
