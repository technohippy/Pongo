module Pongo
  module Renderer
    class Renderer
      def cleanup(item)
        case item
        when CircleParticle
          cleanup_circle(item)
        when RectangleParticle
          cleanup_rectangle(item)
        when WheelParticle
          cleanup_wheel(item)
        when SpringConstraint
          cleanup_spring(item)
        else
          raise UnknownItemError.new(item.class.name)
        end
      end
      def cleanup_circle(item); end
      def cleanup_rectangle(item); end
      def cleanup_wheel(item); end
      def cleanup_spring(item); end

      def draw(item)
        return unless item.visible?
        case item
        when CircleParticle
          draw_circle(item)
        when RectangleParticle
          draw_rectangle(item)
        when WheelParticle
          draw_wheel(item)
        when SpringConstraint
          draw_spring(item)
        when AbstractCollection
          item.particles.each {|p| p.draw if p.always_redraw? or not p.fixed?}
          item.constraints.each {|c| c.draw if c.always_redraw? or not c.fixed?}
        else
          raise UnknownItemError.new(item.class.name)
        end
      end
      def draw_circle(item); end
      def draw_rectangle(item); end
      def draw_wheel(item); end
      def draw_spring(item); end

      def with(options, &block)
        @shoes.nostroke if options[:nostroke]
        @shoes.stroke(options[:stroke]) if options[:stroke]
        @shoes.fill(options[:fill]) if options[:fill]
        @shoes.transform(options[:transform]) if options[:transform]
        @shoes.rotate(options[:rotate]) if options[:rotate]
        block.call(@shoes)
        @shoes.rotate(-options[:rotate]) if options[:rotate]
        @shoes.transform(:corner) if options[:transform]
        @shoes.fill(@shoes.black) if options[:fill]
        @shoes.stroke(@shoes.black) if options[:stroke]
        @shoes.stroke(@shoes.black) if options[:nostroke]
      end
    end
  end
end
