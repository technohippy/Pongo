$: << File.dirname(__FILE__) + '/..'
$: << File.dirname(__FILE__) + '/../../lib'
require 'pongo'
require 'pongo/renderer/shoes_renderer'
require 'pongo/logger/shoes_logger'
require 'cardemo/surfaces'
require 'cardemo/bridge'
require 'cardemo/capsule'
require 'cardemo/swing_door'
require 'cardemo/car'
require 'cardemo/rotator'

include Pongo

col_a = 0x334433
col_b = 0x3366aa
col_c = 0xaabbbb
col_d = 0x6699aa
col_e = 0x778877

Shoes.app :width => 650, :height => 350 do
  APEngine.renderer = Renderer::ShoesRenderer.new(self)
  APEngine.logger = Logger::ShoesLogger.new(self)
  APEngine.setup
  APEngine.gravity = VectorForce.new(false, 0, 3)

  surfaces = Surfaces.new(col_a, col_b, col_c, col_d, col_e)
  APEngine.add_group(surfaces)

  bridge = Bridge.new(col_b, col_c, col_d)
  APEngine.add_group(bridge)

  capsule = Capsule.new(col_c)
  APEngine.add_group(capsule)

  rotator = Rotator.new(col_b, col_e)
  APEngine.add_group(rotator)

  swing_door = SwingDoor.new(col_c)
  APEngine.add_group(swing_door)

  car = Car.new(col_c, col_e)
  APEngine.add_group(car)

  car.add_collidable_list(surfaces, bridge, rotator, swing_door, capsule)
  capsule.add_collidable_list(surfaces, bridge, rotator, swing_door)

  flow :top => 310, :left => 420 do
    button('left') {car.speed = -0.5}
    button('stop') {car.speed = 0}
    button('right') {car.speed = 0.5}
  end

  animate(24) do |anim|
    begin
      APEngine.step
      APEngine.draw
      rotator.rotate_by_radian(0.02)
    rescue
      APEngine.log($!)
      raise $!
    end
  end
end
