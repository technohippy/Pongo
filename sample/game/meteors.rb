require 'pongo/group'
class Meteors < Pongo::Group
  include Pongo
  attr_accessor :meteors
  def initialize
    super(true)
    @meteors = []
  end

  def shoot!
    meteor = circle(400 + rand(400) - 200, -10, 20 + rand(12) - 6, :elasticity => 0.0)
    meteor.add_event_listener(CollisionEvent::COLLIDE) {APEngine.log('collide')}
    meteor.add_force(VectorForce.new(true, rand(400) - 200, rand(50)))
    meteors << meteor
  end
end
