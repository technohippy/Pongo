module Pongo
  class AbstractItem
    attr_accessor :sprite, :solid, :visible, :always_repaint, :user_data, :renderer
    attr_reader :line_thickness, :line_color, :line_alpha, :fill_color, :fill_alpha, :display_object, :display_object_offset, :display_object_rotatin

    def initialize
      @solid = true
      @visible = true
      @always_repaint = false
      @events = Hash.new {[]}
    end

    def renderer
      @renderer || APEngine.renderer
    end

    def init
      cleanup
      draw
    end

    def cleanup
      renderer.cleanup(self)
    end

    def draw
      renderer.draw(self)
    end

    def has_event_listener(event_type)
      not @events[event_type].empty?
    end

    def add_event_listener(event_type, callable=nil, &block)
      @events[event_type] << (callable || block)
    end

    def dispatch_event(event)
      @events[event.type].each do |listener|
        listener.call(event)
      end
    end

    def always_redraw?
      @always_repaint
    end

    def always_redraw
      @always_repaint
    end

    def always_redraw=(b)
      @always_repaint = b
    end

    def always_redraw!
      @always_repaint = true
    end

    def set_style(line_thickness=0, line_color=0x000000, line_alpha=1, fill_color=0xffffff, fill_alpha=1)
      set_line(line_thickness, line_color, line_alpha)
      set_fill(fill_color, fill_alpha)
    end

    def set_line(thickness=0, color=0x000000, alpha=1)
      @line_thickness = thickness
      @line_color = color
      @line_alpha = alpha
    end

    def set_fill(color=0xffffff, alpha=1)
      @fill_color = color
      @fill_alpha = alpha
    end
  end
end
