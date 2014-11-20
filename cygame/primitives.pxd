from cysfml cimport cgraphics
from cysfml.graphics cimport VertexArrayWrapper
    #Color_cast,
    #Color_from_rgb,
    #Color_from_rgba,
    #Color_unpack_rgb,
    #Color_unpack_rgba,
    #Vector2f,
    #Vertex,
    #Vertex_cast,
    #VertexArray,
#)


cdef class Primitive(VertexArrayWrapper):
    cdef cgraphics.Color _color
    # color
    cpdef set_color(Primitive self, color)
    cpdef set_color_struct(Primitive self, cgraphics.Color color)
    cpdef set_color_rgb(Primitive self, unsigned char r, unsigned char g, unsigned char b)
    cpdef set_color_rgba(Primitive self, unsigned char r, unsigned char g, unsigned char b, unsigned char a)
    cpdef tuple get_color(Primitive self)
    cpdef cgraphics.Color get_color_struct(Primitive self)
    cpdef tuple get_color_rgb(Primitive self)
    cpdef tuple get_color_rgba(Primitive self)


cdef class PointsBase(Primitive):
    cpdef add_point(PointsBase self, position)
    cpdef add_point_struct(PointsBase self, cgraphics.Vector2f position)
    cpdef add_point_xy(PointsBase self, float x, float y)
    cpdef add_point_color(PointsBase self, position, color)
    cpdef add_point_color_struct(PointsBase self, cgraphics.Vector2f position, cgraphics.Color color)
    cpdef add_point_color_args(PointsBase self, float x, float y, unsigned char r, unsigned char g, unsigned char b, unsigned char a)
    cpdef add_point_color_texture(PointsBase self, position, color, tex_coords)
    cpdef add_point_color_texture_struct(PointsBase self, cgraphics.Vector2f position, cgraphics.Color color, cgraphics.Vector2f tex_coords)
    cpdef add_point_color_texture_args(PointsBase self, float x, float y, unsigned char r, unsigned char g, unsigned char b, unsigned char a, float tex_x, float tex_y)


cdef class Points(PointsBase):
    pass


cdef class LinesStrip(PointsBase):
    pass


cdef class Lines(Primitive):
    
    cpdef add_line(Lines self,
            start_position,
            end_position)
    cpdef add_line_struct(Lines self,
            cgraphics.Vector2f start_position,
            cgraphics.Vector2f end_position)
    cpdef add_line_xy(Lines self,
            float start_x, float start_y,
            float end_x, float end_y)
    cpdef add_line_color(Lines self,
            start_position,
            end_position,
            color)
    cpdef add_line_color_struct(Lines self,
            cgraphics.Vector2f start_position,
            cgraphics.Vector2f end_position,
            cgraphics.Color color)
    cpdef add_line_color_args(Lines self,
            float start_x, float start_y,
            float end_x, float end_y,
            unsigned char r, unsigned char g, unsigned char b, unsigned char a)
    cpdef add_line_colors(Lines self,
            start_position,
            end_position,
            start_color,
            end_color)
    cpdef add_line_colors_struct(Lines self,
            cgraphics.Vector2f start_position,
            cgraphics.Vector2f end_position,
            cgraphics.Color start_color,
            cgraphics.Color end_color)
    cpdef add_line_colors_args(Lines self,
            float start_x, float start_y,
            float end_x, float end_y,
            unsigned char start_r, unsigned char start_g, unsigned char start_b, unsigned char start_a,
            unsigned char end_r, unsigned char end_g, unsigned char end_b, unsigned char end_a)



cdef class Triangles(Primitive):
    cpdef add_triangle(Triangles self, p1, p2, p3)
    cpdef add_triangle_struct(Triangles self,
            cgraphics.Vector2f p1,
            cgraphics.Vector2f p2,
            cgraphics.Vector2f p3)
    cpdef add_triangle_xy(Triangles self,
            float p1_x, float p1_y,
            float p2_x, float p2_y,
            float p3_x, float p3_y)
    cpdef add_triangle_color(Triangles self,
            p1,
            p2,
            p3,
            color)
    cpdef add_triangle_color_struct(Triangles self,
            cgraphics.Vector2f p1,
            cgraphics.Vector2f p2,
            cgraphics.Vector2f p3,
            cgraphics.Color color)
    cpdef add_triangle_color_args(Triangles self,
            float p1_x, float p1_y,
            float p2_x, float p2_y,
            float p3_x, float p3_y,
            unsigned char r, unsigned char g, unsigned char b, unsigned char a)


cdef class Quads(Primitive):
    cpdef add_rectangle(Quads self, rect)
    cpdef add_rectangle_struct(Quads self, cgraphics.FloatRect rect_struct)
    cpdef add_rectangle_ltwh(Quads self, float left, float top, float width, float height)


