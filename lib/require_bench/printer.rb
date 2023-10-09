class Printer
  # Log statement when a file starts loading
  def s(file, type)
    printf "🚥 [RequireBench-#{type}] 📖 %s 🚥\n", file
    rotate!
  end

  # Log statement when a file completed loading
  def p(seconds, file, type)
    printf "🚥 [RequireBench-#{type}] ☑️ %10f %s 🚥\n", seconds, file
  end

  # Log statement when a file raises an error while loading
  def e(error, file, type)
    printf "🚥 [RequireBench-#{type}] ❌ '#{error.class}: #{error.message}' loading %s 🚥\n#{error.backtrace.join("\n")}",
           file
  end
end
