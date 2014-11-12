cimport cgraphics
cimport graphics
cimport system
cimport cwindow

from scheduler cimport Scheduler


#cdef class Lines(graphics.VertexArray):
    
    #def __init__(Lines self):
        #self.primitive_type = cgraphics.LINES
    
    #cpdef add_line(Lines self,
            #cgraphics.Vector2f start_position,
            #cgraphics.Vector2f end_position):
        #self.add_line_colors(
            #start_position,
            #end_position,
            #self.vertex_color,
            #self.vertex_color,
        #)
    
    #cpdef add_line_xy(Lines self,
            #float start_x, float start_y,
            #float end_x, float end_y):
        #self.add_line_colors_xy(
            #system.create_vector2f(start_x, start_y),
            #system.create_vector2f(end_x, end_y),
            #self.vertex_color,
            #self.vertex_color,
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


#cdef class Points(graphics.VertexArray):
    
    #def __init__(Points self):
        #self.primitive_type = cgraphics.POINTS
    
    #cpdef add_point(Points self, ):
        #self.add_point_color(x, y, self.vertex_color)
    
    #cpdef add_point_xy(Points self, float x, float y):
        #self.add_point_color(x, y, self.vertex_color)
    
    #cpdef add_point_color_xy(Points self, float x, float y, cgraphics.Color color):
        #cdef cgraphics.Vertex vertex
        #vertex.color = color
        #vertex.position = system.create_vector2f(x, y)
        #self.append(vertex)
    
    #cpdef add_point_color_xy_rgb(Points self, float x, float y, Uint8 r, Uint8 g, Uint8 b):
        #self.add_point_color(x, y, cgraphics.create_color_from_rgb(r, g, b))
    
    #cpdef add_point_color_xy_rgba(Points self, float x, float y, Uint8 r, Uint8 g, Uint8 b, Uint8 a):
        #self.add_point_color(x, y, cgraphics.create_color_from_rgba(r, g, b, a))


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





