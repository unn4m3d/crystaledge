macro matrix(size, type)
  @matrix : {{type}}[{{size*size}}]

  getter matrix

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
      self.matrix == other.matrix
    end

    def !=(other : typeof(self))
      self.matrix != other.matrix
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
      size.times do |r|
        size.times do |c|
          res = 0.0
          size.times do |o|
            res += self[o, c]*other[r, o]
          end

          ret[r, c] = res
        end
      end
      ret
    end
  end
end
