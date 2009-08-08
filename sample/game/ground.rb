require 'pongo/group'
class Ground < Pongo::Group
  include Pongo

  attr_accessor :units

  def initialize(renderer)
    super()
    @renderer = renderer
    @units = []
    grand_base = 300
    unit_interval = 80
    unit_width = 100
    unit_height = 100
    lean_range = 0.3
    10.times do |i|
      @units << rectangle(unit_interval * i, grand_base + rand(30), unit_width, unit_height, 
        :fixed => true, :elasticity => 0.8, :rotation => rand * lean_range * 2 - lean_range)
    end
  end

  def draw
    return if @not_first

    @units.each do |unit|
      renderer.with(
        :transform => :center, 
        :rotate => -unit.angle,
        :fill => File.dirname(__FILE__) + '/assets/ground.png',
        :nostroke => true
      ) do |shoes|
        unit.user_data[:shape] = shoes.rect(
          :left => (unit.px - unit.width/2), 
          :top => (unit.py - unit.height/2), 
          :width => unit.width, 
          :height => unit.height
        )
      end
    end
    @not_first = true
  end
end

