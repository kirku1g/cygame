from Cython.Build import cythonize

from setuptools import setup, Extension
from setuptools.dist import Distribution

libraries = ['csfml-system', 'csfml-graphics', 'csfml-network', 'csfml-audio', 'csfml-window']

ext_modules = [
    Extension('cygame.actions', ['cygame/actions.pyx'], libraries=libraries),
    Extension('cygame.director', ['cygame/director.pyx'], libraries=libraries),
    #Extension('cygame.text', ['cygame/text.pyx'], libraries=libraries),
    Extension('cygame.node', ['cygame/node.pyx'], libraries=libraries),
    Extension('cygame.primitives', ['cygame/primitives.pyx'], libraries=libraries),
    Extension('cygame.resources', ['cygame/resources.pyx'], libraries=libraries),
    Extension('cygame.scene', ['cygame/scene.pyx'], libraries=libraries),
    Extension('cygame.scheduler', ['cygame/scheduler.pyx'], libraries=libraries),
    
    Extension('cygame.sortedlist', ['cygame/sortedlist.pyx'], libraries=libraries),
    
    #Extension('cygame.space_shooter', ['cygame/space_shooter.pyx'], libraries=libraries),
]
ext_modules = cythonize(ext_modules)


setup(
    name="cygame",
    ext_modules=ext_modules,
)

