require 'pongo/group'

class Wall < Pongo::Group
  include Pongo

  def initialize
    super
    rectangle(-25, 100, 50, 500, :fixed => true).visible = false
    rectangle(735, 100, 50, 500, :fixed => true).visible = false
  end
end
