from Cython.Build import cythonize

from setuptools import setup, Extension
from setuptools.dist import Distribution

libraries = ['csfml-system', 'csfml-graphics', 'csfml-network', 'csfml-audio', 'csfml-window']

ext_modules = [
    #Extension('cysfml.director', ['cysfml/director.pyx'], libraries=libraries),
    #Extension('cysfml.text', ['cysfml/text.pyx'], libraries=libraries),
    #Extension('cysfml.resources', ['cysfml/resources.pyx'], libraries=libraries),
    #Extension('cysfml.scene', ['cysfml/scene.pyx'], libraries=libraries),
    #Extension('cysfml.scheduler', ['cysfml/scheduler.pyx'], libraries=libraries),
]
ext_modules = cythonize(ext_modules)


setup(
    name="cygame",
    ext_modules=ext_modules,
)

