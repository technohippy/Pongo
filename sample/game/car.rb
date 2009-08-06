require 'pongo/group'
class Car < Pongo::Group
  include Pongo
  attr_accessor :wheel_a, :wheel_b

  def initialize(renderer)
    super
    @renderer = renderer
    @wheel_a = wheel(140, 200, 14, :mass => 2)
    @wheel_b = wheel(200, 200, 14, :mass => 2)
    connect(@wheel_a, @wheel_b, :collidable => true, :rect_height => 8)
  end

  def speed=(s)
    @wheel_a.angular_velocity = s
    @wheel_b.angular_velocity = s
  end

  def jump
    dir = (@wheel_a.center - @wheel_b.center).rotate(Math::PI/2).normalize * 300
    @wheel_a.add_force(VectorForce.new(true, dir.x, dir.y))
    @wheel_b.add_force(VectorForce.new(true, dir.x, dir.y))
  end
end
