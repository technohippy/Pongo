module Pongo
  module Logger
    class Logger
      def print(message)
        puts(message)
      end

      def error(message)
        print("Error: #{message}")
      end

      def warn(message)
        print("Warn: #{message}")
      end

      def info(message)
        print("Info: #{message}")
      end
    end
  end
end
