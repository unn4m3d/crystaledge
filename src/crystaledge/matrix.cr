module CrystalEdge
  # Column major matrix
  class Matrix(T, H, W)
    property matrix = Slice(T).new(W*H, T.new 0)

    # Initializes an empty matrix
    def initialize
    end

    # Initializes a matrix with a Slice of elements
    def initialize(@matrix)
    end

    # Initializes a matrix like a static array
    def initialize(&block : Int32 -> T)
      @matrix = typeof(@matrix).new W*H, &block
    end

    # Initializes matrix filled with `value`
    def initialize(value : T)
      @matrix = typeof(@matrix).new W*H, value
    end

    # Initializes matrix using a block called with row and column number
    def initialize(&block : Int32, Int32 -> T)
      mat = Slice(T).new(W*H, T.new 0)
      W.times do |col|
        H.times do |row|
          mat[index(row, col)] = block.call row, col
        end
      end
      @matrix = mat
    end

    include Enumerable(T)
    include Indexable(T)

    delegate each, to_unsafe, to: matrix

    def unsafe_fetch(idx : Int)
      matrix.unsafe_fetch idx
    end

    # Returns width (number of columns)
    def width
      W
    end

    # Returns height (number of rows)
    def height
      H
    end

    # Returns size of square matrix
    #
    # Raises if matrix is not square
    def size
      raise "Cannot take size of non-square matrix" if width != height
      width
    end

    # Tests matrices for equality
    def ==(other)
      self.matrix == other.matrix
    end

    # Tests matrices for inequality
    def !=(other)
      self.matrix != other.matrix
    end

    # Clones matrix
    def clone
      typeof(self).new @matrix
    end

    # Gets an element by index
    def [](i : Int)
      matrix[i]
    end

    # ditto
    def []?(i : Int)
      matrix[i]?
    end

    # Sets an element by index
    def []=(i, v : T)
      matrix[i] = v
    end

    # Calculates index from row and column numbers
    def index(r, c)
      c * height + r
    end

    # Gets an element by row and column numbers
    def [](r, c)
      self[index(r, c)]
    end

    # ditto
    def []?(r, c)
      self[index(r, c)]?
    end

    # Sets an element by row and column numbers
    def []=(r, c, v : T)
      self[index(r, c)] = v
    end

    # Transposes a matrix
    def transpose : Matrix(T, W, H)
      mat = Matrix(T, W, H).new
      width.times do |row|
        height.times do |col|
          mat[row, col] = self[col, row]
        end
      end
      mat
    end

    # Transposes a matrix.
    #
    # This method changes the object
    #
    # Raises if current matrix is not square
    def transpose! : self
      raise "Cannot transpose non-square matrix into itself" unless width == height
      initialize transpose.matrix
    end

    # Performs addition of two matrices
    def +(other : self)
      typeof(self).new { |i| self[i] + other[i] }
    end

    # Performs subtraction of two matrices
    def -(other : self)
      typeof(self).new { |i| self[i] - other[i] }
    end

    # Performs multiplication by number
    def *(other : Number)
      typeof(self).new { |i| self[i] * other }
    end

    # Performs division by number
    def /(other : Number)
      inverse = 1.0 / other
      typeof(self).new { |i| self[i] * inverse }
    end

    # Returns submatrix of type `m` (size `M`x`N`) with offset `x`, `y`
    def submatrix(x, y, m : Matrix(T, M, N).class) forall M, N
      raise "Out of bounds" if x + m.width >= width || y + m.height >= height
      mat = m.new
      mat.width.times do |col|
        mat.height.times do |row|
          mat[row, col] = self[row + y, col + x]
        end
      end
      mat
    end

    # Calculates the product of two matrices
    def *(other : Matrix(T, W, U)) forall U
      result = Matrix(T, H, U).new

      result.height.times do |i|
        result.width.times do |j|
          result[i, j] = (0...width).reduce(T.new 0) do |memo, r|
            memo + self[i, r] * other[r, j]
          end
        end
      end
      result
    end

    # Make translation matrix from a zero-filled one.
    #
    # This method changes current object
    def make_translation!(*values : T)
      values.each_with_index do |el, i|
        break unless height > i
        self[i, width - 1] = el
      end
      Math.min(width, height).times do |i|
        self[i, i] = T.new 1
      end
      self
    end

    # ditto
    def make_translation!(vec)
      make_translation! *vec.values
    end

    # Make scaling matrix from a zero-filled one.
    #
    # This method changes current object
    def make_scaling!(*values : T)
      values.each_with_index do |e, i|
        break unless Math.min(width, height) > i
        self[i, i] = values[i]
      end
      self
    end

    # ditto
    def make_scaling!(vec)
      make_scaling! *vec.values
    end

    # Make rotation matrix from a zero-filled one.
    #
    # This method changes current object.
    #
    # Can be called with one of four values:
    # ```
    # # 2D rotation
    # matrix.make_rotation! theta
    #
    # # 3D rotation by angle theta around axis represented by unit vector {l, m, n}
    # matrix.make_rotation! theta, l, m, n
    # ```
    #
    # Raises if called with other number of arguments
    def make_rotation!(*values : T)
      case values.size
      when 1
        theta = values.first
        sin, cos = T.new(Math.sin(theta)), T.new(Math.cos(theta))
        self[0, 0] = self[1, 1] = cos
        self[0, 1] = -sin
        self[1, 0] = sin
      when 4
        theta, l, m, n = values

        raise "Invalid size : #{height}x#{width}, not 3x3" if width < 3 || height < 3

        sin, cos = T.new(Math.sin(theta)), T.new(Math.cos(theta))
        icos = T.new(1 - cos)

        self[0, 0] = l * l * icos + cos
        self[0, 1] = m * l * icos - n * sin
        self[0, 2] = n * l * icos + m * sin

        self[1, 0] = l * m * icos + n * sin
        self[1, 1] = m * m * icos + cos
        self[1, 2] = n * m * icos - l * sin

        self[2, 0] = l * n * icos - m * sin
        self[2, 1] = m * n * icos + l * sin
        self[2, 2] = n * n * icos + cos
      else
        raise "Invalid count of values : #{values.size}"
      end
      self
    end

    # Copies contents of this matrix into `m`
    def copy_to(m : self)
      m.matrix = matrix.clone
    end

    # Copies contents of `m` into this matrix
    def copy_from(m : self)
      @matrix = m.matrix.clone
    end

    {% for k, m in {:scale => :scaling, :rotate => :rotation, :translate => :translation} %}
      {% key = k.id %}
      {% method = m.id %}

      # Cloning version of `#make_{{method}}!`
      def make_{{method}}(*values)
        clone.make_{{method}}! *values
      end

      # Makes a new {{method}} matrix
      #
      # Can be called with one Vector2 or Vector3, like `#make_{{method}}!`
      def self.{{method}}(*values)
        new.make_{{method}}! *values
      end

      # {{k.capitalize.id}}s matrix
      def {{key}}(*values)
        self * typeof(self).make_{{method}}(*values)
      end

      # {{k.capitalize.id}}s this matrix
      #
      # Changes the value of current matrix.
      def {{key}}!(*values)
        copy_from {{key}}(*values)
      end

      # Return string representation of the matrix
      def to_s(io)
        # Format matrix by taking longest number
        longer = 0
        W.times do |row|
          H.times do |col|
            if longer < "#{@matrix[index(row, col)]}  ".size
              longer = "#{@matrix[index(row, col)]}  ".size
            end
          end
        end
        # Printing matrix
        H.times do |row|
          io << "| "
          W.times do |col|
            if col != H-1
              io << "#{@matrix[index(row, col)]}  "
            else
              io << "#{@matrix[index(row, col)]}"
            end            
            (longer - "#{@matrix[index(row, col)]}  ".size).times do
              io << " "
            end
          end
          io << " |\n"
        end
      end
    {% end %}
  end

  alias Matrix3 = Matrix(Float64, 3, 3)
  alias Matrix4 = Matrix(Float64, 4, 4)
end
