require 'pongo/abstract_item'

module Pongo
  # The abstract base class for all constraints. 
  #
  # You should not instantiate this class directly -- instead use one of the subclasses.
  class AbstractConstraint < AbstractItem
    # The stiffness of the constraint. Higher values result in result in 
    # stiffer constraints. Values should be > 0 and <= 1. Depending on the situation, 
    # setting constraints to very high values may result in instability.
    attr_accessor :stiffness

    def initialize(stiffness)
      super()
      @stiffness = stiffness
      set_style
    end

    # Corrects the position of the attached particles based on their position and
    # mass. This method is called automatically during the APEngine.step() cycle.
    def resolve
      raise SubclassResponsibilityError
    end
  end
end
