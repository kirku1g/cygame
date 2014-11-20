from cysfml.system cimport (
    Vector2f,
    Vector2f_cast,
)

from cysfml cimport cgraphics
from cysfml.graphics cimport (
    Color_cast,
    Color_from_rgb,
    Color_from_rgba,
    Color_unpack_rgb,
    Color_unpack_rgba,
    FloatRect_cast,
    Vertex,
    Vertex_cast,
    VertexArrayWrapper,
)


cdef class Primitive(VertexArrayWrapper):
    def __cinit__(Primitive self):
        self.VertexArray = cgraphics.VertexArray_create()
        self._color = Color_from_rgb(0, 0, 0)
    
    # color
    
    cpdef set_color(Primitive self, color):
        self._color = Color_cast(color)
    
    cpdef set_color_struct(Primitive self, cgraphics.Color color):
        self._color = color
    
    cpdef set_color_rgb(Primitive self, unsigned char r, unsigned char g, unsigned char b):
        self._color = Color_from_rgb(r, g, b)
    
    cpdef set_color_rgba(Primitive self, unsigned char r, unsigned char g, unsigned char b, unsigned char a):
        self._color = Color_from_rgba(r, g, b, a)
    
    cpdef tuple get_color(Primitive self):
        return Color_unpack_rgba(self._color)
    
    cpdef cgraphics.Color get_color_struct(Primitive self):
        return self._color
    
    cpdef tuple get_color_rgb(Primitive self):
        return Color_unpack_rgb(self._color)
    
    cpdef tuple get_color_rgba(Primitive self):
        return Color_unpack_rgba(self._color)
    
    property color:
        def __get__(Primitive self):
            return Color_unpack_rgba(self._color)
        
        def __set__(Primitive self, color):
            self._color = Color_cast(color)


cdef class PointsBase(Primitive):
    
    cpdef add_point(PointsBase self, position):
        self.add_point_color_struct(Vector2f_cast(position), self._color)
    
    cpdef add_point_struct(PointsBase self, cgraphics.Vector2f position):
        self.append_struct(Vertex(position, self._color))
    
    cpdef add_point_xy(PointsBase self, float x, float y):
        self.append_struct(Vertex(Vector2f(x, y), self._color))
    
    cpdef add_point_color(PointsBase self, position, color):
        self.append_struct(Vertex(Vector2f_cast(position), Color_cast(color)))
    
    cpdef add_point_color_struct(PointsBase self, cgraphics.Vector2f position, cgraphics.Color color):
        self.append_struct(Vertex(position, color))
    
    cpdef add_point_color_args(PointsBase self, float x, float y, unsigned char r, unsigned char g, unsigned char b, unsigned char a):
        self.append_args(x, y, r, g, b, a)
    
    cpdef add_point_color_texture(PointsBase self, position, color, tex_coords):
        self.append_struct(Vertex(Vector2f_cast(position), Color_cast(color), Vector2f_cast(tex_coords)))
    
    cpdef add_point_color_texture_struct(PointsBase self, cgraphics.Vector2f position, cgraphics.Color color, cgraphics.Vector2f tex_coords):
        self.append_struct(Vertex(position, color, tex_coords))
    
    cpdef add_point_color_texture_args(PointsBase self, float x, float y, unsigned char r, unsigned char g, unsigned char b, unsigned char a, float tex_x, float tex_y):
        self.append_args(x, y, r, g, b, a, tex_x, tex_y)


cdef class Points(PointsBase):
    def __cinit__(Points self):
        cgraphics.VertexArray_set_primitive_type(self.VertexArray, 0)


cdef class LinesStrip(PointsBase):
    def __cinit__(LinesStrip self):
        cgraphics.VertexArray_set_primitive_type(self.VertexArray, 2)


