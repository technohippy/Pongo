require 'pongo/renderer/renderer'

module Pongo
  module Renderer
    class TkRenderer < Renderer
      def initialize(canvas)
        @canvas = canvas
      end

      def draw_circle(item)
        if item.user_data[:shape]
          item.user_data[:shape].coords(
            item.px - item.radius, 
            item.py - item.radius,
            item.px + item.radius, 
            item.py + item.radius
          )
        else
          item.user_data[:shape] =TkcOval.new(@canvas, 
            item.px - item.radius, 
            item.py - item.radius,
            item.px + item.radius, 
            item.py + item.radius
          )
        end
      end
      alias draw_wheel draw_circle

      def draw_rectangle(item)
        c = Vector.new(item.px, item.py)
        x1 = -item.width/2 
        y1 = -item.height/2 
        x2 = item.width/2 
        y2 = item.height/2
        p1 = Vector.new(x1, y1).rotate!(item.radian) + c
        p2 = Vector.new(x1, y2).rotate!(item.radian) + c
        p3 = Vector.new(x2, y2).rotate!(item.radian) + c
        p4 = Vector.new(x2, y1).rotate!(item.radian) + c
        if item.user_data[:shape]
          item.user_data[:shape][0].coords(p1.x, p1.y, p2.x, p2.y)
          item.user_data[:shape][1].coords(p2.x, p2.y, p3.x, p3.y)
          item.user_data[:shape][2].coords(p3.x, p3.y, p4.x, p4.y)
          item.user_data[:shape][3].coords(p4.x, p4.y, p1.x, p1.y)
        else
          item.user_data[:shape] = [
            TkcLine.new(@canvas, p1.x, p1.y, p2.x, p2.y),
            TkcLine.new(@canvas, p2.x, p2.y, p3.x, p3.y),
            TkcLine.new(@canvas, p3.x, p3.y, p4.x, p4.y),
            TkcLine.new(@canvas, p4.x, p4.y, p1.x, p1.y)
          ]
        end
      end

      def draw_spring(item)
        if item.collidable?
          draw_rectangle(item.scp)
        else
          if item.user_data[:shape]
            item.user_data[:shape].coords(item.p1.px, 
              item.p1.py, item.p2.px, item.p2.py)
          else
            item.user_data[:shape] =TkcLine.new(@canvas, item.p1.px, 
              item.p1.py, item.p2.px, item.p2.py)
          end
        end
      end
    end
  end
end
