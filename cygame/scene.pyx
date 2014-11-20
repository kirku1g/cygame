
from director cimport cdirector
from node cimport Node
from scheduler cimport Scheduler

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
        cdirector.window.destroy()
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

