function( separate_sources )

  set( options )
  set( single_value_args TARGET  )
  set( multi_value_args  SOURCES )

  cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

  if(_PAR_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "Unknown keywords given to separate_sources(): \"${_PAR_UNPARSED_ARGUMENTS}\"")
  endif()

  if( NOT _PAR_TARGET  )
    message(FATAL_ERROR "The call to separate_sources() doesn't specify the TARGET.")
  endif()

  if( NOT _PAR_SOURCES )
    message(FATAL_ERROR "The call to separate_sources() doesn't specify the SOURCES.")
  endif()

  foreach( src ${_PAR_SOURCES} )
    if(${src} MATCHES "(\\.h$|\\.hxx$|\\.hh$|\\.hpp$|\\.H$)")
      list( APPEND ${_PAR_TARGET}_h_srcs ${src} )
    endif()
  endforeach()

  foreach( src ${_PAR_SOURCES} )
    if(${src} MATCHES "(\\.c$)")
      list( APPEND ${_PAR_TARGET}_c_srcs ${src} )
    endif()
  endforeach()

  foreach( src ${_PAR_SOURCES} )
    if(${src} MATCHES "(\\.cc$|\\.cxx$|\\.cpp$|\\.C$)")
      list( APPEND ${_PAR_TARGET}_cxx_srcs ${src} )
    endif()
  endforeach()

  foreach( src ${_PAR_SOURCES} )
    if(${src} MATCHES "(\\.f$|\\.F$|\\.for$|\\.f77$|\\.f90$|\\.f95$|\\.f03$|\\.f08$|\\.F77$|\\.F90$|\\.F95$|\\.F03$|\\.F08$)")
      list( APPEND ${_PAR_TARGET}_fortran_srcs ${src} )
    endif()
  endforeach()

    foreach( src ${_PAR_SOURCES} )
        if(${src} MATCHES "(\\.cu$)")
            list( APPEND ${_PAR_TARGET}_cuda_srcs ${src} )
        endif()
    endforeach()

  foreach( src ${_PAR_SOURCES} )
    if(${src} MATCHES "(\\.pyx$|\\.pdx$)")
      list( APPEND ${_PAR_TARGET}_cython_srcs ${src} )
    endif()
  endforeach()

    set_source_files_properties( ${${_PAR_TARGET}_fortran_srcs} PROPERTIES LANGUAGE Fortran )

    set( ${_PAR_TARGET}_h_srcs       "${${_PAR_TARGET}_h_srcs}"       PARENT_SCOPE )
    set( ${_PAR_TARGET}_c_srcs       "${${_PAR_TARGET}_c_srcs}"       PARENT_SCOPE )
    set( ${_PAR_TARGET}_cxx_srcs     "${${_PAR_TARGET}_cxx_srcs}"     PARENT_SCOPE )
    set( ${_PAR_TARGET}_fortran_srcs "${${_PAR_TARGET}_fortran_srcs}" PARENT_SCOPE )
    set( ${_PAR_TARGET}_cuda_srcs    "${${_PAR_TARGET}_cuda_srcs}"    PARENT_SCOPE )
    set( ${_PAR_TARGET}_cython_srcs  "${${_PAR_TARGET}_cython_srcs}"  PARENT_SCOPE )


endfunction( separate_sources )

