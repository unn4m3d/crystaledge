require "./matrix"
require "./vector2"
require "math"

module CrystalEdge
  class Matrix3
    matrix(3, Float64)

    def *(other : Float64)
      return typeof(self).new { |i| self[i]*other }
    end

    def make_translation!(translation : Vector2)
      self[0, 2] = translation.x
      self[1, 2] = translation.y
      self
    end

    def make_translation(translation : Vector2)
      clone.make_translation!(translation)
    end

    def translate(t : Vector2)
      self * make_translation(t)
    end

    def make_scaling!(s : Vector2)
      self[0, 0] = s.x
      self[1, 1] = s.y
      self
    end

    def make_scaling(s : Vector2)
      clone.make_scaling!(s)
    end

    def scale(s : Vector2)
      self * make_scaling(s)
    end

    def make_rotation!(a : Float64)
      c = Math.cos(a)
      s = Math.sin(a)
      self[0, 0] = c
      self[0, 1] = s
      self[1, 0] = -s
      self[1, 2] = c
      self
    end

    def make_rotation(a : Float64)
      clone.make_rotation!
    end

    def rotate(a : Float64)
      self * make_rotation(a)
    end
  end

  class Vector2
    def *(other : Matrix3)
      Vector2.new(
        self.x*other[0, 0] + self.y*other[1, 0] + other[2, 0],
        self.x*other[0, 1] + self.y*other[1, 1] + other[2, 1]
      )
    end
  end
end
