from cgraphics cimport (
    FloatRect,
)
#from resources import resources

ALIGN_LEFT = 1
ALIGN_CENTER = 2
ALIGN_RIGHT = 3
ALIGN_TOP = 4
ALIGN_BOTTOM = 5


cpdef align(drawable, unsigned int screen_width, unsigned int screen_height):
    cdef FloatRect rect = drawable.get_local_bounds()
    drawable.set_origin_xy(rect.left + rect.width / 2, rect.top + rect.height / 2)
    drawable.set_position_xy(screen_width / 2, screen_height / 2)

#cdef class Align:
    
    #def __cinit__(Label self, char* text, char* font_name, unsigned int align):
        #self.text = create_text()
        #self.text.set_string(text)
        #self.text.set_font(resources.get_font(font_name))
        #cdef Font font = 
        
        
        