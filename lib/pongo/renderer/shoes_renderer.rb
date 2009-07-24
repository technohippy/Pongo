require 'pongo/renderer/renderer'

module Pongo
  module Renderer
    class ShoesRenderer < Renderer
      attr_reader :shoes

      def initialize(shoes)
        @shoes = shoes
      end

      def draw_circle(item)
        @shoes.oval(item.px - item.radius, item.py - item.radius, item.radius * 2)
      end

      def draw_rectangle(item)
        @shoes.rect(:left => (item.px - item.width/2), :top => (item.py - item.height/2), :width => item.width, :height => item.height)
      end
    end
  end
end