cdef class Lines(Primitive):
    
    def __cinit__(Lines self):
        self.primitive_type = 1
    
    cpdef add_line(Lines self,
            start_position,
            end_position):
        self.append_struct(Vertex(
            Vector2f_cast(start_position),
            self._color,
        ))
        self.append_struct(Vertex(
            Vector2f_cast(end_position),
            self._color,
        ))
    
    cpdef add_line_struct(Lines self,
            cgraphics.Vector2f start_position,
            cgraphics.Vector2f end_position):
        self.append_struct(Vertex(
            start_position,
            self._color,
        ))
        self.append_struct(Vertex(
            end_position,
            self._color,
        ))
    
    cpdef add_line_xy(Lines self,
            float start_x, float start_y,
            float end_x, float end_y):
        self.append_struct(Vertex(
            Vector2f(start_x, start_y),
            self._color,
        ))
        self.append_struct(Vertex(
            Vector2f(end_x, end_y),
            self._color,
        ))
    
    cpdef add_line_color(Lines self,
            start_position,
            end_position,
            color):
        cdef cgraphics.Color color_struct = Color_cast(color)
        self.append_struct(Vertex(
            Vector2f_cast(start_position),
            color_struct,
        ))
        self.append_struct(Vertex(
            Vector2f_cast(end_position),
            color_struct,
        ))
    
    cpdef add_line_color_struct(Lines self,
            cgraphics.Vector2f start_position,
            cgraphics.Vector2f end_position,
            cgraphics.Color color):
        self.append_struct(Vertex(
            start_position,
            color,
        ))
        self.append_struct(Vertex(
            end_position,
            color,
        ))
    
    cpdef add_line_color_args(Lines self,
            float start_x, float start_y,
            float end_x, float end_y,
            unsigned char r, unsigned char g, unsigned char b, unsigned char a):
        cdef cgraphics.Color color = Color_from_rgba(r, g, b, a)
        self.append_struct(Vertex(
            Vector2f(start_x, start_y),
            color,
        ))
        self.append_struct(Vertex(
            Vector2f(end_x, end_y),
            color,
        ))
    
    cpdef add_line_colors(Lines self,
            start_position,
            end_position,
            start_color,
            end_color):
        self.append_struct(Vertex(
            Vector2f_cast(start_position),
            Color_cast(start_color),
        ))
        self.append_struct(Vertex(
            Vector2f_cast(end_position),
            Color_cast(end_color),
        ))
    
    cpdef add_line_colors_struct(Lines self,
            cgraphics.Vector2f start_position,
            cgraphics.Vector2f end_position,
            cgraphics.Color start_color,
            cgraphics.Color end_color):
        self.append_struct(Vertex(
            start_position,
            start_color,
        ))
        self.append_struct(Vertex(
            end_position,
            end_color,
        ))
    
    cpdef add_line_colors_args(Lines self,
            float start_x, float start_y,
            float end_x, float end_y,
            unsigned char start_r, unsigned char start_g, unsigned char start_b, unsigned char start_a,
            unsigned char end_r, unsigned char end_g, unsigned char end_b, unsigned char end_a):
        self.append_struct(Vertex(
            Vector2f(start_x, start_y),
            Color_from_rgba(start_r, start_g, start_b, start_a),
        ))
        self.append_struct(Vertex(
            Vector2f(end_x, end_y),
            Color_from_rgba(end_r, end_g, end_b, end_a),
        ))


