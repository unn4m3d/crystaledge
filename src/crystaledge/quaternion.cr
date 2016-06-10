require "math"
require "./vector3"

module CrystalEdge
  class Quaternion
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
      return Quaternion.new(0.0,0.0,0.0,0.0)
    end

    # Dot product
    def dot(other : Quaternion)
      x*other.x + y*other.y + z*other.z
    end

    def **(other : Quaternion)
      dot other
    end

    def norm
      self.x**2 + self.y**2 +self.z**2 + self.w**2
    end

    def magnitude
      Math.sqrt(self.x**2 + self.y**2 + self.z**2 + self.w**2)
    end

    def +(other : Quaternion)
      Quaternion.new(self.x+other.x,self.y+other.y,self.z+other.z,self.w+other.w)
    end


    def -(other : Quaternion)
      Quaternion.new(self.x-other.x,self.y-other.y,self.z-other.z,self.w-other.w)
    end

    def -
      Quaternion.new(-self.x,-self.y,-self.z,-self.w)
    end

    def *(other : Quaternion)
      Quaternion.new(self.x*other.x,self.y*other.y,self.z*other.z,self.w*other.w)
    end

    def *(other : Vector3)
      Quaternion.new(
        self.w * other.x + self.y * other.z - self.z * other.y,
        self.w * other.y - self.x * other.z + self.z * other.x,
        self.w * other.z + self.x * other.y - self.y * other.x,
        0 - self.x*other.x - self.y*other.y - self.z * other.z
      )
    end

    def *(other : Float64)
      Quaternion.new(self.x*other, self.y * other, self.z * other, self.w * other)
    end

    def inverse
      if norm == 0.0
        self
      else
        self.conjugate.normalize
      end
    end

    def conjugate
      Quaternion.new(-self.x,-self.y,-self.z,self.w)
    end

    def pure?
      self.w == 0.0
    end

    def unit?
      norm == 1.0
    end

    def axis
      Vector3.new(x,y,z)
    end

    def axis=(v : Vector3)
      @x,@y,@z = v.x,v.y,v.z
    end

    def angle
      @w
    end

    def angle=(v : Float64)
      @w = v
    end

    def clone(&b)
      yield clone if block_given?
      Quaternion.new(self.x,self.y,self.z,self.w)
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


    def ==(other : Quaternion)
      self.x == other.x && self.y == other.y && self.z == other.z && self.w == other.w #TODO : Comparsion with EPSILON
    end

    def !=(other : Quaternion)
      self.x != other.x || self.y != other.y || self.z != other.z || self.w != other.w #TODO : Comparsion with EPSILON
    end

    def to_s
      "{X : #{x}; Y : #{y}, Z : #{z}, W: : #{w}}"
    end

    def self.lerp(qstart,qend : Quaternion,percent : Float64)
      if percent == 0
        return qstart
      elsif percent == 1
        return qend
      else
        f1 = 1.0 - percent
        f2 = percent

        return Quaternion.new(
          f1 * qstart.x + f2 * qend.x,
          f1 * qstart.y + f2 * qend.y,
          f1 * qstart.z + f2 * qend.z,
          f1 * qstart.w + f2 * qend.w
        )
      end
    end

    def self.nlerp(qstart, qend : Quaternion, percent : Float64)
      lerp(qstart,qend,percent).normalize
    end

    def self.slerp(qstart,qend : Quaternion, percent : Float64)
      if percent == 0
        return qstart
      elsif percent == 1
        return qend
      else
        dot = qstart**qend
        if dot == 0
          return lerp(qstart,qend,percent)
        elsif dot < 0
          return -slerp(qstart,-qend,percent)
        else
          dot = dot.clamp(-1.0,1.0)
          theta = Math.acos(dot)
          s = Math.sin(theta)
          f1 = Math.sin((1.0 - percent) * theta) / s
          f1 = Math.sin(percent * theta) / s
          return Quaternion.new(
            f1 * qstart.x + f2 * qend.x,
            f1 * qstart.y + f2 * qend.y,
            f1 * qstart.z + f2 * qend.z,
            f1 * qstart.w + f2 * qend.w
          )
        end
      end
    end
  end

  class Vector3
    def rotate(q : Quaternion)
      qi = q.conjugate
      qq = (q*self)*qi
      Vector3.new(
        qq.x,
        qq.y,
        qq.z
      )
    end

    def reflect(q : Quaternion)
      qq = ((q*self)*q).normalize
      Vector3.new(
        qq.x,
        qq.y,
        qq.z
      )
    end
  end
end
