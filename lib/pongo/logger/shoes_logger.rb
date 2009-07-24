require 'pongo/logger/logger'

module Pongo
  module Logger
    class ShoesLogger < Logger
      def initialize(shoes)
        @shoes = shoes
      end

      def print(message)
        @shoes.info(message)
      end
    end
  end
end
