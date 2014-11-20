import os
from cysfml.cgraphics cimport (
    Vector2u,
)
from cysfml.graphics cimport (
    FontWrapper,
    
    TextureWrapper,
    SpriteWrapper,
    #create_font_from_file,
)
from cysfml.audio cimport (
    MusicWrapper,
    SoundWrapper,
    SoundBufferWrapper,
)


# Supported file extensions.
cdef dict EXTENSIONS = {
    b'image': {
        b'bmp',
        b'png',
        b'tga',
        b'jpg',
        b'gif',
        b'psd',
        b'hdr',
        b'pic',
    },
    b'audio': {
        b'ogg',
        b'wav',
        b'flac',
        b'aiff',
        b'au',
        b'raw',
        b'paf',
        b'svx',
        b'nist',
        b'voc',
        b'ircam',
        b'w64',
        b'mat4',
        b'mat5',
        b'pvf',
        b'htk',
        b'sds',
        b'avr',
        b'sd2',
        b'caf',
        b'wve',
        b'mpc2k',
        b'rf64',
    },
    b'font': {
        b'ttf', # TrueType
        b'lwfn', # Type 1
        # TODO: CFF/Type 2
        # TODO: SFNT
        b'pcf', # X11 PCF
        b'fnt', # Windows FNT
        b'bdf', # BDF
        b'pfr', # PFR
        # TODO: Type 42
    },
}


# Default loader classes.
cdef dict LOADERS = {
    b'audio': SoundBufferWrapper,
    b'image': TextureWrapper,
    b'font': FontWrapper,
}


cdef tuple FILE_TYPES_DEFAULT = tuple(EXTENSIONS)


# By default, image, audio and font files up to 500kb are cached.
cdef dict CACHE_TYPES_DEFAULT = {
    b'image': 524288,
    b'audio': 524288,
    b'font': 524288,
}


# By default, do not preload any resource types.
cdef set PRELOAD_TYPES_DEFAULT = set()


# Estimated compression ratios.
cdef dict COMPRESSION_RATIOS = {
    b'png': 20,
    b'jpg': 20,
    b'gif': 20,
    b'ogg': 10,
    b'flac': 2,
}


