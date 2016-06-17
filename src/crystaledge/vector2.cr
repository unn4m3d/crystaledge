require "math"

module CrystalEdge
  #Representation of 2D vector
  class Vector2
    getter x,y
    setter x,y

    @x : Float64
    @y : Float64

    def initialize(@x,@y : Float64)
    end

    # Zero vector
    def self.zero
      return Vector2.new(0.0,0.0)
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
      Vector2.new(self.x+other.x,self.y+other.y)
    end

    # Performs component addition
    def +(other : Float64)
      Vector2.new(self.x+other,self.y+other)
    end

    # Performs component subtraction
    def -(other : Vector2)
      Vector2.new(self.x-other.x,self.y-other.y)
    end

    # Performs component subtraction
    def -(other : Float64)
      Vector2.new(self.x-other,self.y-other)
    end

    # Returns negated vector
    def -
      Vector2.new(-self.x,-self.y)
    end

    # Performs component multiplication (for dot product see `#dot`)
    def *(other : Vector2)
      Vector2.new(self.x*other.x,self.y*other.y)
    end

    # Performs multiplication
    def *(other : Float64)
      Vector2.new(self.x*other, self.y * other)
    end
    # Performs component division
    def /(other : Vector2)
      Vector2.new(self.x/other.x,self.y/other.y)
    end

    # Performs division
    def /(other : Float64)
      Vector2.new(self.x/other,self.y/other)
    end

    # Clones this vector and passes it into a block if given
    def clone(&b)
      yield clone if block_given?
      Vector2.new(self.x,self.y)
    end

    # Normalizes current vector
    def normalize!
      m = magnitude
      unless m == 0
        self.x /= m
        self.y /= m
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
      (self%other).normalize
    end

    # Finds distance between two vectors
    def distance(other : Vector2)
      return (self-other).magnitude
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
