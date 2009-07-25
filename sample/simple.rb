$: << File.dirname(__FILE__) + '/../lib'
require 'pongo'
require 'pongo/renderer/shoes_renderer'
require 'pongo/logger/shoes_logger'

include Pongo
Shoes.app :width => 500, :height => 350 do
  APEngine.renderer = Renderer::ShoesRenderer.new(self)
  APEngine.logger = Logger::ShoesLogger.new(self)
  APEngine.setup
  APEngine.add_force VectorForce.new(false, 0, 2)

  default_group = Group.new
  default_group.collide_internal = true

  default_group.add_particle(RectangleParticle.new(275, 90, 20, 30))
  default_group.add_particle(RectangleParticle.new(260, 50, 20, 30))

  rp = RectangleParticle.new(250, 250, 300, 50, :fixed => true)
  rp.always_redraw!
  default_group.add_particle(rp)

  cp = CircleParticle.new(250, 250, 50, :fixed => true)
  cp.always_redraw!
  #default_group.add_particle(cp)

=begin
  default_group.add_particle(CircleParticle.new(255, 150, 3))
  default_group.add_particle(CircleParticle.new(245, 100, 10))
  default_group.add_particle(CircleParticle.new(251, 50, 5))
  default_group.add_particle(CircleParticle.new(260, 70, 3))

  rp = RectangleParticle.new(250, 250, 300, 50, :fixed => true)
  rp.always_redraw!
  default_group.add_particle(rp)

  cp = CircleParticle.new(250, 250, 50, :fixed => true)
  cp.always_redraw!
  default_group.add_particle(cp)
=end

  APEngine.add_group(default_group)

  animate(60) do |anim|
    APEngine.step
    APEngine.draw
  end
end
