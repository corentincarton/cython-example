from libcpp.vector cimport vector

#cdef extern from "srcs/Rectangle.cpp":
#    pass

# Declare the class with cdef
cdef extern from "rectangle/Rectangle.h" namespace "shapes":
    cdef cppclass Rectangle:
        Rectangle() except +
        Rectangle(int, int, int, int) except +
        int getArea()
 #       void getSize(int* width, int* height)
        vector[int] getLimit()
        void move(int, int)
