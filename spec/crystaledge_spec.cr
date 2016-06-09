require "./spec_helper"

alias V2 = CrystalEdge::Vector2

describe CrystalEdge do
  it "passes Vector2 tests" do
      vec1 = V2.new(1.0,2.0)
      vec2 = V2.new(3.0,4.0)
      vsum = V2.new(4.0,6.0)
      vdif = V2.new(-2.0,-2.0)

      (vec1 - vdif).should eq(vec2)
      (vec1 == vec2).should eq(false)
      (vec1 + vec2).should eq(vsum)
      (vec1 - vec2).should eq(vdif)
      (vec1 * vec2).should eq(V2.new(3.0,8.0))
      (vec1 * 2.0).should eq(V2.new(2.0,4.0))
      V2.new(3.0,4.0).magnitude.should eq(5.0)
      (V2.new(0.0,3.0).distance(V2.new(4.0,0.0))).should eq(5.0)
  end
end
