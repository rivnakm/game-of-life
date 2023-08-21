from setuptools import setup
from Cython.Build import cythonize

setup(
    name="Game of Life",
    ext_modules=cythonize("*.pyx", language_level = "3")
)