
from cysfml.graphics cimport (
    FontWrapper,
    TextureWrapper,
    SpriteWrapper,
)
from cysfml.audio cimport (
    MusicWrapper,
    SoundWrapper,
    SoundBufferWrapper,
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
        public bytes root_path
        public dict resources, cache_types
        public set preload_types
        public tuple file_types
    
    cpdef add_directory(ResourceManager self, bytes dir_path)
    cpdef remove_directory(ResourceManager self, bytes dir_path)
    cpdef update(ResourceManager self, bytes dir_path)
    #cpdef clear_cache(ResourceManager self, tuple resource_types=*)
    cpdef bint _add_file(ResourceManager self, bytes dir_path, bytes subpath) except -1
    cdef tuple _file_type(ResourceManager self, bytes file_path)
    cpdef TextureWrapper load_texture(ResourceManager self, bytes subpath)
    cpdef SpriteWrapper load_sprite(ResourceManager self, bytes subpath)
    cpdef FontWrapper load_font(ResourceManager self, bytes subpath)
    cpdef MusicWrapper load_music(ResourceManager self, bytes subpath)
    cpdef SoundWrapper load_sound(ResourceManager self, bytes subpath)
    cpdef SoundBufferWrapper load_sound_buffer(ResourceManager self, bytes subpath)
    
    #cpdef Sound load_sound(ResourceManager self, char* file_path):
        #return create_sound_from_sound_buffer(self.loaders[SoundBuffer][file_path])
    
    #cpdef Font load_font(ResourceManager self, char* file_path)
    cpdef unsigned int memory_usage(ResourceManager self)

cpdef unsigned int memory_usage(char* resource_type, object obj)
cpdef unsigned int memory_usage_texture(TextureWrapper texture)
cpdef unsigned int memory_usage_sound_buffer(SoundBufferWrapper sound_buffer)

#cpdef ResourceManager init(char* root_path, tuple file_types=*, set preload_types=*, dict cache_types=*)
#cpdef ResourceManager get_resource_manager()


cdef public ResourceManager cresource_manager