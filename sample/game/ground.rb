require 'pongo/group'
class Ground < Pongo::Group
  include Pongo

  attr_accessor :units

  def initialize(renderer)
    super()
    @renderer = renderer
    @units = []
    unit_width = 80
    unit_height = 50
    10.times do |i|
      @units << rectangle(unit_width * i, 290 + rand(10), unit_width, unit_height, 
        :fixed => true, :elasticity => 0.8, :rotation => rand * 0.1 - 0.05)
    end
  end

  def draw
    return if @not_first

    @units.each do |unit|
      renderer.with(
        :transform => :center, 
        :rotate => -unit.angle,
        :fill => File.dirname(__FILE__) + '/assets/rock.png',
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