cdef class Node(graphics.Transformable):
    def __cinit__(Node self, bint handle_key_events=False, bint handle_mouse_events=False, bint handle_joystick_events=False):
        self.children = []
        self.drawables = []
        self.named_drawables = {}
        self.scheduler = Scheduler()
        #self.transformable_ptr = cgraphics.create_transformable()
        
        self.handle_key_events = handle_key_events
        self.handle_mouse_events = handle_mouse_events
        self.handle_joystick_events = handle_joystick_events
        self.key_press_handlers = {}
        self.key_release_handlers = {}
        self.mouse_button_press_handlers = {}
        self.mouse_button_release_handlers = {}

    cpdef add(Node self, Node node):
        self.children.append(node)
    
    cpdef remove(Node self, Node node):
        self.children.remove(node)
    
    cpdef draw(Node self, graphics.RenderWindowWrapper window):
        # OPT: Use Transform struct directly rather than wrapper class.
        cdef cgraphics.Transform transform_struct = self.get_transform_struct()
        cdef graphics.Drawable drawable
        for drawable in self.drawables:
            drawable.draw_transform_struct(window, transform_struct)
        
        for drawable in self.named_drawables.values():
            drawable.draw_transform_struct(window, transform_struct)
    
    cpdef update(Node self, graphics.RenderWindowWrapper window):
        self.draw(window)
        if not self.scheduler.empty:
            self.scheduler.update()
        cdef Node child
        for child in self.children:
            # TODO: Pass transform into child draw method.
            child.update(window)
    
    # on_key_press
    
    cpdef on_key_press_event(Node self, bytes name, bint alt, bint control, bint shift, bint system):
        if not self.handle_key_events:
            return
        
        self.on_key_press(name, alt, control, shift, system)
        
        for child in self.children:
            child.on_key_press(name, alt, control, shift, system)
    
    cpdef on_key_press(Node self, bytes name, bint alt, bint control, bint shift, bint system):
        if name in self.key_press_handlers:
            self.key_press_handlers[name](alt, control, shift, system)
    
    # on_key_release
    
    cpdef on_key_release_event(Node self, bytes name, bint alt, bint control, bint shift, bint system):
        if not self.handle_key_events:
            return
        
        self.on_key_release(name, alt, control, shift, system)
        
        cdef Node child
        for child in self.children:
            child.on_key_press_event(name, alt, control, shift, system)
    
    cpdef on_key_release(Node self, bytes name, bint alt, bint control, bint shift, bint system):
        if name in self.key_release_handlers:
            self.key_release_handlers[name](alt, control, shift, system)
    
    # on_mouse_button_press
    
    cpdef on_mouse_button_press_event(Node self, bytes name, int x, int y):
        if not self.handle_mouse_events:
            return
        
        self.on_mouse_button_press(name, x, y)
        
        cdef Node child
        for child in self.children:
            child.on_mouse_button_press_event(name, x, y)
    
    
    cpdef on_mouse_button_press(Node self, bytes name, int x, int y):
        if name in self.mouse_button_press_handlers:
            self.mouse_button_press_handlers[name](x, y)
    
    # on_mouse_button_released
    
    cpdef on_mouse_button_release_event(Node self, bytes name, int x, int y):
        if not self.handle_mouse_events:
            return
        
        self.on_mouse_button_press(name, x, y)
        
        cdef Node child
        for child in self.children:
            child.on_mouse_button_press_event(name, x, y)
    
    cpdef on_mouse_button_release(Node self, bytes name, int x, int y):
        if name in self.mouse_button_release_handlers:
            self.mouse_button_release_handlers[name](x, y)
    
    # on_mouse_move
    
    cpdef on_mouse_move_event(Node self, int x, int y):
        if not self.handle_mouse_events:
            return
        
        self.on_mouse_move(x, y)
        
        cdef Node child
        for child in self.children:
            child.on_mouse_move_event(x, y)
    
    cpdef on_mouse_move(Node self, int x, int y):
        pass
    
    # on_mouse_wheel
    
    cpdef on_mouse_wheel_event(Node self, int delta, int x, int y):
        if not self.handle_mouse_events:
            return
        
        self.on_mouse_wheel(delta, x, y)
        
        cdef Node child
        for child in self.children:
            child.on_mouse_wheel_event(delta, x, y)
    
    cpdef on_mouse_wheel(Node self, int delta, int x, int y):
        pass
    
    # on_joystick_move
    
    cpdef on_joystick_move_event(Node self, unsigned int joystick_id, cwindow.JoystickAxis axis, float position):
        if not self.handle_joystick_events:
            return
        
        self.on_joystick_move(joystick_id, axis, position)
        
        cdef Node child
        for child in self.children:
            child.on_joystick_move_event(joystick_id, axis, position)
    
    cpdef on_joystick_move(Node self, unsigned int joystick_id, cwindow.JoystickAxis axis, float position):
        pass
    
    # on_joystick_button_pressed
    
    cpdef on_joystick_button_pressed_event(Node self, unsigned int joystick_id, unsigned int button):
        if not self.handle_joystick_events:
            return
        
        self.on_joystick_button_pressed(joystick_id, button)
        
        cdef Node child
        for child in self.children:
            child.on_joystick_button_pressed_event(joystick_id, button)
    
    cpdef on_joystick_button_pressed(Node self, unsigned int joystick_id, unsigned int button):
        pass
    
    # on_joystick_button_released
    
    cpdef on_joystick_button_released_event(Node self, unsigned int joystick_id, unsigned int button):
        if not self.handle_joystick_events:
            return
        
        #if name in self.on_joystick_button_released_handlers:
            #self.on_joystick_button_pressed_handlers[button](joystick_id, button)
        
        cdef Node child
        for child in self.children:
            child.on_joystick_button_released_event(joystick_id, button)
    
    cpdef on_joystick_button_released(Node self, unsigned int joystick_id, unsigned int button):
        pass


#cdef class PointsNode(Node):
    #def __cinit__(DrawableNode self, graphics.Drawable drawable):
        #self.drawable = graphics.create_vertex_array()
    
    #cpdef draw(DrawableNode self, graphics.RenderWindow render_window):
        #self.drawable.draw(render_window)

#cdef class CircleShapeNode(Node):
    
    #def __cinit__(CircleShapeNode self):
        #self.drawable = graphics.create_circle_shape()
    
    #cpdef draw(CircleShapeNode self, graphics.RenderWindow window):
        #window.draw_circle_shape(self.drawable)


