from config cimport (
    Uint8,
)
from csystem cimport Vector2u
from system cimport create_vector2u
cimport cgraphics
from graphics cimport (
    create_color_from_rgb,
    create_color_from_rgba,
    create_render_window,
    unpack_color_rgb,
    unpack_color_rgba,
)
cimport cwindow
from window cimport (
    VideoMode,
    create_video_mode,
    #desktop_mode,
    #fullscreen_modes,
)
from window import (
    KEY_NAME_LOOKUP,
    MOUSE_BUTTON_NAME_LOOKUP,
)

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
                  char* title,
                  unsigned int width=DEFAULT_WINDOW_WIDTH,
                  unsigned int height=DEFAULT_WINDOW_HEIGHT,
                  unsigned int bits_per_pixel=DEFAULT_WINDOW_BITS_PER_PIXEL,
                  bint vsync=DEFAULT_VSYNC,
                  unsigned int fps=DEFAULT_FPS):
        self.video_mode = create_video_mode(width, height, bits_per_pixel)
        self._title = title
        self._vsync = vsync
        
        self._mouse_cursor_visible = True
        self._repeat_key_enabled = True
        self._joystick_threshold = 0.1
        self._visible = True
        self._clear_color = create_color_from_rgb(0, 0, 0)
        self.limit_mouse_move_events = False
        
        self._scenes = []
    
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
            print 'on key press 1'
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
        while event_exists:
            event_exists = cgraphics.render_window_poll_event(self._window.render_window_ptr, &event)
            if event.type == cwindow.EVENT_MOUSE_MOVED and self.limit_mouse_move_events:
                mouse_move_event = event
                mouse_move_event_exists = True
                continue
            self.handle_event(&event)
        if mouse_move_event_exists:
            self.handle_event(&mouse_move_event)
    
    cpdef run(Director self):
        if not self._scenes:
            print("Scene must be set before calling run()")
            return
        self._window = create_render_window(self.video_mode, self._title)
        # Set Director configuration
        self._window.set_vsync(self._vsync)
        self._window.set_framerate_limit(self._fps)
        self._window.set_mouse_cursor_visible(self._mouse_cursor_visible)
        self._window.set_repeat_key_enabled(self._repeat_key_enabled)
        self._window.set_joystick_threshold(self._joystick_threshold)
        
        while True: #self._window.is_open():
            self.poll_events()
            self._window.clear(self._clear_color)
            self.scene.update(self._window)
            
            self._window.display()
    
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
            return self.get_width()
        
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
            return self.get_height()
        
        def __set__(Director self, unsigned int height):
            self.set_height(height)
    
    # size
    
    cpdef Vector2u get_size(Director self):
        '''
        Get window size in pixels.
        
        :rtype: cgraphics.Vector2u
        '''
        return create_vector2u(self.video_mode.width, self.video_mode.height)
    
    cpdef set_size(Director self, Vector2u size):
        '''
        Set window size in pixels.
        
        :type size: cgraphics.Vector2u
        '''
        self.video_mode.width = size.x
        self.video_mode.height = size.y
        if self.window:
            self.window.set_size(size)
    
    cpdef tuple get_size_xy(Director self):
        '''
        Get window size in pixels.
        
        :rtype: (unsigned int, unsigned int)
        '''
        return self.video_mode.width, self.video_mode.height
    
    cpdef set_size_xy(Director self, unsigned int width, unsigned int height):
        '''
        Set window size in pixels.
        
        :type width: unsigned int
        :type height: unsigned int
        '''
        self.video_mode.width = width
        self.video_mode.height = height
        if self.window:
            self._window.set_size_xy(width, height)
    
    property size:
        '''
        Window size in pixels.
        '''
        def __get__(Director self):
            return self.get_size_xy()
        
        def __set__(Director self, tuple xy):
            self.set_size_xy(*xy)
    
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
            return self.get_title()
        
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
            return self.get_vsync()
        
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
            return self.get_mouse_cursor_visible()
        
        def __set__(Director self, bint visible):
            self.set_mouse_cursor_visible(visible)
    
    # repeat_key_enabled
    
    cpdef bint get_repeat_key_enabled(Director self):
        '''
        Get window repeat key enabled.
        
        :rtype: bool
        '''
        return self._repeat_key_enabled
    
    cpdef set_repeat_key_enabled(Director self, bint enabled):
        '''
        Set window repeat key enabled.
        
        :type enabled: bool
        '''
        self._repeat_key_enabled = enabled
        if self.window:
            self.window.set_repeat_key_enabled(enabled)
    
    property repeat_key_enabled:
        '''
        Window repeat key enabled.
        '''
        def __get__(Director self):
            return self.get_repeat_key_enabled()
        
        def __set__(Director self, bint enabled):
            self.set_repeat_key_enabled(enabled)
    
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
            return self.get_fps()
    
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
            return self.get_joystick_threshold()
        
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
    
    cpdef set_clear_color(Director self, cgraphics.Color color):
        '''
        Set window clear (background) color.
        
        :type color: cgraphics.Color
        '''
        self._clear_color = color
    
    cpdef cgraphics.Color get_clear_color(Director self):
        '''
        Get window clear (background) color.
        
        :rtype: cgraphics.Color
        '''
        return self._clear_color
    
    property clear_color:
        '''
        Window clear (background) color.
        '''
        def __get__(Director self):
            return self._clear_color
        
        def __set__(Director self, cgraphics.Color color):
            self._clear_color = color
    
    # clear_color_rgb
    
    cpdef set_clear_color_rgb(Director self, Uint8 r, Uint8 g, Uint8 b):
        '''
        Set window clear (background) color.
        
        :type r: Uint8
        :type g: Uint8
        :type b: Uint8
        '''
        self._clear_color = create_color_from_rgb(r, g, b)
    
    cpdef tuple get_clear_color_rgb(Director self):
        '''
        Get window clear (background) color.
        
        :rtype: (Uint8, Uint8, Uint8)
        '''
        return unpack_color_rgb(self._clear_color)
    
    property clear_color_rgb:
        '''
        Get window clear (background) color.
        '''
        def __get__(Director self):
            return unpack_color_rgb(self._clear_color)
        
        def __set__(Director self, tuple rgb):
            self.set_clear_color_rgb(*rgb)
    
    # clear_color_rgba
    
    cpdef set_clear_color_rgba(Director self, Uint8 r, Uint8 g, Uint8 b, Uint8 a):
        '''
        Set window clear (background) color.
        
        :type r: Uint8
        :type g: Uint8
        :type b: Uint8
        :type a: Uint8
        '''
        self._clear_color = create_color_from_rgba(r, g, b, a)
    
    cpdef tuple get_clear_color_rgba(Director self):
        '''
        Get window clear (background) color.
        
        :rtype: (Uint8, Uint8, Uint8, Uint8)
        '''
        return unpack_color_rgba(self._clear_color)
    
    property clear_color_rgba:
        '''
        Window clear (background) color.
        '''
        def __get__(Director self):
            return unpack_color_rgba(self._clear_color)
        
        def __set__(Director self, tuple rgba):
            self.set_clear_color_rgba(*rgba)


cdef Director director


cpdef Director init(char* title,
           unsigned int width=DEFAULT_WINDOW_WIDTH,
           unsigned int height=DEFAULT_WINDOW_HEIGHT,
           unsigned int bits_per_pixel=DEFAULT_WINDOW_BITS_PER_PIXEL,
           bint vsync=DEFAULT_VSYNC,
           unsigned int fps=DEFAULT_FPS):
    director = Director(
        title,
        width=width,
        height=height,
        bits_per_pixel=bits_per_pixel,
        vsync=vsync,
        fps=fps,
    )
    return director


cpdef Director get_director():
    if not director:
        raise LookupError('Director must be initialised by calling init().')
    return director



