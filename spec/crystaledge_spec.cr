require "./spec_helper"

alias V2 = CrystalEdge::Vector2
alias V3 = CrystalEdge::Vector3
alias V4 = CrystalEdge::Vector4
alias Q = CrystalEdge::Quaternion
alias M3 = CrystalEdge::Matrix3
alias M4 = CrystalEdge::Matrix4

describe CrystalEdge::Vector2 do
  it "works" do
    vec1 = V2.new(1.0, 2.0)
    vec2 = V2.new(3.0, 4.0)
    vsum = V2.new(4.0, 6.0)
    vdif = V2.new(-2.0, -2.0)
    vec3 = V2.new(-1.0, -2.0)

    (vec1 - vdif).should eq(vec2)
    (vec1 == vec2).should eq(false)
    (vec1 + vec2).should eq(vsum)
    (vec1 - vec2).should eq(vdif)
    (vec1 * vec2).should eq(V2.new(3.0, 8.0))
    (vec1 * 2.0).should eq(V2.new(2.0, 4.0))
    vec1.should eq(-vec3)
    V2.new(3.0, 4.0).magnitude.should eq(5.0)
    (V2.new(0.0, 3.0).distance(V2.new(4.0, 0.0))).should eq(5.0)
    vec1.should eq(vec1)

    vzero = V2.zero
    vec1.zero!
    vec1.should eq(vzero)
    vec1.x = 42.0
    vec1.should_not eq(vzero)
    vec1.should eq(V2.new(42.0, 0.0))
    vec1.normalize.magnitude.should eq(1.0)

    vec1.angle.should eq(0.0)
  end
end

describe CrystalEdge::Vector3 do
  it "works" do
    vec1 = V3.zero
    vec2 = V3.new(3.0, 4.0, 0.0)
    (vec1 == vec2).should eq(false)
    (vec1 + vec2).should eq(vec2)
    (vec1 - vec2).should eq(-vec2)
    (vec1*vec2).should eq(vec1)

    vec3 = V3.new(1.0, 2.0, 3.0)

    (vec2 * vec3).should eq(V3.new(3.0, 8.0, 0.0))

    vec4 = V3.new(0.0, 3.0, 4.0)
    vec5 = V3.new(3.0, 0.0, 4.0)
    m = 5.0
    vec2.magnitude.should eq(5)
    vec4.magnitude.should eq(5)
    vec5.magnitude.should eq(5)
    (vec5*2.0).magnitude.should eq(10)

    vzero = V3.zero
    vec5.zero!

    vec5.should eq(vzero)
    vec5.x = 42.0
    vec5.should_not eq(vzero)
    vec5.should eq(V3.new(42.0, 0.0, 0.0))
    vec5.normalize.magnitude.should eq(1.0)
  end
end

describe CrystalEdge::Vector4 do
  it "passes Vector4 tests" do
    vec1 = V4.zero
    vec2 = V4.new(1.0, 2.0, 3.0, 4.0)
    vec3 = vec2.clone
    vec3.should eq(vec2)
    (vec2 + vec3).should eq(vec2*2.0)
    (vec2 - vec1).should eq(vec2)
    (vec2*vec3).should eq(V4.new(1.0, 4.0, 9.0, 16.0))

    vzero = V4.zero
    vec1.zero!

    vec1.should eq(vzero)
    vec1.x = 42.0
    vec1.should_not eq(vzero)
    vec1.should eq(V4.new(42.0, 0.0, 0.0, 0.0))
    vec1.normalize.magnitude.should eq(1.0)
  end
end

describe CrystalEdge::Quaternion do
  it "works" do
    q1 = Q.new(1.0, 1.0, 1.0, 1.0)
    q2 = Q.new(-1.0, -1.0, -1.0, 1.0)
    q3 = Q.new(1.0, 1.0, 1.0, -1.0)
    q1.conjugate.should eq(q2)
    (-(q1.conjugate)).should eq(q3)
    (q2 + q3).should eq(Q.zero)
  end
end

describe CrystalEdge::Matrix3 do
  it "works" do
    m0 = M3.new { |i| 0.0 }
    m1 = M3.new { |i| i.to_f }
    m2 = M3.new { |i| 2.0*i }

    m1.should_not eq(m2)
    (m1 != m2).should eq(true)
    m0.should eq(m0)
    (m0 + m1).should eq(m1)
    (m1*2.0).should eq(m2)

    m0.make_translation!(V2.new(2.0, 3.0))
    m0.matrix.to_a.should eq([1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 2.0, 3.0, 1.0])

    m3 = M3.new(0.0)
    m4 = M3.new(0.0)
    m4[8] = 1.0
    m3.should_not eq(m4)
  end

  it "is column-major" do
    mat = M3.new do |r, c|
      c * 10.0 + r
    end

    mat.matrix.to_a.should eq([0.0, 1.0, 2.0, 10.0, 11.0, 12.0, 20.0, 21.0, 22.0])
  end

  it "can be printed nicely" do 
    m0 = M3.new { |i,j| (i+j).to_f64 }

    io = IO::Memory.new
    m0.to_s io

    io.to_s.should eq %(| 0.0  1.0  2.0 |\n| 1.0  2.0  3.0 |\n| 2.0  3.0  4.0 |\n)
  end
end

describe CrystalEdge::Matrix4 do
  it "works" do
    m0 = M4.new { |i| 0.0 }
    m1 = M4.new { |i| i.to_f }
    m2 = M4.new { |i| 2.0*i }

    (m1 == m2).should eq(false)
    (m1 != m2).should eq(true)
    (m0 == m0).should eq(true)
    (m0 + m1).should eq(m1)
    (m1*2.0).should eq(m2)
  end
end

describe CrystalEdge do
  it "converts Quaternion and Euler angles" do
    ea = V3.new(1.0, 2.0, Math::PI)
    q = Q.from_euler(ea)
    q.to_euler.should eq(ea)
  end

  it "constructs Vector3 from angle and magnitude" do
    vec = V3.new(1.0, 2.0, 3.0)
    V3.new(vec.angle, vec.magnitude).should eq(vec)
  end

  it "rotates Vector3" do
    vec = CrystalEdge::Vector3.new 1.0, 0.0, 0.0

    vec2 = vec.rotate(CrystalEdge::Vector3.new(0.0, 0.0, Math::PI/2))

    vec2.x.should be_close(0, 0.001)
    vec2.y.should be_close(1, 0.001)
    vec2.z.should be_close(0, 0.001)

    vec2 = vec2.rotate(CrystalEdge::Vector3.new(Math::PI/2, 0.0, 0.0))

    vec2.x.should be_close(-1, 0.001)
    vec2.y.should be_close(0, 0.001)
    vec2.z.should be_close(0, 0.001)

  end
end
