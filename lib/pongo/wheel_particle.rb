module Pongo
  # A particle that simulates the behavior of a wheel 
  class WheelParticle < CircleParticle
    attr_accessor :rp, :tan, :norm_slip, :orientation, :traction

    def initialize(x, y, radius, options={})
      options = {:rotation => 0, :fixed => false, :mass => 1, :elasticity => 0.3, :friction => 0, :traction => 1}.update(options)
      super(x, y, radius, options)
      @tan = Vector.new
      @norm_slip = Vector.new
      @rp = RimParticle.new(radius, 2)

      self.traction = options[:traction]
      @orientation = Vector.new
    end

    # The speed of the WheelParticle. You can alter this value to make the 
    # WheelParticle spin.
    def speed
      @rp.speed
    end

    def speed=(s)
      @rp.speed = s
    end

    # The angular velocity of the WheelParticle. You can alter this value to make the 
    # WheelParticle spin.
    def angular_velocity
      @rp.angular_velocity
    end

    def angular_velocity=(a)
      @rp.angular_velocity = a
    end

    # The amount of traction during a collision. This property controls how much traction is 
    # applied when the WheelParticle is in contact with another particle. If the value is set
    # to 0, there will be no traction and the WheelParticle will behave as if the 
    # surface was totally slippery, like ice. Values should be between 0 and 1. 
    # 
    # <p>
    # Note that the friction property behaves differently than traction. If the surface 
    # friction is set high during a collision, the WheelParticle will move slowly as if
    # the surface was covered in glue.
    # </p>
    def traction
      1 - @traction
    end

    def traction=(t)
      @traction = 1 - t
    end

=begin
    def draw
      raise NotImplementedError
    end

    def init
      raise NotImplementedError
    end
=end

    def radian
      @orientation.set_to(rp.curr)
      Math.atan2(@orientation.y, @orientation.x) + Math::PI
    end

    def angle
      self.radian * MathUtil::ONE_EIGHTY_OVER_PI
    end

    def update(dt)
      super
      @rp.update(dt)
    end

    def resolve_collision(mtd, vel, n, d, o, p)
      super
      resolve(n * MathUtil.sign(d * o))
    end

    # simulates torque/wheel-ground interaction - n is the surface normal
    # Origins of this code thanks to Raigan Burns, Metanet software
    def resolve(n)
      # this is the tangent vector at the rim particle
      @tan.set_to(-@rp.curr.y, @rp.curr.x)

      # normalize so we can scale by the rotational speed
      @tan = @tan.normalize

      # velocity of the wheel's surface 
      wheel_surface_velocity = @tan * @rp.speed

      # the velocity of the wheel's surface relative to the ground
      combined_velocity = @velocity.plus!(wheel_surface_velicity)

      # the wheel's comb velocity projected onto the contact normal
      cp = combined_velocity.cross(n)

      # set the wheel's spinspeed to track the ground
      @tan.mult!(cp)
      @rp.prev.copy(@rp.curr - @tan)

      # some of the wheel's torque is removed and converted into linear displacement
      slip_speed = (1 - @traction) * @rp.speed
      norm_slip.set_to(slip_speed * n.y, slip_speed * n.x)
      @curr.plus!(norm_slip)
      @rp.speed *= @traction
    end
  end
end
