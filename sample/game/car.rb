require 'pongo/group'
class Car < Pongo::Group
  include Pongo
  attr_accessor :wheel_a, :wheel_b

  def initialize(renderer)
    super
    @renderer = renderer
    #@wheel_a = wheel(140, 200, 14, :mass => 2)
    #@wheel_b = wheel(200, 200, 14, :mass => 2)
    @wheel_a = wheel(140, 200, 20, :mass => 2)
    @wheel_b = wheel(200, 200, 20, :mass => 2)
    @wheel_a.visible = false
    @wheel_b.visible = false
    connect(@wheel_a, @wheel_b, :collidable => true, :rect_height => 8)
    @image = renderer.shoes.image(
      File.dirname(__FILE__) + '/assets/car.gif',
      :left => center.x.to_i - 50,
      :top => center.y.to_i - 50
    )
  end

  def center
    (@wheel_a.center + @wheel_b.center) / 2.0
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

  def draw
    angle = (@wheel_a.center - @wheel_b.center).angle
    angle += 180 if @wheel_b.px < @wheel_a.px
    renderer.shoes.transform :center
    renderer.shoes.rotate(-angle)
    @image.remove
    @image = renderer.shoes.image(
      File.dirname(__FILE__) + '/assets/car.gif',
      :left => center.x.to_i - 50,
      :top => center.y.to_i - 50
    )
    renderer.shoes.rotate(angle)
=begin
    renderer.with(
      :rotate => (@wheel_a.center - @wheel_b.center).angle,
      :translation => :center
    ) do |shoes|
      @image.remove
      @image = renderer.shoes.image(
        File.dirname(__FILE__) + '/assets/car.gif',
        :left => (@wheel_a.px - @wheel_a.radius).to_i,
        :top => (@wheel_a.py - @wheel_a.radius).to_i - 40
      )
    end
=end

=begin
    @image.move(
      (@wheel_a.px - @wheel_a.radius).to_i,
      (@wheel_a.py - @wheel_a.radius).to_i - 40
    )
=end
  end
end
