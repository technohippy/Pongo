module Pongo
  class Collision
    attr_accessor :vn, :vt

    def initialize(vn=Vector.new, vt=Vector.new)
      @vn = vn
      @vt = vt
    end
  end
end

