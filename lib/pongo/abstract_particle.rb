module Pongo
  class AbstractParticle < AbstractItem
    attr_accessor :curr, :prev, :samp, :interval, :temp, :forces, :force_list, :collision, :first_collision, :kfr, :mass, :inv_mass, :friction, :fixed, :collidable, :center, :multisample

    def initialize(x, y, is_fixed, mass, elasticity, friction) 
      super()
      @interval = Interval.new
      @curr = Vector.new(x, y)
      @prev = Vector.new(x, y)
      @samp = Vector.new
      @temp = Vector.new
      @fixed = is_fixed
      @forces = Vector.new
      @force_list = []
      @collision = Collision.new
      @collidable = true
      @first_collision = false
      self.mass = mass
      self.elasticity = elasticity
      self.friction = friction
      set_style
      @center = Vector.new
      @multisample = 0
    end

    def mass=(m)
      raise ArgumentError.new('mass may not be set <= 0') if m <= 0
      @mass = m
      @inv_mass = 1.0 / m
    end

    # The elasticity of the particle. Standard values are between 0 and 1. 
    # The higher the value, the greater the elasticity.
    # 
    # <p>
    # During collisions the elasticity values are combined. If one particle's
    # elasticity is set to 0.4 and the other is set to 0.4 then the collision will
    # be have a total elasticity of 0.8. The result will be the same if one particle
    # has an elasticity of 0 and the other 0.8.
    # </p>
    # 
    # <p>
    # Setting the elasticity to greater than 1 (of a single particle, or in a combined
    # collision) will cause particles to bounce with energy greater than naturally 
    # possible.
    # </p>
    def elasticity
      @kfr
    end

    def elasticity=(k)
      @kfr = k
    end

    def center
      @center.set_to(px, py)
      @center
    end

    def friction=(f)
      raise ArgumentError.new('Legal friction must be >= 0 and <= 1') if f < 0 or 1 < f
      @friction = f
    end

    def fixed?
      @fixed
    end

    def position
      @curr.dup
    end

    def position=(p)
      @curr.copy(p)
      @prev.copy(p)
    end

    def px
      @curr.x
    end

    def px=(x)
      @curr.x = x
      @prev.x = x
    end

    def py
      @curr.y
    end

    def py=(y)
      @curr.y = y
      @prev.y = y
    end

    def velocity
      @curr - @prev
    end

    def velocity=(v)
      @prev = @curr - v
    end

    def collidable?
      @collidable
    end

    def collidable!
      @collidable = true
    end

    def set_display(d, offset_x=0, offset_y=0, rotation=0)
      @display_object = d
      @display_object_rotation = rotation
      @display_object_offset = Vector.new(offset_x, offset_y)
    end

    def add_force(f)
      @force_list << f
    end

    def update(dt2)
      return if @fixed
      accumulate_forces
      @temp.copy(@curr)
      @nv = velocity + @forces.mult!(dt2)
      @curr.plus!(@nv.mult!(APEngine.damping))
      @prev.copy(@temp)
      clear_forces
    end

    def reset_first_collision!
      @first_collision = false
    end

    def init_display
      raise NotImplementedError
    end

    def get_components(collision_normal)
      vel = velocity
      vdotn = collision_normal.dot(vel)
      @collision.vn = collision_normal * vdotn
      @collision.vt = vel - collision.vn
      @collision
    end
    alias components get_components

    def resolve_collision(mtd, vel, n, d, o, p)
      test_particle_events(p)
      return if @fixed or (not @solid) or (not p.solid)
      @curr.copy(@samp)
      @curr.plus!(mtd)
      self.velocity = vel
    end

    def test_particle_events(p)
      if has_event_listener(CollisionEvent::COLLIDE)
        dispatch_event(CollisionEvent.new(CollisionEvent::COLLIDE, false, false, p))
      end
      if has_event_listener(CollisionEvent::FIRST_COLLIDE) and not @first_collision
        @first_collision = true
        dispatch_event(CollisionEvent.new(CollisionEvent::FIRST_COLLIDE, false, false, p))
      end
    end

    def inv_mass
      @fixed ? 0 : @inv_mass
    end

    def accumulate_forces
      @force_list.each {|f| @forces.plus!(f.get_value(inv_mass))}
      APEngine.forces.each {|f| @forces.plus!(f.get_value(inv_mass))}
    end

    def clear_forces
      @force_list = []
      @forces.set_to(0, 0)
    end

    def solid?
      @solid
    end
  end
end
