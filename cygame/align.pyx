from cgraphics import Vector2f

from director cimport (
    Director
    get_director,
)

cdef ALIGN_CENTER = 0
cdef ALIGN_TOP = 1
cdef ALIGN_BOTTOM = 2
cdef ALIGN_LEFT = 3
cdef ALIGN_RIGHT = 4

cdef Director director



cpdef align(Node node, float align_x, float align_y, float, )

cpdef align_within_window(Node node):
    director = get_director()
    cdef Vector2f size = director.get_size()
    align(director, size.x, size.y)
