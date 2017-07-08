""" ex_animationpick.py - Staining animation for a pointcloud

  In this exercise we load a pointcloud, we color each point using a different color so that
  we can color-pick the points. Then we define a "picking" animation based on color pick changes.

"""
from pyqtgraph.Qt import QtGui, QtCore
from pyqtgraph import Vector
import numpy as np
import GLCustomViewWidget
import GLPointCloudPlotItem
from ex_colmap import color_map_array

# Define the QT application
app = QtGui.QApplication([])

# Create a custom glwidget object
glwidget = GLCustomViewWidget.GLCustomViewWidget()

# Compute the moebius strip and the colors
numpoints = 30
points = np.empty([numpoints, 3])
for i in xrange(numpoints):
    points[i] = np.random.normal(0.0, 5.0, 3.0)
colors, epsilon = color_map_array(numpoints, shuffle=True)

# Compute centroid and bounding box
center = np.sum(points, axis=0)/float(numpoints)
min_xyz, max_xyz = np.min(points, axis=0), np.max(points, axis=0)
maxSize = max([max_xyz[0]-min_xyz[0],max_xyz[1]-min_xyz[1],max_xyz[2]-min_xyz[2]])

# Set glwidget initial values
glwidget.resize( 900, 600 )
glwidget.opts['center'] = Vector(center[0],center[1],center[2])
glwidget.opts['distance'] = 3.0*maxSize
glwidget.show()

# Define a point-cloud plot-item
pointcloud = GLPointCloudPlotItem.GLPointCloudPlotItem(points=points, colors=colors, point_size=20)
glwidget.addItem(pointcloud)

# Global animation auxiliary variables
white, black = np.array([1.0, 1.0, 1.0]), np.array([0.0, 0.0, 0.0])
oldcol = black

# Define the animation function
def check_pick_and_cancel():
    """ Animate the colors of the pointcloud based on color pick changes

      When a new color is picked (glwidget.picked_color change its value) we:
      1) find the point P with the picked color (linear search);
      2) change its color to black

      Note: this is a dirty animation script with poor design

    """
    global glwidget, pointcloud
    global numpoints, colors, indices
    global epsilon, white, black
    global oldcol

    col = glwidget.picked_color
    new_valid_color = col <> None and oldcol <> None \
        and np.linalg.norm(col-black)  > epsilon \
        and np.linalg.norm(col-white)  > epsilon \
        and np.linalg.norm(col-oldcol) > epsilon
        #\ means that you are on the same line!

    if new_valid_color:

        # Search the point with that color
        index = None
        for i in xrange(numpoints):
            if np.linalg.norm(colors[i]-col) < epsilon:
                index=i
                break
        # Set the corresponding color and set re-set the plot item
        if index <> None:
            colors[index] = black
            pointcloud.setData(colors=colors)

        oldcol = col


# Define a new timer and connect the animation to it
timer = QtCore.QTimer()
timer.timeout.connect(check_pick_and_cancel)
timer.start(30)

# Execute the application
print "Right click on a point to set its color to black..."
QtGui.QApplication.instance().exec_()