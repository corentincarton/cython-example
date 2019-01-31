include(add_cython_library)

list( APPEND pyrectangle_srcs
  Rectangle.pxd
  rect.pyx
)

add_cython_library(TARGET pyrectangle
                   SOURCES ${pyrectangle_srcs}
                   LIBS rectangle
                   INCLUDES ${CYTHONEXAMPLE_INCLUDE_DIRS}
                   LIB_DIRS ${CYTHONEXAMPLE_LIB_DIRS})

