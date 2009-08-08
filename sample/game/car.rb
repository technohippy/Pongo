require 'pongo/group'
class Car < Pongo::Group
  include Pongo
  attr_accessor :wheel_a, :wheel_b

  def initialize(renderer)
    super
    @renderer = renderer
    @wheel_a = wheel(440, 200, 20, :mass => 2, :elasticity => 0.1)
    @wheel_b = wheel(500, 200, 20, :mass => 2, :elasticity => 0.1)
    @wheel_a.visible = false
    @wheel_b.visible = false
    @conn = connect(@wheel_a, @wheel_b, :collidable => true, :rect_height => 15)
    @wheel_a.user_data[:group] = self
    @wheel_b.user_data[:group] = self
    @conn.user_data[:group] = self
    @image = renderer.shoes.image(
      File.dirname(__FILE__) + '/assets/car.gif',
      :left => center.x.to_i - 50,
      :top => center.y.to_i - 50
    )
    @damage = 0
  end

  def center
    (@wheel_a.center + @wheel_b.center) / 2.0
  end

  def speed=(s)
    @wheel_a.angular_velocity = s
    @wheel_b.angular_velocity = s
  end

  def jump
    power = 150
    dir = (@wheel_a.center - @wheel_b.center).rotate(Math::PI/2).normalize * power
    @wheel_a.add_force(VectorForce.new(true, dir.x, dir.y))
    @wheel_b.add_force(VectorForce.new(true, dir.x, dir.y))
  end

  def damage
    @damage += 1
    if 2 < @damage
      vanish!
    end
  end

  def vanish!
    shoes = renderer.shoes
    shoes.nostroke
    shoes.fill(shoes.red)
    expl1 = shoes.oval(:top => center.y - 50, :left => center.x - 50, :radius => 50)
    shoes.fill(shoes.yellow)
    expl2 = shoes.oval(:top => center.y - 20, :left => center.x - 20, :radius => 25)
    shoes.fill(shoes.black)
    shoes.timer(1.0) do expl1.remove end
    shoes.timer(1.5) do expl2.remove end

    @image.remove
    remove_particle(@wheel_a)
    remove_particle(@wheel_b)
    remove_constraint(@conn)
    @dead = true

    shoes.timer(5) do shoes.close end
  end

  def draw
    return if @dead

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
    if upsidedown?
      self.speed = 0
    end
  end

  def upsidedown?
    0 < @wheel_a.px - @wheel_b.px
  end
end