function( add_cython_library )

  set( options )
  set( single_value_args TARGET )
  set( multi_value_args SOURCES LIBS INCLUDES DEPENDS LIB_DIRS)

  cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}" ${_FIRST_ARG} ${ARGN} )

  if(_PAR_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "Unknown keywords given to add_cython_library(): \"${_PAR_UNPARSED_ARGUMENTS}\"")
  endif()

  if( NOT _PAR_TARGET )
    message(FATAL_ERROR "The call to add_cython_library() doesn't specify the TARGET.")
  endif()

  if( NOT _PAR_SOURCES )
    message(FATAL_ERROR "The call to add_cython_library() doesn't specify SOURCES.")
  endif()

  # set target for the python configuration file
  set( CYTHON_TARGET ${_PAR_TARGET} )

  # Separate sources
  if( _PAR_SOURCES )
    separate_sources( TARGET ${_PAR_TARGET} SOURCES ${_PAR_SOURCES} )

    # need to copy the files in the build directory or cython will generate files in the source directory
    foreach (srcs ${_PAR_SOURCES})
      configure_file(${srcs} ${srcs} COPYONLY)
      # list(APPEND CYTHON_SRCS "${CMAKE_CURRENT_SOURCE_DIR}/${srcs}")
    endforeach(srcs)

    # Just keep c, cxx and cython files (.pyx and .pxd)
    set(CYTHON_SRCS ${${_PAR_TARGET}_cython_srcs} ${${_PAR_TARGET}_cxx_srcs} ${${_PAR_TARGET}_c_srcs})

    # Reformat to put in the python configuration file
    string(REPLACE ";" "\",\"" CYTHON_SRCS "${CYTHON_SRCS}")
    string(APPEND CYTHON_SRCS "\"" )
    string(PREPEND CYTHON_SRCS "\"" )
  endif()

  # add the link libraries
  if( DEFINED _PAR_LIBS )
    list(REMOVE_DUPLICATES _PAR_LIBS )
    foreach( lib ${_PAR_LIBS} ) # skip NOTFOUND
      if( lib )
        message("add_cython_library(${_PAR_TARGET}): linking with [${lib}]")
      else()
        message("add_cython_library(${_PAR_TARGET}): ${lib} not found - not linking")
      endif()
    endforeach()

    # Reformat to put in the python script
    string(REPLACE ";" "\",\"" CYTHON_LIBS "${_PAR_LIBS}")
    string(APPEND CYTHON_LIBS "\"" )
    string(PREPEND CYTHON_LIBS "\"" )
  endif()

  # add include dirs if defined
  if( DEFINED _PAR_INCLUDES )
    list( REMOVE_DUPLICATES _PAR_INCLUDES )
    foreach( path ${_PAR_INCLUDES} ) # skip NOTFOUND
      if( path )
        message("add_cython_library(${_PAR_TARGET}): add ${path} to include_directories")
      else()
        message("add_cython_library(${_PAR_TARGET}): ${path} not found - not adding to include_directories")
      endif()
    endforeach()

    # Reformat to put in the python script
    string(REPLACE ";" "\",\"" CYTHON_INCLUDES "${_PAR_INCLUDES}")
    string(APPEND CYTHON_INCLUDES "\"" )
    string(PREPEND CYTHON_INCLUDES "\"" )
  endif()

  # Set libary paths
  if( DEFINED _PAR_LIB_DIRS )
    set( CYTHON_LIBS_DIRS ${_PAR_LIB_DIRS} )
    message("add_cython_library(${_PAR_TARGET}): add ${CYTHON_LIBS_DIRS} to library directories")
  endif()
  set( CYTHON_INSTALL_LIBS_DIRS ${CMAKE_INSTALL_PREFIX}/${INSTALL_LIB_DIR} )
  message("add_cython_library(${_PAR_TARGET}): add ${CYTHON_INSTALL_LIBS_DIRS} to install library directories")

  # Generate setup file
  configure_file(${CMAKE_SOURCE_DIR}/cmake/cython.py.in setup.py @ONLY)

  # Generate library 
  set( INSTALL_CYTHON_DIR ${INSTALL_LIB_DIR}/python )
  add_custom_target(${CYTHON_TARGET} ALL
                    COMMAND ${PYTHON_EXECUTABLE} setup.py build_ext --build-lib ${CMAKE_BINARY_DIR}/${INSTALL_CYTHON_DIR}/
                    DEPENDS ${_PAR_LIBS} ${_PAR_SOURCES}
                    )

  # Install 
  if( NOT _PAR_NOINSTALL )

  	# locate python library
    message("add_cython_library(${_PAR_TARGET}): installing to ${CMAKE_INSTALL_PREFIX}/${INSTALL_CYTHON_DIR}")

    install( DIRECTORY ${CMAKE_BINARY_DIR}/${INSTALL_CYTHON_DIR}/
             DESTINATION ${CMAKE_INSTALL_PREFIX}/${INSTALL_CYTHON_DIR}
             FILES_MATCHING PATTERN "${_PAR_TARGET}.*.so" )
  else()
    message("add_cython_library(${_PAR_TARGET}): not installing")
  endif()

endfunction( add_cython_library )
