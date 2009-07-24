module Pongo
  class RimParticle
    attr_accessor :curr, :prev, :wr, :angular_velocity, :speed, :max_torque

    def initialize(r, mt)
      @curr = Vector.new
      @prev = Vector.new
      @speed = 0
      @angular_velocity = 0
      @max_torque = mt
      @wr = r
    end

    def update(dt)
      @speed = Math.max(-@max_torque, Math.min(@max_torque, @speed + @angular_velocity))

      # apply torque
      # this is the tangent vector at the rim particle
      dx = -@curr.y
      dy = @curr.x

      # normalize so we can scale by the rotational speed
      len = Math.sqrt(dx * dx + dy * dy)
      dx /= len
      dy /= len

      @curr.x += @speed * dx
      @curr.y += @speed * dy

      ox = @prev.x
      oy = @prev.y
      px = @prev.x = @curr.x
      py = @prev.y = @curr.y

      @curr.x += APEngine.damping * (px - ox)
      @curr.y += APEngine.damping * (py - oy)

      # hold the rim particle in place
      clen = Math.sqrt(@curr.x * @curr.x + @curr.y * @curr.y)
      diff = (clen - wr) / clen

      @curr.x -= @curr.x * diff
      @curr.y -= @curr.y * diff
    end
  end
end
