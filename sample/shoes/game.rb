$: << File.dirname(__FILE__) + '/../../lib'
$: << File.dirname(__FILE__) + '/..'
require 'pongo'
require 'pongo/container/shoes_container'
require 'game/car'
require 'game/ground'
require 'game/meteors'
require 'game/wall'

include Pongo
width = 720
height = 300
Shoes.app :width => width, :height => height do
  image(File.dirname(__FILE__) + '/../game/assets/sunset.png')
  container = Container::ShoesContainer.new(self)
  APEngine.setup :gravity => 3.0, :damping => 0.985, :container => container

  ground = Ground.new(container.renderer)
  APEngine << ground

  meteors = Meteors.new(container.renderer)
  meteors.add_collidable_list(ground)
  APEngine << meteors

  wall = Wall.new
  APEngine << wall

  car = Car.new(container.renderer)
  car.add_collidable_list(ground, meteors, wall)
  APEngine << car

  animate(60) do |anim|
    if anim % 180 == 0
      meteors.shoot!
    end
    APEngine.next_frame
  end
  keypress do |key|
    info key.inspect
    case key
    when :right;   car.speed = 20
    when :left;    car.speed = -20
    when :down;    car.speed = 0
    when ' ', :up; car.jump
    end
  end
end
