""" ex_numpy.py - defining an array of coordinates

  In this exercise we familiarize with NumPy.

"""
import numpy as np

n = 100000

# Define a set of random point using random
points = np.empty([n,3])
for i in xrange(n):
    points[i] = np.random.normal(0.0, 5.0, 3)

# Computes the center of mass using sum
center = np.sum(points, axis=0)/float(points.shape[0])

# Computes the 3d bounding box using min-max
min_xyz = np.min(points, axis=0)
max_xyz = np.max(points, axis=0)

# Use string formatting for printing the result
print "Number of points: %d"%n
print "Center: (%.6f, %.6f, %.6f)"%(center[0],center[1],center[2])
print "Range x: from %.3f to %.3f"%(min_xyz[0],max_xyz[0])
print "Range y: from %.3f to %.3f"%(min_xyz[1],max_xyz[1])
print "Range z: from %.3f to %.3f"%(min_xyz[2],max_xyz[2])