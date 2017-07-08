#-------------------------------------------------------------------------------
# Name:        module1
# Purpose:
#
# Author:      tad
#
# Created:     12/10/2013
# Copyright:   (c) tad 2013
# Licence:     <your licence>
#-------------------------------------------------------------------------------

def main():
    pass

if __name__ == '__main__':
    main()
""" ex_animationstain.py - Staining animation for a pointcloud

  In this final exercise we load a pointcloud, we color each point using a different color so that
  we can color-pick the points. Then we define a "staining" animation based on color pick changes.
"""
from pyqtgraph.Qt import QtGui, QtCore
import pyqtgraph.opengl as gl
from pyqtgraph import Vector
import numpy as np
import GLCustomViewWidget
import GLPointCloudPlotItem

from ex_colmap import color_map_array
from ex_moebius import moebius_strip

# Define the QT application
app = QtGui.QApplication([])

# Create a custom glwidget object
glwidget = GLCustomViewWidget.GLCustomViewWidget()

# Compute the moebius strip and the colors
points = moebius_strip(nu=320, nv=40)
numpoints = points.shape[0]
colors, epsilon = color_map_array(numpoints)

# Compute centroid and bounding box
center = np.sum(points, axis=0)/float(numpoints)
min_xyz, max_xyz = np.min(points, axis=0), np.max(points, axis=0)
maxSize = max([max_xyz[0]-min_xyz[0],max_xyz[1]-min_xyz[1],max_xyz[2]-min_xyz[2]])

# Set glwidget initial values
glwidget.setWindowTitle('ex_animationstain.py')
glwidget.resize( 900, 600 )
glwidget.opts['center'] = Vector(center[0],center[1],center[2])
glwidget.opts['distance'] = 3.0*maxSize
glwidget.opts['azimuth'] = 0
glwidget.show()

# Define the grid plot-item (the "floor")
gscale = maxSize/10
gridz = gl.GLGridItem()
gridz.translate(center[0], center[1], min_xyz[2]-0.02*(max_xyz[2]-min_xyz[2]))
gridz.scale(gscale, gscale, gscale)
glwidget.addItem(gridz)

# Define a point-cloud plot-item
pointcloud = GLPointCloudPlotItem.GLPointCloudPlotItem(points=points, colors=colors, point_size=5)
glwidget.addItem(pointcloud)

# Global animation auxiliary variables
animation_index, animation_complete, animation_colors = 0, True, np.empty(0)
white, black = np.array([1.0, 1.0, 1.0]), np.array([0.0, 0.0, 0.0])
indices = np.empty(0)
oldcol = black

# Define the animation function
def check_pick_and_stain():
    """ Animate the colors of the pointcloud based on color pick changes

      When a new color is picked (glwidget.picked_color change its value) we:
      1) find the point P with the picked color (linear search);
      2) compute the ordering of the points with respect to the distance to P;
      3) start an animation where we progressively stain the points in that order
      4) don't stop the animation before it is complete!

      Note: this is a dirty animation script with poor design

    """
    global glwidget, pointcloud
    global numpoints, colors, indices
    global epsilon, white, black
    global animation_complete, animation_index, animation_colors
    global oldcol

    col = glwidget.picked_color
    valid_color = col <> None \
        and np.linalg.norm(col-black)  > epsilon \
        and np.linalg.norm(col-white)  > epsilon \
        and np.linalg.norm(col-oldcol) > epsilon

    if animation_complete and valid_color:

        # Try finding the point with that color
        index = None
        for i in xrange(points.shape[0]):
            if np.linalg.norm(colors[i]-col) < epsilon:
                index = i
                break

        # Return if no point found (e.g. background, weird epsilon)
        if index == None:
            oldcol = col
            return

        # Sort the points (indices) with respect to distance
        distances = np.array([np.linalg.norm(points[i]-points[index]) for i in xrange(numpoints)])
        indices = np.argsort(distances)

        # Ready to execute animation
        animation_index = 0
        animation_colors = np.copy(colors)
        animation_complete = False

    if not animation_complete:

        if animation_index < numpoints:

            # Change color to the next 1% closest, if possible
            for _ in xrange(int(numpoints*0.01)):
                if animation_index >= numpoints: break
                index = indices[animation_index]
                animation_colors[index] = glwidget.picked_color
                animation_index += 1

            # Set the new colors
            pointcloud.setData(colors=animation_colors)

        elif animation_index == numpoints:

            # Set last picked color to white
            glwidget.picked_color = white
            animation_index += 1

        else:

            # Reset everything when black is picked
            if np.linalg.norm(glwidget.picked_color-black) < epsilon:
                animation_complete = True
                animation_index = 0
                oldcol = glwidget.picked_color
                pointcloud.setData(colors=colors)
                glwidget.update()

# Define a new timer and connect the animation to it
timer = QtCore.QTimer()
timer.timeout.connect(check_pick_and_stain)
timer.start(30)

# Execute the application
print "Right click on a point to start staining, click on background to cancel..."
QtGui.QApplication.instance().exec_()
