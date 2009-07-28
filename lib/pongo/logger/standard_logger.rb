require 'pongo/logger/logger'

module Pongo
  module Logger
    class StandardLogger < Logger
      def print(message)
        puts message
      end
    end
  end
end