#cdef class Lines(Primitive):
    
    #def __cinit__(Lines self):
        #self.primitive_type = LINES
    
    #cpdef add_line_struct(Lines self,
            #cgraphics.Vector2f start_position,
            #cgraphics.Vector2f end_position):
        #self.add_line_colors(
            #start_position,
            #end_position,
            #self.color,
            #self.color,
        #)
    
    #cpdef add_line_xy(Lines self,
            #float start_x, float start_y,
            #float end_x, float end_y):
        #self.add_line_colors_xy(
            #system.create_vector2f(start_x, start_y),
            #system.create_vector2f(end_x, end_y),
            #self.color,
            #self.color,
        #)
    
    #cpdef add_line_color(Lines self,
            #cgraphics.Vector2f start_position,
            #cgraphics.Vector2f end_position,
            #cgraphics.Color color):
        #self.add_line_colors(
            #start_position,
            #end_position,
            #color,
            #color,
        #)
    
    #cpdef add_line_color_rgb(Lines self,
            #cgraphics.Vector2f start_position,
            #cgraphics.Vector2f end_position,
            #Uint8 r, Uint8 g, Uint8 b):
        #cdef cgraphics.Color color = graphics.create_color_from_rgb(r, g, b)
        #self.add_line_colors(
            #start_position,
            #end_position,
            #color,
            #color,
        #)
    
    #cpdef add_line_color_rgba(Lines self,
            #cgraphics.Vector2f start_position,
            #cgraphics.Vector2f end_position,
            #Uint8 r, Uint8 g, Uint8 b, Uint8 a):
        #cdef cgraphics.Color color = graphics.create_color_from_rgba(r, g, b, a)
        #self.add_line_colors(
            #start_position,
            #end_position,
            #color,
            #color,
        #)
    
    #cpdef add_line_color_xy(Lines self,
            #float start_x, float start_y,
            #float end_x, float end_y,
            #cgraphics.Color color):
        #self.add_line_colors(
            #system.create_vector2f(start_x, start_y),
            #system.create_vector2f(end_x, end_y),
            #color,
            #color,
        #)
    
    #cpdef add_line_color_xy_rgb(Lines self,
            #float start_x, float start_y,
            #float end_x, float end_y,
            #Uint8 r, Uint8 g, Uint8 b):
        #cdef cgraphics.Color color = graphics.create_color_from_rgb(r, g, b)
        #self.add_line_colors(
            #system.create_vector2f(start_x, start_y),
            #system.create_vector2f(end_x, end_y),
            #color,
            #color,
        #)
    
    #cpdef add_line_color_xy_rgba(Lines self
            #float start_x, float start_y,
            #float end_x, float end_y,
            #Uint8 r, Uint8 g, Uint8 b, Uint8 a):
        #cdef cgraphics.Color color = graphics.create_color_from_rgba(r, g, b, a)
        #self.add_line_colors(
            #system.create_vector2f(start_x, start_y),
            #system.create_vector2f(end_x, end_y),
            #color,
            #color,
        #)
    
    #cpdef add_line_colors(Lines self):
        #cdef cgraphics.Vertex vertex
        #vertex.color = start_color
        #vertex.position = start_position
        #self.append(vertex)
        #vertex.color = end_color
        #vertex.position = end_position
        #self.append(vertex)
    
    #cpdef add_line_colors_rgb(Lines self,
            #cgraphics.Vector2f start_position,
            #cgraphics.Vector2f end_position,
            #Uint8 start_r, Uint8 start_g, Uint8 start_b,
            #Uint8 end_r, Uint8 end_g, Uint8 end_b):
        #self.add_line_colors(
            #start_position,
            #end_position,
            #graphics.create_color_from_rgb(start_r, start_g, start_b),
            #graphics.create_color_from_rgb(end_r, end_g, end_b),
        #)
    
    #cpdef add_line_colors_rgba(Lines self,
            #cgraphics.Vector2f start_position,
            #cgraphics.Vector2f end_position,
            #Uint8 start_r, Uint8 start_g, Uint8 start_b, Uint8 start_a,
            #Uint8 end_r, Uint8 end_g, Uint8 end_b, Uint8 end_a):
        #self.add_line_colors(
            #start_position,
            #end_position,
            #graphics.create_color_from_rgba(start_r, start_g, start_b, start_a),
            #graphics.create_color_from_rgba(end_r, end_g, end_b, end_a),
        #)
    
    #cpdef add_line_colors_xy(Lines self,
            #float start_x, float start_y,
            #float end_x, float end_y,
            #cgraphics.Color start_color,
            #cgraphics.Color end_color):
        #self.add_line_colors(
            #system.create_vector2f(start_x, start_y).
            #system.create_vector2f(end_x, end_y),
            #start_color,
            #end_color,
        #)
    
    #cpdef add_line_colors_xy_rgb(Lines self,
            #float start_x, float start_y,
            #float end_x, float end_y,
            #Uint8 start_r, Uint8 start_g, Uint8 start_b,
            #Uint8 end_r, Uint8 end_g, Uint8 end_b):
        #self.add_line_colors(
            #system.create_vector2f(start_x, start_y),
            #system.create_vector2f(end_x, end_y),
            #cgraphics.create_color_from_rgb(start_r, start_g, start_b),
            #cgraphics.create_color_from_rgb(end_r, end_g, end_b),
        #)
    
    #cpdef add_line_colors_xy_rgba(Lines self,
            #float start_x, float start_y,
            #float end_x, float end_y,
            #Uint8 start_r, Uint8 start_g, Uint8 start_b, Uint8 start_a,
            #Uint8 end_r, Uint8 end_g, Uint8 end_b, Uint8 end_a):
        #self.add_line_colors(
            #system.create_vector2f(start_x, start_y),
            #system.create_vector2f(end_x, end_y),
            #cgraphics.create_color_from_rgba(start_r, start_g, start_b, start_a),
            #cgraphics.create_color_from_rgba(end_r, end_g, end_b, end_a),
        #)

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
