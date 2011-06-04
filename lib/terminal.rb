# Simple class for colorizing terminal output
class Terminal
  class <<self
    def red(string)
      "\e[1;31m#{string}#{reset_code}"
    end

    def yellow(string)
      "\e[1;33m#{string}#{reset_code}"
    end

    def green(string)
      "\e[1;32m#{string}#{reset_code}"
    end

    def reset_code
      "\e[0m"
    end
  end # class <<self
end # class Terminal
