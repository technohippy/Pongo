require 'pongo/group'
class Ground < Pongo::Group
  include Pongo

  attr_accessor :units
  def initialize
    super
    @units = []
    unit_width = 80
    unit_height = 50
    10.times do |i|
      @units << rectangle(unit_width * i, 300 + rand(10), unit_width, unit_height, 
        :fixed => true, :elasticity => 0.8, :rotation => rand * 0.1 - 0.05)
    end
  end
end

