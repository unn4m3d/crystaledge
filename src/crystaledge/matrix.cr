macro matrix(size, type)
  @matrix : {{type}}[{{size*size}}]

  def initialize(elems : {{type}}[{{size*size}}])
    @matrix = elems
  end

  def initialize(elems : {{type}}[{{size}}][{{size}}])
    @matrix = elems.flat_map{|a|a}
  end

  def initialize(&block : Int32 -> {{type}})
    initialize(StaticArray({{type}},{{size*size}}).new(&block))
  end

  def [](i : Number)
    if i < {{size*size}}
      @matrix[i]
    else
      raise IndexError.new
    end
  end

  def [](r,c : Number)
    if r < {{size}} && c < {{size}}
      @matrix[r*{{size}}+c]
    else
      raise IndexError.new
    end
  end

  def []=(r,c : Number, val : {{type}})
    if r < {{size}} && c < {{size}}
      @matrix[r*{{size}}+c] = val
    else
      raise IndexError.new
    end
  end

  def []=(n : Number, val : {{type}})
    if n < {{size*size}}
      @matrix[n] = val
    else
      raise IndexError.new
    end
  end

  def size
    {{size}}
  end

  def transpose!
    {% for r in (0..size) %}
      {% for c in (0..size) %}
        {% unless r == c %}
          self[{{c}},{{r}}],self[{{r}},{{c}}] = self[{{r}},{{c}}],self[{{c}},{{r}}]
        {% end %}
      {% end %}
    {% end %}
    self
  end

  def transpose
    clone.transpose!
  end

  include ::CrystalEdge::Matrix
end

module CrystalEdge
  module Matrix
    def ==(other : typeof(self))
      0.upto(size - 1) { |i|
        return false unless other[i] == self[i]
      }
      true
    end

    def !=(other : typeof(self))
      (size*size - 1).times { |i|
        return true unless other[i] == self[i]
      }
      false
    end

    def +(other : typeof(self))
      return typeof(self).new { |i| self[i] + other[i] }
    end

    def -(other : typeof(self))
      return typeof(self).new { |i| self[i] - other[i] }
    end

    def clone
      typeof(self).new(@matrix)
    end

    def *(other : typeof(self))
      ret = clone
      size.times { |r|
        size.times { |c|
          res = 0.0
          size.times { |o|
            res += self[o, c]*other[r, o]
          }
          ret[r, c] = res
        }
      }
      ret
    end
  end
end
