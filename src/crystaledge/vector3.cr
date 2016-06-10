require "math"

module CrystalEdge
  class Vector3
    getter x,y,z
    setter x,y,z

    @x : Float64
    @y : Float64
    @z : Float64

    def initialize(@x,@y,@z : Float64)
    end

    # Zero vector
    def self.zero
      return Vector3.new(0.0,0.0,0.0)
    end

    # Dot product
    def dot(other : Vector3)
      x*other.x + y*other.y + z*other.z
    end

    # Cross product
    def cross(other : Vector3)
      Vector3.new(
        y*other.z - z*other.y,
        z*other.x - x*other.z,
        x*other.y - y*other.x
      )
    end

    def **(other : Vector3)
      dot other
    end

    def %(other : Vector3)
      cross other
    end

    def magnitude
      Math.sqrt(self.x**2 + self.y**2 + self.z**2)
    end

    def angle(other : Vector3)
      2.0 * Math.acos(self**other / (self.magnitude * other.magnitude))
    end

    def +(other : Vector3)
      Vector3.new(self.x+other.x,self.y+other.y,self.z+other.z)
    end

    def +(other : Float64)
      Vector3.new(self.x+other,self.y+other,self.z+other)
    end

    def -(other : Vector3)
      Vector3.new(self.x-other.x,self.y-other.y,self.z-other.z)
    end

    def -(other : Float64)
      Vector3.new(self.x-other,self.y-other,self.z-other)
    end

    def -
      Vector3.new(-self.x,-self.y,-self.z)
    end

    def *(other : Vector3)
      Vector3.new(self.x*other.x,self.y*other.y,self.z*other.z)
    end

    def *(other : Float64)
      Vector3.new(self.x*other, self.y * other,self.z*other)
    end

    def /(other : Vector3)
      Vector3.new(self.x/other.x,self.y/other.y,self.z/other.z)
    end

    def /(other : Float64)
      Vector3.new(self.x/other,self.y/other,self.z/other)
    end

    def clone(&b)
      yield clone if block_given?
      Vector3.new(self.x,self.y,self.z)
    end

    def normalize!
      m = magnitude
      unless m == 0
        self.x /= m
        self.y /= m
        self.z /= m
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

    def find_normal_axis(other : Vector3)
      (self%other).normalize
    end

    def distance(other : Vector3)
      return (self-other).magnitude
    end

    #TODO : Add multipying by matrix

    def ==(other : Vector3)
      self.x == other.x && self.y == other.y && self.z == other.z#TODO : Comparsion with EPSILON
    end

    def !=(other : Vector3)
      self.x != other.x || self.y != other.y || self.z != other.z #TODO : Comparsion with EPSILON
    end

    def to_s
      "{X : #{x}; Y : #{y}; Z : #{z}}"
    end

    #TODO : Rotation and reflection
  end
end