require "math"

module CrystalEdge
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

    # Dot product
    def dot(other : Vector2)
      x*other.x + y*other.y
    end

    # Cross product
    def cross(other : Vector2)
      Vector2.new(self.x*other.y - self.y*other.x, self.y*other.x - self.x*other.y)
    end

    def **(other : Vector2)
      dot other
    end

    def %(other : Vector2)
      cross other
    end

    def magnitude
      Math.sqrt(self.x**2 + self.y**2)
    end

    def angle(other : Vector2)
      self**other / (self.magnitude * other.magnitude)
    end

    def +(other : Vector2)
      Vector2.new(self.x+other.x,self.y+other.y)
    end

    def +(other : Float64)
      Vector2.new(self.x+other,self.y+other)
    end

    def -(other : Vector2)
      Vector2.new(self.x-other.x,self.y-other.y)
    end

    def -(other : Float64)
      Vector2.new(self.x-other,self.y-other)
    end

    def -
      Vector2.new(-self.x,-self.y)
    end

    def *(other : Vector2)
      Vector2.new(self.x*other.x,self.y*other.y)
    end

    def *(other : Float64)
      Vector2.new(self.x*other, self.y * other)
    end

    def /(other : Vector2)
      Vector2.new(self.x/other.x,self.y/other.y)
    end

    def /(other : Float64)
      Vector2.new(self.x/other,self.y/other)
    end

    def clone(&b)
      yield clone if block_given?
      Vector2.new(self.x,self.y)
    end

    def normalize!
      m = magnitude
      self.x /= m
      self.y /= m
      self
    end

    def normalize
      self / magnitude
    end

    def find_normal_axis(other : Vector2)
      (self%other).normalize
    end

    def distance(other : Vector2)
      return (self-other).magnitude
    end

    #TODO : Add multipying by matrix

    def ==(other : Vector2)
      self.x == other.x && self.y == other.y #TODO : Comparsion with EPSILON
    end

    def !=(other : Vector2)
      self.x != other.x || self.y != other.y #TODO : Comparsion with EPSILON
    end
    
    def to_s
      "{X : #{x}; Y : #{y}}"
    end
  end
end
