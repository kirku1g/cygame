cimport cwindow
cimport cgraphics
cimport graphics
from scheduler cimport (
    Scheduler,
)


#cdef class VertexArray2(graphics.VertexArray):
    #cdef public cgraphics.Color vertex_color
    
    #cpdef add_rectangle(
            #VertexArray2 self,
            #float left,
            #float top,
            #float width,
            #float height)
    #cpdef add_quad(
            #VertexArray2 self,
            #float top_left_x,
            #float top_left_y,
            #float top_right_x,
            #float top_right_y,
            #float bottom_right_x,
            #float bottom_right_y,
            #float bottom_left_x,
            #float bottom_left_y)


cdef class Node(graphics.Transformable):
    cdef:
        public list children, drawables
        public dict named_drawables, key_press_handlers, key_release_handlers, mouse_button_press_handlers, mouse_button_release_handlers
        public Scheduler scheduler
        public bint handle_key_events, handle_mouse_events, handle_joystick_events
    
    cpdef add(Node self, Node node)
    cpdef remove(Node self, Node node)
    cpdef draw(Node self, graphics.RenderWindowWrapper window)
    cpdef update(Node self, graphics.RenderWindowWrapper window)
    cpdef on_key_press(Node self, bytes name, bint alt, bint control, bint shift, bint system)
    cpdef on_key_release(Node self, bytes name, bint alt, bint control, bint shift, bint system)
    cpdef on_mouse_button_press(Node self, bytes name, int x, int y)
    cpdef on_mouse_button_release(Node self, bytes name, int x, int y)
    cpdef on_mouse_move(Node self, int x, int y)
    cpdef on_mouse_wheel(Node self, int delta, int x, int y)
    cpdef on_joystick_move(Node self, unsigned int joystick_id, cwindow.JoystickAxis axis, float position)
    cpdef on_joystick_button_pressed(Node self, unsigned int joystick_id, unsigned int button)
    cpdef on_joystick_button_released(Node self, unsigned int joystick_id, unsigned int button)
    
    cpdef on_key_press_event(Node self, bytes name, bint alt, bint control, bint shift, bint system)
    cpdef on_key_release_event(Node self, bytes name, bint alt, bint control, bint shift, bint system)
    cpdef on_mouse_button_press_event(Node self, bytes name, int x, int y)
    cpdef on_mouse_button_release_event(Node self, bytes name, int x, int y)
    cpdef on_mouse_move_event(Node self, int x, int y)
    cpdef on_mouse_wheel_event(Node self, int delta, int x, int y)
    cpdef on_joystick_move_event(Node self, unsigned int joystick_id, cwindow.JoystickAxis axis, float position)
    cpdef on_joystick_button_pressed_event(Node self, unsigned int joystick_id, unsigned int button)
    cpdef on_joystick_button_released_event(Node self, unsigned int joystick_id, unsigned int button)


cdef class Scene(Node):
    
    cpdef on_mouse_entered(Scene self)
    cpdef on_mouse_left(Scene self)
    cpdef on_gained_focus(Scene self)
    cpdef on_lost_focus(Scene self)
    cpdef on_resize(Scene self, unsigned int width, unsigned int height)
    cpdef on_close(Scene self)
    cpdef on_joystick_connect(Scene self, unsigned int joystick_id)
    cpdef on_joystick_disconnect(Scene self, unsigned int joystick_id)
    cpdef on_enter(Scene self)
    cpdef on_exit(Scene self)

