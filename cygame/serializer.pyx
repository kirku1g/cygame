'''
A mapping of object tyoe to serializer functions is stored on the Serializer object.

A serializer function receives the object to serialise, an unsigned char array and an index to start outputting the serialzed form of the array to within the array.

'''

cimport cgraphics


cpdef serialize_color(cgraphics.Color color, unsigned char* data, unsigned int index):
    data[index] = color.r
    data[index + 1] = color.g
    data[index + 2] = color.b
    data[index + 3] = color.a


# TODO
#cpdef serialise_float_rect(cgraphics.FloatRect rect, unsigned char* data, unsigned int index):
    #data[index] 


cdef dict SERIALIZE_FUNCTIONS = {Color: serialize_color}



cdef class Serializer:
    cpdef serialize(Serializer self, object obj):
        self.serialize_functions[obj]
        
