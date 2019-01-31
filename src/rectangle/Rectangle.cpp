#include <iostream>
#include "Rectangle.h"

namespace shapes {

    // Default constructor
    Rectangle::Rectangle () {}

    // Overloaded constructor
    Rectangle::Rectangle (int x0, int y0, int x1, int y1) {
        this->x0 = x0;
        this->y0 = y0;
        this->x1 = x1;
        this->y1 = y1;
        this->area = (this->x1 - this->x0) * (this->y1 - this->y0);
    }

    // Destructor
    Rectangle::~Rectangle () {}

    // Return the area of the rectangle
    int Rectangle::getArea () const {
        return area;
    }

    // Get the size of the rectangle.
    // Put the size in the pointer args
    void Rectangle::getSize (int *width, int *height) const {
        (*width) = x1 - x0;
        (*height) = y1 - y0;
    }

    std::vector<int> Rectangle::getLimit() const {
        std::vector<int> limit;
        limit.emplace_back(x0);
        limit.emplace_back(y0);
        limit.emplace_back(x1);
        limit.emplace_back(y1);

        return limit;
    }

    // Move the rectangle by dx dy
    void Rectangle::move (int dx, int dy) {
        this->x0 += dx;
        this->y0 += dy;
        this->x1 += dx;
        this->y1 += dy;
    }
}