#cdef class ConvexShapeNode(Node):
    
    #def __cinit__(ConvexShapeNode self):
        #self.drawable = graphics.create_convex_shape()
    
    #cpdef draw(ConvexShapeNode self, graphics.RenderWindow window):
        #window.draw_convex_shape(self.drawable)


#cdef class RectangleShapeNode(Node):
    
    #def __cinit__(RectangleShapeNode self):
        #self.drawable = graphics.create_rectangle_shape()
    
    #cpdef draw(RectangleShapeNode self, graphics.RenderWindow window):
        #window.draw_rectangle_shape(self.drawable)


#cdef class SpriteNode(Node):
    
    #def __cinit__(SpriteNode self):
        #self.drawable = graphics.create_sprite()
    
    #cpdef draw(SpriteNode self, graphics.RenderWindow window):
        #window.draw_sprite(self.drawable)


#cdef class TextNode(Node):
    
    #def __cinit__(TextNode self):
        #self.drawable = graphics.create_text()
    
    #cpdef draw(TextNode self, graphics.RenderWindow window):
        #window.draw_text(self.drawable)


##cdef class DrawableGroup:
    


#cdef class GroupDrawable:
    #def __cinit__(Group self, float x=0, float y=0, rotation=0):
        #self.drawables = []
        #self._position = system.create_vector2f(x, y)
        #self._rotation = rotation
    
    #cpdef add(Group self, object drawable):
        #self.drawables.add(drawable)
    
    #cpdef remove(Group self, object drawable):
        #self.drawables.remove(drawable)    
    
    #cpdef move(Group self, csystem.Vector2f offset):
        #self._position.x += offset.x
        #self._position.y += offset.y
        #cdef Node child
        #for child in self.group.children:
            #child.drawable.move(offset)
        #cdef object drawable
        #for drawable in self.drawables:
            #drawable.move(offset)
    
    #cpdef move_xy(Group self, float x, float y):
        #self.move(create_vector2f(x, y))
    
    #cpdef rotate(Group self, float angle):
        #self._rotation += angle
        #cdef Node child
        #for child in self.group.children:
            #child.drawable.rotate(angle)
        #cdef object drawable
        #for drawable in self.drawables:
            #drawable.rotate(angle)
    
    #cpdef scale(Group self, csystem.Vector2f scale):
        ## TODO
        #pass
    
    #cpdef scale_xy(Group self, float x, float y)
        #self.scale(create_vector2f(x, y))
    
    #cpdef set_position(Group self, csystem.Vector2f position):
        #self.move(create_vector2f(self._position.x - position.x, self._position.y - position.y))
    
    #cpdef set_position_xy(Group self, float x, float y):
        #self.move(create_vector2f(self._position.x - x, self._position.y - y))
    
    #cpdef set_rotation(Group self, float angle):
        #self.rotate(self._rotation - angle)
    
    
    

## TODO: Drawable extension type
#cdef class GroupNode(Node):
    #def __cinit__(Group self):
        #self.drawable = GroupDrawable(self)
        
    

    


    
    ##cpdef schedule(Node self, object callback):
        ##self._scheduled_callbacks.append(callback)
    
    ##cpdef schedule_interval(Node self, object callback, float interval):

        ##self._scheduler.schedule_interval(callback, interval)
    
    ##cpdef schedule_once(Node self, object callback, float delay):
        ##self._scheduler.schedule_once(callback, delay)
    
    ##cpdef unschedule(Node self, object callback):
        ##pass


cdef class Scene(Node):
    
    def __cinit__(Node self):
        self.handle_key_events = True
        self.handle_mouse_events = True
        self.handle_joystick_events = True
    
    cpdef on_mouse_entered(Scene self):
        pass
    
    cpdef on_mouse_left(Scene self):
        pass
    
    cpdef on_gained_focus(Scene self):
        pass
    
    cpdef on_lost_focus(Scene self):
        pass
    
    cpdef on_resize(Scene self, unsigned int width, unsigned int height):
        pass
    
    cpdef on_close(Scene self):
        # TODO
        import sys
        sys.exit(0)
    
    cpdef on_joystick_connect(Scene self, unsigned int joystick_id):
        pass
    
    cpdef on_joystick_disconnect(Scene self, unsigned int joystick_id):
        pass
    
    cpdef on_enter(Scene self):
        pass
    
    cpdef on_exit(Scene self):
        pass

