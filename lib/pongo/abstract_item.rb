module Pongo
  class AbstractItem
    attr_accessor :solid, :visible, :always_repaint, :renderer
    attr_reader :line_thickness, :line_color, :line_alpha, :fill_color, :fill_alpha, :display_object, :display_object_offset, :display_object_rotation
    attr_reader :user_data

    def initialize
      @solid = true
      @visible = true
      @always_repaint = false
      @events = Hash.new
      @user_data = {}
    end

    def visible?
      @visible
    end

    def visible!
      @visible = true
    end

    def renderer
      @renderer || APEngine.renderer
    end

    # This method is automatically called when an item's parent group is added to the engine,
    # an item's Composite is added to a Group, or the item is added to a Composite or Group.
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
    alias paint draw

    def has_event_listener(event_type)
      @events[event_type]
    end

    def add_event_listener(event_type, callable=nil, &block)
      (@events[event_type] ||= []) << (callable || block)
    end

    def dispatch_event(event)
      (@events[event.type] || []).each do |listener|
        listener.call(event)
      end
    end

    # For performance, fixed Particles and SpringConstraints don't have their <code>paint()</code>
    # method called in order to avoid unnecessary redrawing. A SpringConstraint is considered
    # fixed if its two connecting Particles are fixed. Setting this property to <code>true</code>
    # forces <code>paint()</code> to be called if this Particle or SpringConstraint <code>fixed</code>
    # property is true. If you are rotating a fixed Particle or SpringConstraint then you would set 
    # it's repaintFixed property to true. This property has no effect if a Particle or 
    # SpringConstraint is not fixed.
    def always_redraw?
      @always_repaint
    end
    alias always_redraw always_redraw?

    def always_redraw=(bool)
      @always_repaint = bool
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
