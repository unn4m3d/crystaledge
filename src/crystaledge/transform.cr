module CrystalEdge
    class Transform
        property matrix = Matrix4.identity

        def translation
            Vector3.new(
                @matrix[0,3],
                @matrix[1,3],
                @matrix[2,3]
            )
        end

        def translation=(v : Vector3)
            @matrix[0,3] = v.x
            @matrix[1,3] = v.y
            @matrix[2,3] = v.z
            v
        end

        def translate!(v : Vector3)
            self.translation = self.translation + v
            self
        end

        def rotation
            Matrix3.new{ |row, col| @matrix[row, col] }
        end
    end
end