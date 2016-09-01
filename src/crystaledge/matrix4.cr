require "./matrix"
require "./vector3"
require "./quaternion"
require "math"

module CrystalEdge
  class Matrix4
    matrix(4, Float64)

    def *(other : Float64)
      return typeof(self).new { |i| self[i]*other }
    end

    def make_translation!(translation : Vector3)
      self[12] = translation.x
      self[13] = translation.y
      self[14] = translation.z
      self
    end

    def make_translation(translation : Vector3)
      clone.make_translation!(translation)
    end

    def translate(t : Vector3)
      self * make_translation(t)
    end

    def make_scaling!(s : Vector3)
      self[0] = s.x
      self[5] = s.y
      self[10] = s.z
      self
    end

    def make_scaling(s : Vector3)
      clone.make_scaling!(s)
    end

    def scale(s : Vector3)
      self * make_scaling(s)
    end

    def make_rotation!(r : Quaternion)
      self[0] = 1.0 - 2.0*(r.y**2 + r.z**2)
      self[1] = 2.0 * (r.x*r.y + r.z*r.w)
      self[2] = 2.0 * (r.x*r.z - r.y*r.w)
      self[4] = 2.0 * (r.x*r.y - r.z*r.w)
      self[5] = 1.0 - 2.0*(r.x**2 + r.z**2)
      self[6] = 2.0 * (r.y*r.z + r.x*r.w)
      self[8] = 2.0 * (r.z*r.x + r.y*r.w)
      self[9] = 2.0 * (r.y*r.z - r.x*r.w)
      self[10] = 1.0 - 2.0*(r.x**2 + r.y**2)
      self
    end

    def make_rotation!(r : Vector3)
      cx = Math.cos(r.x)
      sx = Math.sin(r.x)
      self[1, 1] = cx
      self[1, 2] = sx
      self[2, 1] = -sx
      self[2, 2] = cx

      cy = Math.cos(r.y)
      sy = Math.sin(r.y)
      self[0, 0] = cx
      self[0, 2] = -sx
      self[2, 0] = sx
      self[2, 2] = cx

      cz = Math.cos(r.z)
      sz = Math.cos(r.z)
      self[0, 0] = cz
      self[0, 1] = sz
      self[1, 0] = -sz
      self[1, 1] = cz

      self
    end

    def make_rotation(q : Quaternion)
      clone.make_rotation! q
    end

    def make_rotation(v : Vector3)
      clone.make_rotation! v
    end

    def rotate(q : Quaternion)
      self * make_rotation(q)
    end
  end

  class Vector3
    def *(other : Matrix4)
      Vector3.new(
        self.x*other[0, 0] + self.y*other[1, 0] + self.z*other[2, 0] + other[3, 0],
        self.x*other[0, 1] + self.y*other[1, 1] + self.z*other[2, 1] + other[3, 1],
        self.x*other[0, 2] + self.y*other[1, 2] + self.z*other[2, 2] + other[3, 2]
      )
    end
  end
end
