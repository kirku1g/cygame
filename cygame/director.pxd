from cysfml.config cimport Uint8

from cysfml cimport (
    csystem,
    system,
    cgraphics,
    graphics,
)
from cysfml.cwindow cimport Event, VideoMode

from actions cimport Action
from scene cimport Scene
from scheduler cimport Scheduler


#cpdef VideoMode get_desktop_mode()
#cpdef list get_fullscreen_modes()

cdef class Director:
    cdef VideoMode video_mode
    cdef public graphics.RenderWindowWrapper window
    cdef list _scenes
    cdef readonly Scene scene
    cdef cgraphics.Color _clear_color
    cdef bytes _title
    cdef double _joystick_threshold
    cdef public bint limit_mouse_move_events
    cdef bint _vsync, _mouse_cursor_visible, _key_repeat, _visible
    cdef unsigned int _fps
    
    cpdef do(Director self, target, Action action)
    
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
    cpdef tuple get_size(Director self)
    cpdef csystem.Vector2u get_size_struct(Director self)
    cpdef tuple get_size_xy(Director self)
    cpdef set_size(Director self, size)
    cpdef set_size_struct(Director self, csystem.Vector2u size)
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
    cpdef bint get_key_repeat(Director self)
    cpdef set_key_repeat(Director self, bint enabled)
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
    cpdef set_clear_color(Director self, color)
    cpdef set_clear_color_struct(Director self, cgraphics.Color color)
    cpdef set_clear_color_rgb(Director self, Uint8 r, Uint8 g, Uint8 b)
    cpdef set_clear_color_rgba(Director self, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
    cpdef tuple get_clear_color(Director self)
    cpdef cgraphics.Color get_clear_color_struct(Director self)
    cpdef tuple get_clear_color_rgb(Director self)
    cpdef tuple get_clear_color_rgba(Director self)

#cdef Director director


cpdef public Director cdirector

