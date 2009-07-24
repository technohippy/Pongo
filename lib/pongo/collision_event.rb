require 'pongo/spring_constraint_particle'

module Pongo
  class CollisionEvent
    COLLIDE = :collide;
    FIRST_COLLIDE = :firstCollide;

    attr_accessor :event_type, :colliding_item

    def initialize(type, bubbles=false, cancelable=false, colliding_item=nil)
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
