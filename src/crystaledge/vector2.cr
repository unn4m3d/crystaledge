require "math"

module CrystalEdge
  # Representation of 2D vector
  class Vector2
    property x, y
    @x : Float64
    @y : Float64

    def initialize(@x, @y)
    end

    # Zero vector
    def self.zero
      return Vector2.new(0.0, 0.0)
    end

    def zero!
      @x = @y = 0.0
    end

    # Returns dot product of two vectors
    def dot(other : Vector2)
      x*other.x + y*other.y
    end

    # Returns cross product of two vectors
    def cross(other : Vector2)
      Vector2.new(self.x*other.y - self.y*other.x, self.y*other.x - self.x*other.y)
    end

    # Alias for dot product
    def **(other : Vector2)
      dot other
    end

    # Alias for cross product
    def %(other : Vector2)
      cross other
    end

    # Returns magnitude of this vector
    def magnitude
      Math.sqrt(self.x**2 + self.y**2)
    end

    # Returns angle between two vectors
    def angle(other : Vector2)
      self**other / (self.magnitude * other.magnitude)
    end

    # Performs component addition
    def +(other : Vector2)
      Vector2.new(self.x + other.x, self.y + other.y)
    end

    # Performs component addition
    def +(other : Float64)
      Vector2.new(self.x + other, self.y + other)
    end

    # Performs component subtraction
    def -(other : Vector2)
      Vector2.new(self.x - other.x, self.y - other.y)
    end

    # Performs component subtraction
    def -(other : Float64)
      Vector2.new(self.x - other, self.y - other)
    end

    # Returns negated vector
    def -
      Vector2.new(-self.x, -self.y)
    end

    # Performs component multiplication (for dot product see `#dot`)
    def *(other : Vector2)
      Vector2.new(self.x*other.x, self.y*other.y)
    end

    # Performs multiplication
    def *(other : Float64)
      Vector2.new(self.x*other, self.y * other)
    end

    # Performs component division
    def /(other : Vector2)
      Vector2.new(self.x/other.x, self.y/other.y)
    end

    # Performs division
    def /(other : Float64)
      # Multiply by the inverse => only do 1 division instead of 3
      self * (1.0 / other)
    end

    # Clones this vector and passes it into a block if given
    def clone
      Vector2.new(self.x, self.y)
    end

    def clone(&b)
      c = clone
      b.call c
      c
    end

    # Normalizes current vector
    def normalize!
      m = magnitude
      unless m == 0
        inverse = 1.0 / m
        self.x *= inverse
        self.y *= inverse
      end
      self
    end

    # Non-aggressive version of `#normalize!`
    def normalize
      if m == 0
        self
      else
        self / magnitude
      end
    end

    # Finds normal axis between two vectors
    def find_normal_axis(other : Vector2)
      (self % other).normalize
    end

    # Finds distance between two vectors
    def distance(other : Vector2)
      return (self - other).magnitude
    end

    def ==(other : Vector2)
      self.x == other.x && self.y == other.y
    end

    def !=(other : Vector2)
      self.x != other.x || self.y != other.y
    end

    # Formats vector
    def to_s
      "{X : #{x}; Y : #{y}}"
    end
  end
end
