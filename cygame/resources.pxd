
from graphics cimport (
    Font,
    Texture,
)
from audio cimport (
    Music,
    Sound,
    SoundBuffer,
)


#cdef dict EXTENSIONS = {
    #'image': {
        #'bmp',
        #'png',
        #'tga',
        #'jpg',
        #'gif',
        #'psd',
        #'hdr',
        #'pic',    
    #},
    #'audio': {
        #'ogg',
        #'wav',
        #'flac',
        #'aiff',
        #'au',
        #'raw',
        #'paf',
        #'svx',
        #'nist',
        #'voc',
        #'ircam',
        #'w64',
        #'mat4',
        #'mat5',
        #'pvf',
        #'htk',
        #'sds',
        #'avr',
        #'sd2',
        #'caf',
        #'wve',
        #'mpc2k',
        #'rf64',
    #}
    #'font': {
        #'.ttf',
    #}
#}

#cdef dict LOADERS = {
    #'audio': create_sound_buffer_from_file,
    #'image': create_texture_from_file,
    #'font': create_font_from_file,
#}


cdef class ResourceManager:
    cdef:
        public char* root_path
        public dict resources, cache_types
        public set preload_types
    
    cpdef file_path(ResourceManager self, char* subpath)
    cpdef update(ResourceManager self)
    cpdef clear_cache(ResourceManager self, tuple resource_types=*)
    cpdef bint _add_file(ResourceManager self, char* subpath) except -1
    cdef tuple _file_type(ResourceManager self, char* file_path)
    cpdef Texture load_texture(ResourceManager self, char* subpath)
    cpdef Font load_font(ResourceManager self, char* subpath)
    cpdef Music load_music(ResourceManager self, char* subpath)    
    cpdef Sound load_sound(ResourceManager self, char* subpath)    
    cpdef SoundBuffer load_sound_buffer(ResourceManager self, char* subpath)
    
    #cpdef Sound load_sound(ResourceManager self, char* file_path):
        #return create_sound_from_sound_buffer(self.loaders[SoundBuffer][file_path])
    
    #cpdef Font load_font(ResourceManager self, char* file_path)
    cpdef unsigned int memory_usage(ResourceManager self)

cpdef unsigned int memory_usage(char* resource_type, object obj)
cpdef unsigned int memory_usage_texture(Texture texture)
cpdef unsigned int memory_usage_sound_buffer(SoundBuffer sound_buffer)

cpdef ResourceManager init(char* root_path, tuple file_types=*, set preload_types=*, dict cache_types=*)
cpdef ResourceManager get_resource_manager()