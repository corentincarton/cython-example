#ifndef RECTANGLE_H
#define RECTANGLE_H

#include <vector>

namespace shapes {
    class Rectangle {
        public:
            int x0, y0, x1, y1;
            int area;
            Rectangle();
            Rectangle(int x0, int y0, int x1, int y1);
            ~Rectangle();
            int getArea() const;
            void getSize(int* width, int* height) const;
            void move(int dx, int dy);
            std::vector<int> getLimit() const;
    };
}

#endif