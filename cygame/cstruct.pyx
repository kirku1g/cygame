###from cpython cimport array
###from array import array

###cdef array.array a = array('i', [1, 2, 3])
###cdef array.array b = array('i', [4, 5, 6])

#### extend a with b, resize as needed
###array.extend(a, b)
#### resize a, leaving just original three elements
###array.resize(a, len(a) - len(b))

from cpython.array cimport array as carray, clone
from array import array
from libc.string cimport memcmp, memcpy
from libc.math cimport frexp, ldexp
from libc.stdint cimport int32_t, int64_t

ctypedef fused integer:
    int32_t
    int64_t


# Work out machine's endianness.
# TODO: Can we assume?
cdef enum float_format_type:
    unknown_format,
    ieee_big_endian_format,
    ieee_little_endian_format

# Set-up
cdef carray stringtemplate = array('B')
cdef float_format_type double_format

cdef double x = 9006104071832581.0

if sizeof(double) == 8:
    if memcmp(&x, b"\x43\x3f\xff\x01\x02\x03\x04\x05", 8) == 0:
        double_format = ieee_big_endian_format
    elif memcmp(&x, b"\x05\x04\x03\x02\x01\xff\x3f\x43", 8) == 0:
        double_format = ieee_little_endian_format
    else:
        double_format = unknown_format

else:
    double_format = unknown_format


cdef unsigned char UNSIGNED_BYTE = 0
cdef unsigned char SIGNED_BYTE = 1
cdef unsigned char UNSIGNED_SHORT = 2
cdef unsigned char SIGNED_SHORT = 3
cdef unsigned char UNSIGNED_INT = 4
cdef unsigned char SIGNED_INT = 5
cdef unsigned char UNSIGNED_LONG = 6
cdef unsigned char SIGNED_LONG = 7
cdef unsigned char FLOAT = 8
cdef unsigned char DOUBLE = 9
cdef unsigned char CHAR = 10

cdef unsigned char LIST_BYTE = 20
cdef unsigned char LIST_SHORT = 21
cdef unsigned char LIST_INT = 22

cdef unsigned char POSITION = 30
cdef unsigned char COLOR = 31


cdef unsigned char* CONNECT = [
    UNSIGNED_BYTE, # icon
    COLOR,
    
    LIST_BYTE, # ip/hostname
    CHAR,
    
    LIST_BYTE,
    CHAR,
]

cdef carray ARRAY_TEMPLATE_UNSIGNED_CHAR = array('B', [])


cdef carray new_array_unsigned_char(unsigned short size):
    cdef carray new_array
    clone(ARRAY_TEMPLATE_UNSIGNED_CHAR, size, zero=False)

cdef carray SIZES = new_array_unsigned_char(32)
SIZES[UNSIGNED_BYTE] = 1
SIZES[SIGNED_BYTE] = 1
SIZES[UNSIGNED_SHORT] = 2
SIZES[SIGNED_SHORT] = 2
SIZES[UNSIGNED_INT] = 4
SIZES[SIGNED_INT] = 4
SIZES[UNSIGNED_LONG] = 8
SIZES[SIGNED_LONG] = 8
SIZES[FLOAT] = 4
SIZES[DOUBLE] = 8
SIZES[CHAR] = 1

SIZES[LIST_BYTE] = 1
SIZES[LIST_SHORT] = 2
SIZES[LIST_INT] = 4

SIZES[POSITION] = 12
SIZES[COLOR] = 3



cdef carray SERVER_KICK = new_array_unsigned_char(1)
SERVER_KICK[0] = UNSIGNED_BYTE

#cdef array unpack_data(array data_format, bytes data):
    #cdef unsigned char format_type
    #cdef unsigned int list_size
    
    #cdef unsigned int index = 0
    
    #values = []
    
    #for format_type in data_format:
        #if format_type == LIST_BYTE:
            #list_size = data[index]
            #index += LIST_BYTE_SIZE
        #elif format_type == LIST_SHORT:
            #list_size = unpack_unsigned_short(index, data)
            #index += LIST_SHORT_SIZE
        #elif format_type == LIST_INT:
            #list_size = unpack_unsigned_int(index, data)
            #index += LIST_INT_SIZE