cdef class ResourceManager:
    #cpdef SoundBuffer load_sound_buffer()
    
    def __cinit__(ResourceManager self):
        self.file_types = FILE_TYPES_DEFAULT
        self.preload_types = PRELOAD_TYPES_DEFAULT
        self.cache_types = CACHE_TYPES_DEFAULT
        
        self.resources = {}
    
    cpdef add_directory(ResourceManager self, bytes dir_path):
        if not os.path.isdir(dir_path):
            raise ValueError(b'Directory does not exist: %s' % dir_path)
        
        # Force trailing slash os-independently
        dir_path_trailing_slash = os.path.join(dir_path, b'')
        self.resources[dir_path_trailing_slash] = {t: {} for t in self.file_types}
        self.update(dir_path_trailing_slash)
    
    cpdef remove_directory(ResourceManager self, bytes dir_path):
        del self.resources[dir_path]
    
    cpdef update(ResourceManager self, bytes dir_path):
        cdef bytes filename
        #cdef list dirnames, filenames
        for root, dirnames, filenames in os.walk(dir_path):
            root = root.lstrip(dir_path)
            for filename in filenames:
                try:
                    self._add_file(dir_path, os.path.join(root, filename))
                except ValueError:
                    pass
    
    cdef tuple _file_type(ResourceManager self, bytes file_path):
        extension = os.path.splitext(file_path)[1][1:].lower()
        cdef char* file_type
        cdef set extensions
        
        for file_type in self.file_types:
            if extension in EXTENSIONS[file_type]:
                return file_type, extension
        raise ValueError('Unknown file type: %s' % file_path)
    
    #cpdef clear_cache(ResourceManager self, tuple resource_types=None):
        #'''
        #Clear cache contents.
        #'''
        #if not resource_types:
            #resource_types = tuple(self.cache_types)
        #cdef dict files
        ##cdef char* file_path, resource_type
        #for resource_type in resource_types:
            #files = self.resources[resource_type]
            #for file_path, resource in files.items():
                #if resource:
                    #files[file_path] = None
    
    cpdef bint _add_file(ResourceManager self, bytes dir_path, bytes subpath) except -1:
        file_type, extension = self._file_type(subpath)
        cdef bytes full_path = os.path.join(dir_path, subpath)
        cdef unsigned int file_size, size_limit
        cdef bint preload = False
        if file_type in self.preload_types:
            size_limit = self.cache_types[file_type]
            if size_limit:
                file_size = os.path.getsize(full_path)
                if extension in COMPRESSION_RATIOS:
                    file_size *= COMPRESSION_RATIOS[extension]
                preload = file_size <= size_limit
            else:
                preload = True
        self.resources[dir_path][file_type][subpath] = LOADERS[file_type].from_file(full_path) if preload else None
        return True
    
        extension = os.path.splitext(file_path)[1][1:].lower()
        cdef char* file_type
        cdef set extensions
        
        for file_type in self.resources:
            if extension in EXTENSIONS[file_type]:
                return file_type, extension
        raise ValueError('Unknown file type: %s' % file_path)
    
    def load(ResourceManager self, bytes resource_type, bytes subpath):
        for dir_path, resources in self.resources.items():
            resource = resources[resource_type][subpath]
            if not resource:
                resource = LOADERS[resource_type].from_file(os.path.join(dir_path, subpath))
                if resource_type in self.cache_types:
                    size_limit = self.cache_types[resource_type]
                    if not size_limit or memory_usage(resource_type, resource) <= size_limit:
                        resources[resource_type][subpath] = resource
        return resource
    
    cpdef TextureWrapper load_texture(ResourceManager self, bytes subpath):
        return self.load(b'image', subpath)
    
    cpdef SpriteWrapper load_sprite(ResourceManager self, bytes subpath):
        return SpriteWrapper.from_texture(self.load(b'image', subpath))
    
    cpdef SoundBufferWrapper load_sound_buffer(ResourceManager self, bytes subpath):
        return self.load(b'audio', subpath)
    
    cpdef SoundWrapper load_sound(ResourceManager self, bytes subpath):
        return SoundWrapper.from_sound_buffer(self.load(b'audio', subpath))
    
    cpdef MusicWrapper load_music(ResourceManager self, bytes subpath):
        return MusicWrapper.from_file(self.file_path(subpath))
    
    cpdef FontWrapper load_font(ResourceManager self, bytes subpath):
        return self.load(b'font', subpath)
    
    cpdef unsigned int memory_usage(ResourceManager self):
        cdef unsigned int usage = 0
        cdef Vector2u vector
        for resources in self.resources.values():
            for texture in resources[b'image'].values():
                if not texture:
                    continue
                usage += memory_usage_texture(texture)
            
            for sound_buffer in resources[b'audio'].values():
                if not sound_buffer:
                    continue
                usage += memory_usage_sound_buffer(sound_buffer)
            # TODO: font
            
            return usage


cpdef unsigned int memory_usage(char* resource_type, object obj):
    if resource_type == b'image':
        return memory_usage_texture(obj)
    elif resource_type == b'audio':
        return memory_usage_sound_buffer(obj)
    elif resource_type == b'font':
        return 100000 # Estimate
    else:
        return 0


cpdef unsigned int memory_usage_texture(TextureWrapper texture):
    '''
    rgba per pixel.
    '''
    cdef Vector2u vector = texture.get_size_struct()
    return vector.x * vector.y * 4


cpdef unsigned int memory_usage_sound_buffer(SoundBufferWrapper sound_buffer):
    '''
    16-bit samples.
    '''
    return sound_buffer.get_sample_count() * 2


#cdef ResourceManager resource_manager = ResourceManager()

#cpdef ResourceManager init(
        #char* root_path,
        #tuple file_types=FILE_TYPES_DEFAULT,
        #set preload_types=PRELOAD_TYPES_DEFAULT,
        #dict cache_types=CACHE_TYPES_DEFAULT):
    #resource_manager = ResourceManager(
        #root_path=root_path,
        #file_types=file_types,
        #preload_types=preload_types,
        #cache_types=cache_types,
    #)
    #return resource_manager.init


#cpdef ResourceManager get_resource_manager():
    #if not resource_manager.resources:
        #raise ValueError('init() must be called before get_resource_manager()')
    #return resource_manager

resource_manager = ResourceManager()

cdef ResourceManager cresource_manager = resource_manager

