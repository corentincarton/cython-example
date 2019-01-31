import pyrectangle as rect
import os
try:
    user_paths = os.environ['PYTHONPATH'].split(os.pathsep)
except KeyError:
    user_paths = []
    
x0, y0, x1, y1 = 1, 2, 3, 4
r = rect.PyRectangle(x0, y0, x1, y1)

print(r.get_limit())
r.move(0,2)
print(r.get_limit())