cpdef unpack_list(carray data_format, unsigned int size, unsigned int index, bytes data):
    cdef unsigned char format_type, list_index, data_index = 0
    
    values = []
    
    for list_index in range(size):
        for format_type in data_format:
            values.append(unpack_unsigned_short(data_index, data))
            data_index += SIZES[format_type]
    
    return values

#a = new_array(10)
#print a


#def unpack_bytes(for x in data):

#    return unpack_short(0, data)


cdef unsigned short unpack_unsigned_short(unsigned int index, char* data):
    return (data[index] << 8) + data[index + 1]


cdef unsigned int unpack_unsigned_int(unsigned int index, char* data):
    return (data[index] << 24) + (data[index] << 16) + (data[index] << 8) + data[index]


cdef unsigned int unpack_unsigned_long(unsigned int index, char* data):
    return (data[index] << 56) + (data[index] << 48) + (data[index] << 40) + (data[index] << 32) + (data[index] << 24) + (data[index] << 16) + (data[index] << 8) + data[index]



cdef void _write_integer(integer x, char* output):
    cdef int i
    for i in range(sizeof(integer)-1, -1, -1):
        output[i] = <char>x
        x >>= 8

cpdef bytes write_int(int32_t i):
    cdef carray output = clone(stringtemplate, sizeof(int32_t), False)
    _write_integer(i, output.data.as_chars)
    return output.data.as_chars[:sizeof(int32_t)]

cpdef bytes write_long(int64_t i):
    cdef carray output = clone(stringtemplate, sizeof(int64_t), False)
    _write_integer(i, output.data.as_chars)
    return output.data.as_chars[:sizeof(int64_t)]

cdef void _write_double(double x, char* output):
    cdef:
        unsigned char sign
        int e
        double f
        unsigned int fhi, flo, i
        char *s

    if double_format == unknown_format or True:
        if x < 0:
            sign = 1
            x = -x

        else:
            sign = 0

        f = frexp(x, &e)

        # Normalize f to be in the range [1.0, 2.0)

        if 0.5 <= f < 1.0:
            f *= 2.0
            e -= 1

        elif f == 0.0:
            e = 0

        else:
            raise SystemError("frexp() result out of range")

        if e >= 1024:
            raise OverflowError("float too large to pack with d format")

        elif e < -1022:
            # Gradual underflow
            f = ldexp(f, 1022 + e)
            e = 0;

        elif not (e == 0 and f == 0.0):
            e += 1023
            f -= 1.0 # Get rid of leading 1

        # fhi receives the high 28 bits; flo the low 24 bits (== 52 bits)
        f *= 2.0 ** 28
        fhi = <unsigned int>f # Truncate

        assert fhi < 268435456

        f -= <double>fhi
        f *= 2.0 ** 24
        flo = <unsigned int>(f + 0.5) # Round

        assert(flo <= 16777216);

        if flo >> 24:
            # The carry propagated out of a string of 24 1 bits.
            flo = 0
            fhi += 1
            if fhi >> 28:
                # And it also progagated out of the next 28 bits.
                fhi = 0
                e += 1
                if e >= 2047:
                    raise OverflowError("float too large to pack with d format")

        output[0] = (sign << 7) | (e >> 4)
        output[1] = <unsigned char> (((e & 0xF) << 4) | (fhi >> 24))
        output[2] = 0xFF & (fhi >> 16)
        output[3] = 0xFF & (fhi >> 8)
        output[4] = 0xFF & fhi
        output[5] = 0xFF & (flo >> 16)
        output[6] = 0xFF & (flo >> 8)
        output[7] = 0xFF & flo

    else:
        s = <char*>&x;

        if double_format == ieee_little_endian_format:
            for i in range(8):
                output[i] = s[7-i]

        else:
            for i in range(8):
                output[i] = s[i]


cdef bytes write_double(double x):
    cdef carray output = clone(stringtemplate, sizeof(double), False)
    _write_double(x, output.data.as_chars)
    return output.data.as_chars[:sizeof(double)]


cdef bytes write_string(bytes val):
    cdef:
        int32_t int_length = sizeof(int32_t)
        int32_t input_length = len(val)
        carray output = clone(stringtemplate, int_length + input_length, True)

    _write_integer(input_length, output.data.as_chars)
    memcpy(output.data.as_chars + int_length, <char*>val, input_length)

    return output.data.as_chars[:int_length + input_length]