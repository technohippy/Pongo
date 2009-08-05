$: << File.dirname(__FILE__) + '/../../lib'
require 'pongo'
require 'pongo/container/shoes_container'

include Pongo
Shoes.app :width => 700, :height => 600 do
  APEngine.setup :gravity => 2.0, :damping => 0.97, 
    :container => Container::ShoesContainer.new(self)

  APEngine.create_group do |g|
    g.circle(155, 140, 15)
    g.wheel(245, 140, 30)
    g.rectangle(80, 150, 10, 80, :rotation => 0.2)
    g.rectangle(550, 450, 300, 20, :rotation => 2.5, :fixed => true, :elasticity => 1, :always_redraw => true)
    g.rectangle(250, 300, 450, 20, :rotation => 0.2, :fixed => true, :elasticity => 1, :always_redraw => true)
    point1 = g.circle(340, 120, 5, :elasticity => 4)
    point2 = g.circle(380, 120, 5, :elasticity => 4)
    point3 = g.circle(380, 160, 5, :elasticity => 4)
    g.connect(point1, point2, :stiffness => 0.8)
    g.connect(point2, point3, :stiffness => 0.8)
    g.connect(point3, point1, :stiffness => 0.8)
  end

  animate(60) do |anim|
    APEngine.next_frame
  end
end
