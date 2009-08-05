$: << File.dirname(__FILE__) + '/../../lib'
$: << File.dirname(__FILE__) + '/..'
require 'pongo'
require 'pongo/container/shoes_container'
require 'game/car'
require 'game/ground'
require 'game/meteors'

include Pongo
width = 720
height = 300
Shoes.app :width => width, :height => height do
  APEngine.setup :gravity => 2.0, :damping => 0.97, 
    :container => Container::ShoesContainer.new(self)

  ground = Ground.new
  APEngine << ground

  meteors = Meteors.new
  meteors.add_collidable_list(ground)
  APEngine << meteors

  car = Car.new
  car.add_collidable_list(ground, meteors)
  APEngine << car


  animate(60) do |anim|
    if anim % 180 == 0
      meteors.shoot!
    end
    APEngine.next_frame
  end
  motion do |left, top|
    car.speed = (left - width/2.0) / 600.0
  end
  click do |button, left, top|
    car.jump
  end
end
