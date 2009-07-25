require 'pongo/renderer/renderer'

module Pongo
  module Renderer
    class ShoesRenderer < Renderer
      attr_reader :shoes

      def initialize(shoes)
        @shoes = shoes
      end

      def draw_circle(item)
        if item.user_data[:shape]
          item.user_data[:shape].style(
            :left => item.px - item.radius, 
            :top => item.py - item.radius
          )
        else
          item.user_data[:shape] = @shoes.oval(
            item.px - item.radius, 
            item.py - item.radius, 
            item.radius * 2
          )
        end
      end

      def draw_rectangle(item)
        item.user_data[:shape].remove if item.user_data[:shape]
        with(:transform => :center, :rotate => -item.angle) do
          item.user_data[:shape] = 
            @shoes.rect(
              :left => (item.px - item.width/2), 
              :top => (item.py - item.height/2), 
              :width => item.width, 
              :height => item.height
            )
          end
      end
    end
  end
end
