require "./spec_helper"

alias V2 = CrystalEdge::Vector2
alias V3 = CrystalEdge::Vector3
alias V4 = CrystalEdge::Vector4
alias Q  = CrystalEdge::Quaternion
alias M3 = CrystalEdge::Matrix3
alias M4 = CrystalEdge::Matrix4

describe CrystalEdge do
  it "passes Vector2 tests" do
    vec1 = V2.new(1.0,2.0)
    vec2 = V2.new(3.0,4.0)
    vsum = V2.new(4.0,6.0)
    vdif = V2.new(-2.0,-2.0)
    vec3 = V2.new(-1.0,-2.0)

    (vec1 - vdif).should eq(vec2)
    (vec1 == vec2).should eq(false)
    (vec1 + vec2).should eq(vsum)
    (vec1 - vec2).should eq(vdif)
    (vec1 * vec2).should eq(V2.new(3.0,8.0))
    (vec1 * 2.0).should eq(V2.new(2.0,4.0))
    vec1.should eq(-vec3)
    V2.new(3.0,4.0).magnitude.should eq(5.0)
    (V2.new(0.0,3.0).distance(V2.new(4.0,0.0))).should eq(5.0)
    vec1.should eq(vec1)

    vzero = V2.zero
    vec1.zero!
    vec1.should eq(vzero)
    vec1.x = 42.0
    vec1.should_not eq(vzero)
    vec1.should eq(V2.new(42.0,0.0))
  end

  it "passes Vector3 tests" do
    vec1 = V3.zero
    vec2 = V3.new(3.0,4.0,0.0)
    (vec1 == vec2).should eq(false)
    (vec1 + vec2).should eq(vec2)
    (vec1 - vec2).should eq(-vec2)
    (vec1*vec2).should eq(vec1)

    vec3 = V3.new(1.0,2.0,3.0)

    (vec2 * vec3).should eq(V3.new(3.0,8.0,0.0))

    vec4 = V3.new(0.0,3.0,4.0)
    vec5 = V3.new(3.0,0.0,4.0)
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
    vec5.should eq(V3.new(42.0,0.0,0.0))
  end

  it "passes Vector4 tests" do
    vec1 = V4.zero
    vec2 = V4.new(1.0,2.0,3.0,4.0)
    vec3 = vec2.clone
    vec3.should eq(vec2)
    (vec2+vec3).should eq(vec2*2.0)
    (vec2-vec1).should eq(vec2)
    (vec2*vec3).should eq(V4.new(1.0,4.0,9.0,16.0))


    vzero = V4.zero
    vec1.zero!

    vec1.should eq(vzero)
    vec1.x = 42.0
    vec1.should_not eq(vzero)
    vec1.should eq(V4.new(42.0,0.0,0.0,0.0))
  end

  it "passes Quaternion tests" do
    q1 = Q.new(1.0,1.0,1.0,1.0)
    q2 = Q.new(-1.0,-1.0,-1.0,1.0)
    q3 = Q.new(1.0,1.0,1.0,-1.0)
    q1.conjugate.should eq(q2)
    (-(q1.conjugate)).should eq(q3)
    (q2+q3).should eq(Q.zero)
  end

  it "passes Matrix3 tests" do
    m0 = M3.new{|i| 0.0}
    m1 = M3.new{|i| i.to_f}
    m2 = M3.new{|i| 2.0*i}

    (m1 == m2).should eq(false)
    (m1 != m2).should eq(true)
    (m0 == m0).should eq(true)
    (m0 + m1).should eq(m1)
    (m1*2.0).should eq(m2)

    m0.make_translation!(V2.new(0.0,1.0))
    m0[1,2].should eq(1.0)
  end

  it "passes Matrix4 tests" do
    m0 = M4.new{|i| 0.0}
    m1 = M4.new{|i| i.to_f}
    m2 = M4.new{|i| 2.0*i}

    (m1 == m2).should eq(false)
    (m1 != m2).should eq(true)
    (m0 == m0).should eq(true)
    (m0 + m1).should eq(m1)
    (m1*2.0).should eq(m2)
  end
end
