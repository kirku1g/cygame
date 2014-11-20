from node cimport Node
from scheduler cimport Scheduler


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

