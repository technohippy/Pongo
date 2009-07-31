module Pongo
  class Interval
    attr_accessor :min, :max

    def initialize(min=0, max=0)
      @min, @max = min, max
    end

    def to_s
      "#{@min} : #{@max}"
    end
  end
end
