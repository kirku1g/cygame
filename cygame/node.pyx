
from cysfml.cgraphics cimport Transform, Transformable_create
from cysfml.graphics cimport (
    Drawable,
    RenderWindowWrapper,
    TransformableWrapper,
)

#from node cimport Node
from actions cimport Action
from scheduler cimport Scheduler


cdef class Node(TransformableWrapper):
    def __cinit__(Node self, bint handle_key_events=False, bint handle_mouse_events=False, bint handle_joystick_events=False):
        self.children = []
        self.drawables = []
        self.named_drawables = {}
        self.Transformable = Transformable_create()
        
        self.handle_key_events = handle_key_events
        self.handle_mouse_events = handle_mouse_events
        self.handle_joystick_events = handle_joystick_events
        self.key_press_handlers = {}
        self.key_release_handlers = {}
        self.mouse_button_press_handlers = {}
        self.mouse_button_release_handlers = {}
        
        self.scheduler = Scheduler()

    #cpdef do(Node self, Action action):
        #'''
        #Perform an action on self.
        #'''
        #action.set_target(self)
        #self.scheduler.schedule(action.update)

    cpdef add(Node self, Node node):
        self.children.append(node)
    
    cpdef remove(Node self, Node node):
        self.children.remove(node)
    
    cpdef draw(Node self, RenderWindowWrapper window):
        # OPT: Use Transform struct directly rather than wrapper class.
        cdef Transform transform_struct = self.get_transform_struct()
        cdef Drawable drawable
        for drawable in self.drawables:
            drawable.draw_transform_struct(window, transform_struct)
            #drawable.draw(window)
        for drawable in self.named_drawables.values():
            #drawable.draw_transform_struct(window, transform_struct)
            drawable.draw(window)
    
    cpdef update(Node self, RenderWindowWrapper window):
        self.draw(window)
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
            child.on_key_release_event(name, alt, control, shift, system)
    
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

