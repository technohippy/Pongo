require 'pongo/group'
class Meteors < Pongo::Group
  include Pongo
  attr_accessor :meteors

  def initialize(renderer)
    super(true)
    @renderer = renderer
    @meteors = []
  end

  def shoot!
    #meteor = wheel(400 + rand(400) - 200, -50, 20 + rand(12) - 6, :elasticity => 0.0)
    #meteor = circle(400 + rand(400) - 200, -50, 20 + rand(12) - 6, :elasticity => 0.0)
    meteor = circle(400 + rand(400) - 200, -50, 16, :elasticity => 0.0)
    meteor.user_data[:shape] = renderer.shoes.image(
      File.dirname(__FILE__) + '/assets/meteor.gif',
      :left => (meteor.px - meteor.radius).to_i,
      :top => (meteor.py - meteor.radius).to_i
    )
    meteor.add_event_listener(CollisionEvent::COLLIDE) do |evt|
      #APEngine.log("collide!!: #{evt.colliding_item.inspect}")
    end
    meteor.add_force(VectorForce.new(true, rand(400) - 200, rand(50)))
    meteors << meteor
  end

  def draw
    new_meteors = []
    meteors.each do |meteor|
      if 320 < meteor.py
        self.particles.delete(meteor)
      else
        meteor.user_data[:shape].move(
          (meteor.px - meteor.radius).to_i, 
          (meteor.py - meteor.radius).to_i
        )
        new_meteors << meteor
      end
    end
    @meteors = new_meteors
  end
end
