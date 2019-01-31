### config headers

### rectangle sources

list( APPEND rectangle_srcs
Rectangle.cpp
Rectangle.h
)

add_library(rectangle SHARED ${rectangle_srcs})
install (TARGETS rectangle DESTINATION $INSTALL_LIB_DIR)
install (FILES rectangle/Rectangle.h DESTINATION $INSTALL_INCLUDE_DIR)
