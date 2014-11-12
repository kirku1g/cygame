from config cimport Uint8
from csystem cimport (
    Vector2u,
)
from system cimport (
    create_vector2u,
)
cimport cgraphics
cimport graphics
from cwindow cimport Event
from window cimport (
    VideoMode,
    create_video_mode,
    #desktop_mode,
    #fullscreen_modes,
)
from scene cimport Scene


#cpdef VideoMode get_desktop_mode()
#cpdef list get_fullscreen_modes()

cdef class Director:
    cdef VideoMode video_mode
    cdef graphics.RenderWindowWrapper _window
    cdef list _scenes
    cdef readonly Scene scene
    cdef cgraphics.Color _clear_color
    cdef bytes _title
    cdef double _joystick_threshold
    cdef bint limit_mouse_move_events, _vsync, _mouse_cursor_visible, _repeat_key_enabled, _visible
    cdef unsigned int _fps
    
    cpdef Scene switch_scene(Director self, Scene scene)
    cpdef Scene pop_scene(Director self)
    cpdef push_scene(Director self, Scene scene)
    
    cpdef poll_events(Director self)
    cdef handle_event(Director self, Event* event_ptr)
    
    cpdef run(Director self)
    # width    
    cpdef unsigned int get_width(Director self)
    cpdef set_width(Director self, unsigned int width)
    # height    
    cpdef unsigned int get_height(Director self)
    cpdef set_height(Director self, unsigned int height)
    # size    
    cpdef Vector2u get_size(Director self)
    cpdef set_size(Director self, Vector2u size)
    cpdef tuple get_size_xy(Director self)
    cpdef set_size_xy(Director self, unsigned int x, unsigned int y)
    # title
    cpdef bytes get_title(Director self)
    cpdef set_title(Director self, bytes title)
    # vsync
    cpdef bint get_vsync(Director self)
    cpdef set_vsync(Director self, bint vsync)
    # mouse_cursor_visible
    cpdef bint get_mouse_cursor_visible(Director self)
    cpdef set_mouse_cursor_visible(Director, bint visible)
    # repeat_key_enabled
    cpdef bint get_repeat_key_enabled(Director self)
    cpdef set_repeat_key_enabled(Director self, bint enabled)
    # fps
    cpdef unsigned int get_fps(Director self)
    cpdef set_fps(Director self, unsigned int fps)
    # joystick_threshold
    cpdef float get_joystick_threshold(Director self)
    cpdef set_joystick_threshold(Director self, float threshold)
    # visible
    cpdef bint get_visible(Director self) except -1
    cpdef set_visible(Director, bint visible)# except *
    # clear_color
    cpdef set_clear_color(Director self, cgraphics.Color color)
    cpdef cgraphics.Color get_clear_color(Director self)
    # clear_color_rgb
    cpdef set_clear_color_rgb(Director self, Uint8 r, Uint8 g, Uint8 b)
    cpdef tuple get_clear_color_rgb(Director self)
    # clear_color_rgba
    cpdef set_clear_color_rgba(Director self, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
    cpdef tuple get_clear_color_rgba(Director self)

#cdef Director director


cpdef Director init(
    char* title,
    unsigned int width=*,
    unsigned int height=*,
    unsigned int bits_per_pixel=*,
    bint vsync=*,
    unsigned int fps=*,
)


cpdef Director get_director()

