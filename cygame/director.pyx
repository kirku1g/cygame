from cysfml.config cimport (
    Uint8,
)
from cysfml cimport (
    csystem,
    system,
    cgraphics,
    graphics,
    cwindow,
    window,
)

from cysfml.window import (
    KEY_NAME_LOOKUP,
    MOUSE_BUTTON_NAME_LOOKUP,
)

from actions cimport Action
from scene cimport Scene
from scheduler cimport cscheduler

cdef:
    unsigned int DEFAULT_WINDOW_WIDTH = 640
    unsigned int DEFAULT_WINDOW_HEIGHT = 480
    unsigned int DEFAULT_WINDOW_BITS_PER_PIXEL = 32
    bint DEFAULT_VSYNC = False
    unsigned int DEFAULT_FPS = 60 # Q: ?


#cpdef VideoMode get_desktop_mode():
    #return desktop_mode()


#cpdef list get_fullscreen_modes():
    #return fullscreen_modes()


cdef class Director:
    
    def __cinit__(Director self,
                  char* title='cygame',
                  unsigned int width=DEFAULT_WINDOW_WIDTH,
                  unsigned int height=DEFAULT_WINDOW_HEIGHT,
                  unsigned int bits_per_pixel=DEFAULT_WINDOW_BITS_PER_PIXEL,
                  bint vsync=DEFAULT_VSYNC,
                  unsigned int fps=DEFAULT_FPS):
        cdef cwindow.VideoMode video_mode
        video_mode.width = width
        video_mode.height = height
        video_mode.bits_per_pixel = bits_per_pixel
        self.video_mode = video_mode
        self._title = title
        self._vsync = vsync
        
        self._mouse_cursor_visible = True
        self._key_repeat = True
        self._joystick_threshold = 0.1
        self._visible = True
        self._clear_color = cgraphics.Color_from_rgb(0, 0, 0)
        self.limit_mouse_move_events = False
        
        self._scenes = []
    
    # actions
    
    cpdef do(Director self, target, Action action):
        action.set_target(target)
        self.scheduler.schedule(action.update)
    
    # scene
    
    cpdef Scene switch_scene(Director self, Scene scene):
        cdef Scene previous_scene = self._scenes.pop()
        previous_scene.on_exit()
        self._scenes.append(scene)
        self.scene = scene
        scene.on_enter()
        return previous_scene
    
    cpdef Scene pop_scene(Director self):
        cdef Scene scene = self._scenes.pop()
        scene.on_exit()
        if self._scenes:
            self.scene = self._scenes[-1]
        else:
            self.scene = None
        return scene
    
    cpdef push_scene(Director self, Scene scene):
        self.scene = scene
        self._scenes.append(scene)
        scene.on_enter()
    
    cdef handle_event(Director self, cwindow.Event* event_ptr):
        cdef cwindow.Event event = event_ptr[0]
        # OPT: Ordered so that most frequent events are at the top.
        if event.type == cwindow.EVENT_MOUSE_MOVED:
            self.scene.on_mouse_move_event(event.mouse_move.x, event.mouse_move.y)
        elif event.type == cwindow.EVENT_KEY_PRESSED:
            self.scene.on_key_press_event(
                KEY_NAME_LOOKUP[event.key.code],
                event.key.alt,
                event.key.control,
                event.key.shift,
                event.key.system,
            )
        elif event.type == cwindow.EVENT_KEY_RELEASED:
            self.scene.on_key_release_event(
                KEY_NAME_LOOKUP[event.key.code],
                event.key.alt,
                event.key.control,
                event.key.shift,
                event.key.system,
            )
        elif event.type == cwindow.EVENT_MOUSE_BUTTON_PRESSED:
            self.scene.on_mouse_button_press_event(
                MOUSE_BUTTON_NAME_LOOKUP[event.mouse_button.button],
                event.mouse_button.x,
                event.mouse_button.y,
            )
        elif event.type == cwindow.EVENT_MOUSE_BUTTON_RELEASED:
            self.scene.on_mouse_button_release_event(
                MOUSE_BUTTON_NAME_LOOKUP[event.mouse_button.button],
                event.mouse_button.x,
                event.mouse_button.y,
            )
        elif event.type == cwindow.EVENT_MOUSE_WHEEL_MOVED:
            self.scene.on_mouse_wheel_event(
                event.mouse_wheel.delta,
                event.mouse_wheel.x,
                event.mouse_wheel.y,
            )
        elif event.type == cwindow.EVENT_JOYSTICK_MOVED:
            self.scene.on_joystick_move_event(
                event.joystick_move.joystick_id,
                event.joystick_move.axis,
                event.joystick_move.position,
            )
        elif event.type == cwindow.EVENT_MOUSE_ENTERED:
            self.scene.on_mouse_entered()
        elif event.type == cwindow.EVENT_MOUSE_LEFT:
            self.scene.on_mouse_left()
        elif event.type == cwindow.EVENT_JOYSTICK_BUTTON_PRESSED:
            self.scene.on_joystick_button_pressed_event(
                event.joystick_button.joystick_id,
                event.joystick_button.button,
            )
        elif event.type == cwindow.EVENT_JOYSTICK_BUTTON_RELEASED:
            self.scene.on_joystick_button_released_event(
                event.joystick_button.joystick_id,
                event.joystick_button.button,
            )
        elif event.type == cwindow.EVENT_LOST_FOCUS:
            self.scene.on_lost_focus()
        elif event.type == cwindow.EVENT_GAINED_FOCUS:
            self.scene.on_gained_focus()
        elif event.type == cwindow.EVENT_RESIZED:
            self.scene.on_resize(
                event.size.width,
                event.size.height,
            )
        elif event.type == cwindow.EVENT_CLOSED:
            self.scene.on_close()
        elif event.type == cwindow.EVENT_JOYSTICK_CONNECTED:
            self.scene.on_joystick_connect(event.joystick_connect.joystick_id)
        elif event.type == cwindow.EVENT_JOYSTICK_DISCONNECTED:
            self.scene.on_joystick_disconnect(event.joystick_connect.joystick_id)
    
    cpdef poll_events(Director self):
        cdef bint event_exists = True
        cdef cwindow.Event event
        cdef bint mouse_move_event_exists = False
        cdef cwindow.Event mouse_move_event
        event_exists = cgraphics.RenderWindow_poll_event(self.window.RenderWindow, &event)
        while event_exists:
            if event.type == cwindow.EVENT_MOUSE_MOVED and self.limit_mouse_move_events:
                mouse_move_event = event
                mouse_move_event_exists = True
                continue
            self.handle_event(&event)
            event_exists = cgraphics.RenderWindow_poll_event(self.window.RenderWindow, &event)
        if mouse_move_event_exists:
            self.handle_event(&mouse_move_event)
    
    cpdef run(Director self):
        if not self._scenes:
            print("Scene must be set before calling run()")
            return
        self.window = graphics.RenderWindow_from_struct(self.video_mode, self._title)
        # Set Director configuration
        self.window.set_vsync(self._vsync)
        self.window.set_framerate_limit(self._fps)
        self.window.set_mouse_cursor_visible(self._mouse_cursor_visible)
        self.window.set_key_repeat(self._key_repeat)
        self.window.set_joystick_threshold(self._joystick_threshold)
        while True: #self.window.is_open():
            self.poll_events()
            self.window.clear_struct(self._clear_color)
            self.scene.update(self.window)
            cscheduler.update()
            self.window.display()
    
    # width
    
    cpdef unsigned int get_width(Director self):
        '''
        Get window width in pixels.
        '''
        return self.video_mode.width
    
    cpdef set_width(Director self, unsigned int width):
        '''
        Set window width in pixels.
        '''
        self.video_mode.width = width
        if self.window:
            self.window.set_width(width)
    
    property width:
        '''
        Window width in pixels.
        '''
        def __get__(Director self):
             return self.video_mode.width
        
        def __set__(Director self, unsigned int width):
            self.set_width(width)
    
    # height
    
    cpdef unsigned int get_height(Director self):
        '''
        Get window height in pixels.
        '''
        return self.video_mode.height
    
    cpdef set_height(Director self, unsigned int height):
        '''
        Set window height in pixels.
        '''
        self.video_mode.height = height
        if self.window:
            self.window.set_height(height)
    
    property height:
        '''
        Window height in pixels.
        '''
        def __get__(Director self):
            return self.video_mode.height
        
        def __set__(Director self, unsigned int height):
            self.set_height(height)
    
    # size
    
    cpdef tuple get_size(Director self):
        '''
        Get window size in pixels.
        '''
        return self.video_mode.width, self.video_mode.height
    
    cpdef csystem.Vector2u get_size_struct(Director self):
        return system.Vector2u(self.video_mode.width, self.video_mode.height)
    
    cpdef tuple get_size_xy(Director self):
        return self.video_mode.width, self.video_mode.height
    
    cpdef set_size(Director self, size):
        '''
        Set window size in pixels.
        
        :type size: cgraphics.Vector2u
        '''
        self.set_size_struct(system.Vector2u_cast(size))
    
    cpdef set_size_struct(Director self, csystem.Vector2u size):
        '''
        Set window size in pixels.
        
        :type size: cgraphics.Vector2u
        '''
        self.video_mode.width = size.x
        self.video_mode.height = size.y
        if self.window:
            self.window.set_size_struct(size)
    
    cpdef set_size_xy(Director self, unsigned int width, unsigned int height):
        '''
        Set window size in pixels.
        
        :type width: unsigned int
        :type height: unsigned int
        '''
        self.set_size_struct(system.Vector2u(width, height))
    
    property size:
        '''
        Window size in pixels.
        '''
        def __get__(Director self):
            return self.video_mode.width, self.video_mode.height
        
        def __set__(Director self, size):
            self.set_size_struct(system.Vector2u_cast(size))
    
    # title
    
    cpdef bytes get_title(Director self):
        '''
        Get window title.
        
        :rtype: bytes
        '''
        return self._title
    
    cpdef set_title(Director self, bytes title):
        '''
        Set window title.
        
        :type title: bytes
        '''
        self._title = title
        if self.window:
            self.window.set_title(title)
    
    property title:
        '''
        Window title.
        '''
        def __get__(Director self):
            return self._title
        
        def __set__(Director self, char* title):
            self.set_title(title)
    
    # vsync
    
    cpdef bint get_vsync(Director self):
        '''
        Get window vsync enabled.
        
        :rtype: bool
        '''
        return self._vsync
    
    cpdef set_vsync(Director self, bint vsync):
        '''
        Set window vsync enabled.
        
        :type vsync: bool
        '''
        self._vsync = vsync
        if self.window:
            self.window.set_vsync(vsync)
    
    property vsync:
        '''
        Window vsync enabled.
        '''
        def __get__(Director self):
            return self._vsync
        
        def __set__(Director self, bint vsync):
            self.set_vsync(vsync)
    
    # mouse_cursor_visible
    
    cpdef bint get_mouse_cursor_visible(Director self):
        '''
        Get window mouse cursor visible.
        
        :rtype: bool
        '''
        return self._mouse_cursor_visible
    
    cpdef set_mouse_cursor_visible(Director self, bint visible):
        '''
        Set window mouse cursor visible.
        
        :type visible: bool
        '''
        self._mouse_cursor_visible = visible
        if self.window:
            self.window.set_mouse_cursor_visible(visible)
    
    property mouse_cursor_visible:
        '''
        Window mouse cursor visible.
        '''
        def __get__(Director self):
            return self._mouse_cursor_visible
        
        def __set__(Director self, bint visible):
            self.set_mouse_cursor_visible(visible)
    
    # key_repeat
    
    cpdef bint get_key_repeat(Director self):
        '''
        Get window repeat key enabled.
        
        :rtype: bool
        '''
        return self._key_repeat
    
    cpdef set_key_repeat(Director self, bint enabled):
        '''
        Set window repeat key enabled.
        
        :type enabled: bool
        '''
        self._key_repeat = enabled
        if self.window:
            self.window.set_key_repeat(enabled)
    
    property key_repeat:
        '''
        Window repeat key enabled.
        '''
        def __get__(Director self):
            return self._key_repeat
        
        def __set__(Director self, bint enabled):
            self.set_key_repeat(enabled)
    
    # fps
    
    cpdef unsigned int get_fps(Director self):
        '''
        Get window fps (framerate limit).
        
        :rtype: unsigned int
        '''
        return self._fps
    
    cpdef set_fps(Director self, unsigned int fps):
        '''
        Set window fps (framerate limit).
        
        :type fps: unsigned int
        '''
        self._fps = fps
        if self.window:
            self.window.set_framerate_limit(fps)
    
    property fps:
        '''
        Window fps (framerate limit).
        '''
        def __get__(Director self):
            return self._fps
    
        def __set__(Director self, unsigned int fps):
            self.set_fps(fps)
    
    # joystick_threshold
    
    cpdef float get_joystick_threshold(Director self):
        '''
        Get joystick threshold.
        
        :rtype: float
        '''
        return self._joystick_threshold
    
    cpdef set_joystick_threshold(Director self, float threshold):
        '''
        Set joystick threshold.
        
        :type threshold: float
        '''
        self._joystick_threshold = threshold
        if self.window:
            self.window.set_joystick_threshold(threshold)
    
    property joystick_threshold:
        '''
        Joystick threshold.
        '''
        def __get__(Director self):
            return self._joystick_threshold
        
        def __set__(Director self, float threshold):
            self.set_joystick_threshold(threshold)
    
    # visible
    
    cpdef bint get_visible(Director self) except -1:
        '''
        Get window visibility.
        
        :rtype: bool
        '''
        if not self.window:
            raise LookupError('run() must be called before get_visible().')
        return self._visible
    
    cpdef set_visible(Director self, bint visible):# except *:
        '''
        Set window visibility.
        
        :type visible: bool
        '''
        if not self.window:
            raise ValueError('run() must be called before set_visible().')
        self._visible = visible
        if self.window:
            self.window.set_visible(visible)
    
    property visible:
        '''
        Window visibility.
        '''
        def __get__(Director self):
            return self.get_visible()
        
        def __set__(Director self, bint visible):
            self.set_visible(visible)
    
    # clear_color
    
    cpdef set_clear_color(Director self, color):
        '''
        Set window clear (background) color.
        
        :type color: cgraphics.Color
        '''
        self._clear_color = graphics.Color_cast(color)
    
    cpdef set_clear_color_struct(Director self, cgraphics.Color color):
        '''
        Set window clear (background) color.
        
        :type color: cgraphics.Color
        '''
        self._clear_color = color
    
    cpdef set_clear_color_rgb(Director self, Uint8 r, Uint8 g, Uint8 b):
        '''
        Set window clear (background) color.
        
        :type color: cgraphics.Color
        '''
        self._clear_color = graphics.Color_from_rgb(r, g, b)
    
    cpdef set_clear_color_rgba(Director self, Uint8 r, Uint8 g, Uint8 b, Uint8 a):
        '''
        Set window clear (background) color.
        
        :type color: cgraphics.Color
        '''
        self._clear_color = graphics.Color_from_rgba(r, g, b, a)
    
    cpdef tuple get_clear_color(Director self):
        '''
        Get window clear (background) color.
        
        :rtype: cgraphics.Color
        '''
        return graphics.Color_unpack_rgba(self._clear_color)
    
    cpdef cgraphics.Color get_clear_color_struct(Director self):
        '''
        Get window clear (background) color.
        
        :rtype: cgraphics.Color
        '''
        return self._clear_color
    
    cpdef tuple get_clear_color_rgb(Director self):
        '''
        Get window clear (background) color.
        
        :rtype: cgraphics.Color
        '''
        return graphics.Color_unpack_rgb(self._clear_color)
    
    cpdef tuple get_clear_color_rgba(Director self):
        '''
        Get window clear (background) color.
        
        :rtype: cgraphics.Color
        '''
        return graphics.Color_unpack_rgba(self._clear_color)
    
    property clear_color:
        '''
        Window clear (background) color.
        '''
        def __get__(Director self):
            return graphics.Color_unpack_rgba(self._clear_color)
        
        def __set__(Director self, color):
            self._clear_color = graphics.Color_cast(color)


director = Director()
cdef Director cdirector = Director()

