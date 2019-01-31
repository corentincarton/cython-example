cmake_minimum_required( VERSION 3.10 FATAL_ERROR )

project( cython-example CXX )

enable_testing()

### dependencies

set( CMAKE_CXX_STANDARD 11 )
set( CMAKE_CXX_STANDARD_REQUIRED ON )

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

# find extra packages

# Python
# Can specify non-default distribution with CMake variable PYTHON_EXECUTABLE
find_package( PythonInterp REQUIRED )
message("PYTHON_EXECUTABLE    : ${PYTHON_EXECUTABLE}")

set( INSTALL_LIB_DIR lib )
set( INSTALL_INCLUDE_DIR include )

# Cython
find_package( Cython REQUIRED )
message("CYTHON_EXECUTABLE    : ${CYTHON_EXECUTABLE}")
find_package( PythonLibs REQUIRED )

# Project
set( CYTHONEXAMPLE_INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/src ${CMAKE_CURRENT_BINARY_DIR}/src )
set( CYTHONEXAMPLE_LIB_DIRS ${CMAKE_CURRENT_BINARY_DIR}/src/rectangle )

add_subdirectory( src )
add_subdirectory( tests )
