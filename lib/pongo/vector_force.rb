module Pongo
  # A force represented by a 2D vector. 
  class VectorForce < IForce
    attr_accessor :fvx, :fvy, :value, :scale_mass

    def initialize(use_mass, vx, vy)
      @fvx = vx
      @fvy = vy
      @scale_mass = use_mass
      @value = Vector.new(vx, vy)
    end

    def vx=(x)
      @fvx = x
      @value.x = x
    end

    def vy=(y)
      @fvy = y
      @value.y = y
    end

    def use_mass=(b)
      @scale_mass = b
    end

    def get_value(invmass)
      if @scale_mass
        @value.set_to(@fvx * invmass, @fvy * invmass)
      end
      @value
    end
  end
end
