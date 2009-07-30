module Pongo
  # The abstract base class for all particles.
  #
  # You should not instantiate this class directly -- instead use one of the subclasses.
  class AbstractParticle < AbstractItem
    attr_accessor :curr, :prev, :samp, :interval, :temp, :forces, :force_list, :collision, :first_collision
    attr_accessor :kfr, :mass, :inv_mass, :friction, :fixed, :collidable, :center, :multisample

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
    # During collisions the elasticity values are combined. If one particle's
    # elasticity is set to 0.4 and the other is set to 0.4 then the collision will
    # be have a total elasticity of 0.8. The result will be the same if one particle
    # has an elasticity of 0 and the other 0.8.
    # 
    # Setting the elasticity to greater than 1 (of a single particle, or in a combined
    # collision) will cause particles to bounce with energy greater than naturally 
    # possible.
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

    # The surface friction of the particle. Values must be in the range of 0 to 1.
    # 
    # 0 is no friction (slippery), 1 is full friction (sticky).
    # 
    # During collisions, the friction values are summed, but are clamped between 1 
    # and 0. For example, If two particles have 0.7 as their surface friction, then
    # the resulting friction between the two particles will be 1 (full friction).
    #
    # There is a bug in the current release where colliding non-fixed particles with
    # friction greater than 0 will behave erratically. A workaround is to only set 
    # the friction of fixed particles.
    def friction=(f)
      raise ArgumentError.new('Legal friction must be >= 0 and <= 1') if f < 0 or 1 < f
      @friction = f
    end

    def fixed?
      @fixed
    end

    # The position of the particle. Getting the position of the particle is useful
    # for drawing it or testing it for some custom purpose. 
    # 
    # <p>
    # When you get the <code>position</code> of a particle you are given a copy of 
    # the current location. Because of this you cannot change the position of a 
    # particle by altering the <code>x</code> and <code>y</code> components of the 
    # Vector you have retrieved from the position property. You have to do something
    # instead like: <code> position = new Vector(100,100)</code>, or you can use the
    # <code>px</code> and <code>py</code> properties instead.
    # </p>
    # 
    # <p>
    # You can alter the position of a particle three ways: change its position, set
    # its velocity, or apply a force to it. Setting the position of a non-fixed 
    # particle is not the same as setting its fixed property to true. A particle held
    # in place by its position will behave as if it's attached there by a 0 length
    # spring constraint. 
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

    # The velocity of the particle. If you need to change the motion of a particle, 
    # you should either use this property, or one of the addForce methods. Generally,
    # the addForce methods are best for slowly altering the motion. The velocity 
    # property is good for instantaneously setting the velocity, e.g., for 
    # projectiles.
    def velocity
      @curr - @prev
    end

    def velocity=(v)
      @prev = @curr - v
    end

    # Determines if the particle can collide with other particles or constraints.
    # The default state is true.
    def collidable?
      @collidable
    end

    def collidable!
      @collidable = true
    end

    # Adds a force to the particle. Using this method to a force directly to the
    # particle will only apply that force for a single APEngine.step() cycle. 
    def add_force(force)
      @force_list << force
    end

    # The <code>update()</code> method is called automatically during the
    # APEngine.step() cycle. This method integrates the particle.
    def update(dt2)
      return if fixed?

      accumulate_forces

      @temp.copy(@curr)
      nv = velocity + @forces.mult!(dt2)
      @curr.plus!(nv.mult!(APEngine.damping))
      @prev.copy(@temp)

      clear_forces
    end

    # Resets the collision state of the particle. This value is used in conjuction
    # with the CollisionEvent.FIRST_COLLISION event.
    def reset_first_collision!
      @first_collision = false
    end
    alias reset_first_collision reset_first_collision!

    def components(collision_normal)
      vel = velocity
      vdotn = collision_normal.dot(vel)
      @collision.vn = collision_normal * vdotn
      @collision.vt = vel - collision.vn
      @collision
    end
    alias get_components components

    # Make sure to align  the overriden versions of this method in
    # WheelParticle
    def resolve_collision(mtd, vel, n, d, order, particle)
      test_particle_events(particle)
      return if fixed? or (not solid?) or (not particle.solid?)
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
      fixed? ? 0 : @inv_mass
    end

    # Accumulates both the particle forces and the global forces
    def accumulate_forces
      @force_list.each {|f| @forces.plus!(f.get_value(@inv_mass))}
      APEngine.forces.each {|f| @forces.plus!(f.get_value(@inv_mass))}
      @forces
    end

    # Clears out all forces on the particle
    def clear_forces
      @force_list.clear
      @forces.set_to(0, 0)
    end

    def solid?
      @solid
    end
  end
end
