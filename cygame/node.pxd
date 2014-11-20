from cysfml cimport cwindow

from cysfml.graphics cimport (
    RenderWindowWrapper,
    TransformableWrapper,
)

from scheduler cimport (
    Scheduler,
)

from actions cimport Action


cdef class Node(TransformableWrapper):
    cdef:
        public list children, drawables
        public dict named_drawables, key_press_handlers, key_release_handlers, mouse_button_press_handlers, mouse_button_release_handlers
        public bint handle_key_events, handle_mouse_events, handle_joystick_events
        public Scheduler scheduler
    
    cpdef add(Node self, Node node)
    #cpdef do(Node self, Action action)
    cpdef remove(Node self, Node node)
    cpdef draw(Node self, RenderWindowWrapper window)
    cpdef update(Node self, RenderWindowWrapper window)
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
    #cpdef do(Node self, Action action)

