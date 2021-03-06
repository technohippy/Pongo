require 'pongo/spring_constraint_particle'

module Pongo
  class CollisionEvent
    COLLIDE = :collide
    FIRST_COLLIDE = :first_collide

    attr_accessor :type, :colliding_item

    def initialize(type, colliding_item=nil)
      @type = type
      @colliding_item = colliding_item
    end

    def colliding_item
      if @colliding_item.is_a?(SpringConstraintParticle)
        @colliding_item.parent
      else
        @colliding_item
      end
    end
  end
end
