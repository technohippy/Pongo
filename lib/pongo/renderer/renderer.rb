module Pongo
  module Renderer
    class Renderer
      def cleanup(item)
        case item
        when CircleParticle
          cleanup_circle(item)
        when RectangleParticle
          cleanup_rectangle(item)
        else
          raise ArgumentError.new(item.class.name)
        end
      end
      def cleanup_circle(item); end
      def cleanup_rectangle(item); end

      def draw(item)
        case item
        when CircleParticle
          draw_circle(item)
        when RectangleParticle
          draw_rectangle(item)
        else
          raise ArgumentError.new(item.class.name)
        end
      end
      def draw_circle(item); end
      def draw_rectangle(item); end
    end
  end
end
