module Pongo
  class AbstractConstraint
    attr_accessor :stiffness

    def initialize(stiffness)
      @stiffness = stiffness
      set_style
    end
  end
end
