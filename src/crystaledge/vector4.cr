require "math"

module CrystalEdge
  class Vector4
    getter x,y,z,w
    setter x,y,z,w

    @x : Float64
    @y : Float64
    @z : Float64
    @w : Float64

    def initialize(@x,@y,@z,@w : Float64)
    end

    # Zero vector
    def self.zero
      return Vector4.new(0.0,0.0,0.0,0.0)
    end

    # Dot product
    def dot(other : Vector4)
      x*other.x + y*other.y + z*other.z
    end

    # Cross product
    def cross(other : Vector4)
      Vector4.new(
        self.y*other.z - self.z*other.y,
        self.z*other.x - self.x*other.z,
        self.x*other.y - self.y*other.x,
        0
      )
    end

    def **(other : Vector4)
      dot other
    end

    def %(other : Vector4)
      cross other
    end

    def magnitude
      Math.sqrt(self.x**2 + self.y**2 + self.z**2 + self.w**2)
    end

    def +(other : Vector4)
      Vector4.new(self.x+other.x,self.y+other.y,self.z+other.z,self.w+other.w)
    end

    def +(other : Float64)
      Vector4.new(self.x+other,self.y+other,self.z+other,self.w+other)
    end

    def -(other : Vector4)
      Vector4.new(self.x-other.x,self.y-other.y,self.z-other.z,self.w-other.w)
    end

    def -(other : Float64)
      Vector4.new(self.x-other,self.y-other,self.z-other,self.w-other)
    end

    def -
      Vector4.new(-self.x,-self.y,-self.z,-self.w)
    end

    def *(other : Vector4)
      Vector4.new(self.x*other.x,self.y*other.y,self.z*other.z,self.w*other.w)
    end

    def *(other : Float64)
      Vector4.new(self.x*other, self.y * other, self.z * other, self.w * other)
    end

    def /(other : Vector4)
      Vector4.new(self.x/other.x,self.y/other.y,self.z/other.z,self.w/other.w)
    end

    def /(other : Float64)
      Vector4.new(self.x/other,self.y/other,self.z/other,self.w/other)
    end

    def clone(&b)
      yield clone if block_given?
      Vector4.new(self.x,self.y,self.z,self.w)
    end

    def normalize!
      m = magnitude
      unless m == 0
        self.x /= m
        self.y /= m
        self.z /= m
        self.w /= m
      end
      self
    end

    def normalize
      if m == 0
        self
      else
        self / magnitude
      end
    end

    def distance(other : Vector4)
      return (self-other).magnitude
    end

    def ==(other : Vector4)
      self.x == other.x && self.y == other.y && self.z == other.z && self.w == other.w #TODO : Comparsion with EPSILON
    end

    def !=(other : Vector4)
      self.x != other.x || self.y != other.y || self.z != other.z || self.w != other.w #TODO : Comparsion with EPSILON
    end

    def to_s
      "{X : #{x}; Y : #{y}, Z : #{z}, W: : #{w}}"
    end
  end
end
