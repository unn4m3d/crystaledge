require "math"
require "../crystaledge"

module CrystalEdge
  struct Vector3
    property x, y, z

    @x : Float64
    @y : Float64
    @z : Float64

    def values
      {@x, @y, @z}
    end

    def initialize(@x, @y, @z : Float64)
    end

    def initialize(matrix : Matrix(Float64, N, M)) forall N, M
      @x = matrix[0]
      @y = matrix[1]
      @z = matrix[2]
    end

    def initialize(angle : Vector3, length : Float64 = 1.0)
      vec = Vector3.new(
        Math.tan(angle.y),
        1.0 / Math.tan(angle.x),
        1.0
      ).normalize * length


      #vec = Vector3.new(
      #  Math.sin(angle.y),
      #  Math.sin(angle.z),
      #  Math.sin(angle.x)
      #).normalize * length
      @x, @y, @z = vec.x, vec.y, vec.z
    end

    # Zero vector
    def self.zero
      Vector3.new(0.0, 0.0, 0.0)
    end

    def zero!
      @x = @y = @z = 0.0
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
      Vector3.new(self.x + other.x, self.y + other.y, self.z + other.z)
    end

    def +(other : Float64)
      Vector3.new(self.x + other, self.y + other, self.z + other)
    end

    def -(other : Vector3)
      Vector3.new(self.x - other.x, self.y - other.y, self.z - other.z)
    end

    def -(other : Float64)
      Vector3.new(self.x - other, self.y - other, self.z - other)
    end

    def -
      Vector3.new(-self.x, -self.y, -self.z)
    end

    def *(other : Vector3)
      Vector3.new(self.x*other.x, self.y*other.y, self.z*other.z)
    end

    def *(other : Float64)
      Vector3.new(self.x*other, self.y * other, self.z*other)
    end

    def /(other : Vector3)
      Vector3.new(self.x/other.x, self.y/other.y, self.z/other.z)
    end

    def /(other : Float64)
      # Multiply by the inverse => only do 1 division instead of 3
      self * (1.0 / other)
    end

    def clone
      Vector3.new(self.x, self.y, self.z)
    end

    def clone(&b)
      c = clone
      b.call c
      c
    end

    def normalize!
      m = magnitude
      unless m == 0
        inverse = 1.0 / m
        self.x *= inverse
        self.y *= inverse
        self.z *= inverse
      end
      self
    end

    def normalize
      clone.normalize!
    end

    def find_normal_axis(other : Vector3)
      (self % other).normalize
    end

    def distance(other : Vector3)
      return (self - other).magnitude
    end

    def ==(other : self)
      (self.x - other.x).abs <= EPSILON &&
      (self.y - other.y).abs <= EPSILON &&
      (self.z - other.z).abs <= EPSILON
    end

    def !=(other : Vector3)
      !(self == other)
    end

    def to_s
      "{X : #{x}; Y : #{y}; Z : #{z}}"
    end

    def rotate(q : Quaternion)
      quat = q * self * q.conjugate
      Vector3.new(quat.x, quat.y, quat.z)
    end

    def angle
      Vector3.new(
        Math.atan2(self.z, self.y),
        Math.atan2(self.x, self.z),
        Math.atan2(self.y, self.x)
      )
    end

    def heading
      angle
    end

    def rotate(euler : Vector3)
      rz = Matrix3.new.make_rotation! euler.x, 0.0, 0.0, 1.0
      rx = Matrix3.new.make_rotation! euler.y, 1.0, 0.0, 0.0
      rz2 = Matrix3.new.make_rotation! euler.z, 0.0, 0.0, 1.0

      r = rz * rx * rz2

      puts rz
      puts rx
      puts rz2
      puts r

      v = Vector3.new(r * Matrix(Float64, 3, 1).new { |i| self.values[i] })
      puts v
      v
    end
  end
end
