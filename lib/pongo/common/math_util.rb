module Pongo
  module MathUtil
    ONE_EIGHTY_OVER_PI = 180.0 / Math::PI;
    PI_OVER_ONE_EIGHTY = Math::PI / 180.0;

    module_function

    def clamp(n, min, max)
      if    n < min; min
      elsif max < n; max
      else         ; n
      end
    end

    def sign(val)
      val < 0 ? -1 : 1
    end

    def max(v1, v2)
      v1 < v2 ? v2 : v1
    end

    def min(v1, v2)
      v1 < v2 ? v1 : v2
    end
  end
end
