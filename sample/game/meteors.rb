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
    meteor = circle(400 + rand(400) - 200, -50, 16, :elasticity => 0.0)
    meteor.user_data[:shape] = renderer.shoes.image(
      File.dirname(__FILE__) + '/assets/meteor.gif',
      :left => (meteor.px - meteor.radius).to_i,
      :top => (meteor.py - meteor.radius).to_i
    )
    meteor.add_event_listener(CollisionEvent::COLLIDE) do |evt|
      if evt.colliding_item.user_data[:group].is_a?(Car)
        vanish!(meteor)
        evt.colliding_item.user_data[:group].damage
      end
      meteor.user_data[:collide] ||= 0
      meteor.user_data[:collide] += 1
      if 2 < meteor.user_data[:collide]
        vanish!(meteor)
      end
    end
    meteor.add_force(VectorForce.new(true, rand(400) - 200, rand(25)))
    meteors << meteor
  end

  def vanish!(m)
    shoes = renderer.shoes
    @meteors.delete(m)
    m.user_data[:shape].remove if m.user_data[:shape]
    remove_particle(m)
    shoes.nostroke
    shoes.fill(shoes.red)
    expl1 = shoes.oval(:top => m.center.y - 30, :left => m.center.x - 30, :radius => 30)
    shoes.fill(shoes.yellow)
    expl2 = shoes.oval(:top => m.center.y - 15, :left => m.center.x - 15, :radius => 20)
    shoes.fill(shoes.black)
    shoes.timer(1.0) do expl1.remove end
    shoes.timer(1.5) do expl2.remove end
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