cdef class Triangles(Primitive):
    
    def __cinit__(Triangles self):
        self.primitive_type = 3
    
    cpdef add_triangle(Triangles self, p1, p2, p3):
        self.append_struct(Vertex(
            Vector2f_cast(p1),
            self._color,
        ))
        self.append_struct(Vertex(
            Vector2f_cast(p2),
            self._color,
        ))
        self.append_struct(Vertex(
            Vector2f_cast(p3),
            self._color,
        ))
    
    cpdef add_triangle_struct(Triangles self,
            cgraphics.Vector2f p1,
            cgraphics.Vector2f p2,
            cgraphics.Vector2f p3):
        self.append_struct(Vertex(
            p1,
            self._color,
        ))
        self.append_struct(Vertex(
            p2,
            self._color,
        ))
        self.append_struct(Vertex(
            p3,
            self._color,
        ))
    
    cpdef add_triangle_xy(Triangles self,
            float p1_x, float p1_y,
            float p2_x, float p2_y,
            float p3_x, float p3_y):
        self.append_struct(Vertex(
            Vector2f(p1_x, p1_y),
            self._color,
        ))
        self.append_struct(Vertex(
            Vector2f(p2_x, p2_y),
            self._color,
        ))
        self.append_struct(Vertex(
            Vector2f(p3_x, p3_y),
            self._color,
        ))
    
    cpdef add_triangle_color(Triangles self,
            p1,
            p2,
            p3,
            color):
        cdef cgraphics.Color color_struct = Color_cast(color)
        self.append_struct(Vertex(
            Vector2f_cast(p1),
            color_struct,
        ))
        self.append_struct(Vertex(
            Vector2f_cast(p2),
            color_struct,
        ))
        self.append_struct(Vertex(
            Vector2f_cast(p3),
            color_struct,
        ))
    
    cpdef add_triangle_color_struct(Triangles self,
            cgraphics.Vector2f p1,
            cgraphics.Vector2f p2,
            cgraphics.Vector2f p3,
            cgraphics.Color color):
        self.append_struct(Vertex(
            p1,
            color,
        ))
        self.append_struct(Vertex(
            p2,
            color,
        ))
        self.append_struct(Vertex(
            p3,
            color,
        ))
    
    cpdef add_triangle_color_args(Triangles self,
            float p1_x, float p1_y,
            float p2_x, float p2_y,
            float p3_x, float p3_y,
            unsigned char r, unsigned char g, unsigned char b, unsigned char a):
        cdef cgraphics.Color color = Color_from_rgba(r, g, b, a)
        self.append_struct(Vertex(
            Vector2f(p1_x, p1_y),
            color,
        ))
        self.append_struct(Vertex(
            Vector2f(p2_x, p2_y),
            color,
        ))
        self.append_struct(Vertex(
            Vector2f(p3_x, p3_y),
            color,
        ))


# TODO: TrianglesFan, TrianglesStrip


cdef class Quads(Primitive):
    
    def __cinit__(Quads self):
        self.primitive_type = 6
    
    cpdef add_rectangle(Quads self, rect):
        cdef cgraphics.FloatRect rect_struct = FloatRect_cast(rect)
        self.add_rectangle_ltwh(
            rect_struct.left,
            rect_struct.top,
            rect_struct.width,
            rect_struct.height,
        )
    
    cpdef add_rectangle_struct(Quads self, cgraphics.FloatRect rect_struct):
        self.add_rectangle_ltwh(
            rect_struct.left,
            rect_struct.top,
            rect_struct.width,
            rect_struct.height,
        )
    
    cpdef add_rectangle_ltwh(Quads self, float left, float top, float width, float height):
        self.append_struct(Vertex(
            Vector2f(left, top),
            self._color,
        ))
        self.append_struct(Vertex(
            Vector2f(left + width, top),
            self._color,
        ))
        self.append_struct(Vertex(
            Vector2f(left + width, top + height),
            self._color,
        ))
        self.append_struct(Vertex(
            Vector2f(left, top + height),
            self._color,
        ))


#cdef class Quads(graphics.VertexArray):
    
    #def __init__(Quads self):
        #self.primitive_type = cgraphics.QUADS
        #self.vertex_color = graphics.create_color_from_rgb(0, 0, 0)
    
    #cpdef add_rectangle_ltwh(
            #Quads self,
            #float left,
            #float top,
            #float width,
            #float height):
        #self.add_quad(
            #left, top,
            #left + width, top,
            #left + width, top + height,
            #left, top + height,
        #)
    
    #cpdef add_quad_xy(
            #Quads self,
            #float top_left_x,
            #float top_left_y,
            #float top_right_x, 
            #float top_right_y,
            #float bottom_right_x,
            #float bottom_right_y,
            #float bottom_left_x,
            #float bottom_left_y):
        #cdef cgraphics.Vertex vertex
        #vertex.color = self.vertex_color
        #vertex.position = system.create_vector2f(top_left_x, top_left_y)
        #self.append(vertex)
        #vertex.position = system.create_vector2f(top_right_x, top_right_y)
        #self.append(vertex)
        #vertex.position = system.create_vector2f(bottom_right_x, bottom_right_y)
        #self.append(vertex)
        #vertex.position = system.create_vector2f(bottom_left_x, bottom_right_y)
        #self.append(vertex)
