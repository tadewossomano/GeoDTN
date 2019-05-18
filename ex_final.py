""" ex_final.py - display a colored moebius strip using PyQtGraph

  Final exercise for Remote Sensing laboratory 01: defining and plotting a
  pointcloud using pyqtgraph and GLPointCloudPlotItem.
  
  Last update: 01/10/2013, Marco Centin (marco.centin@gmail.com)

"""
from pyqtgraph.Qt import QtGui
import pyqtgraph.opengl as gl
import pyqtgraph as pg
import numpy as np

import GLPointCloudPlotItem
from pyqtgraph import Vector
from ex_moebius import moebius_strip

# Define the QT application
app = QtGui.QApplication([])

# Create a glwidget object
glwidget = gl.GLViewWidget()
glwidget.setWindowTitle('ex_final.py')
glwidget.resize( 1000, 650 )
glwidget.show()

# Compute the strip and useful data
points = moebius_strip()
numpoints = points.shape[0]
center = np.sum(points, axis=0)/float(numpoints)
min_xyz, max_xyz = np.min(points, axis=0), np.max(points, axis=0)
diam = max([ max_xyz[0]-min_xyz[0], max_xyz[1]-min_xyz[1], max_xyz[2]-min_xyz[2] ])

# Compute an array of rgba float colors with the same lenght as points
colors = np.empty([numpoints, 4])
for i in xrange(numpoints):
    colors[i] = pg.glColor(pg.intColor(i, hues=numpoints, alpha=200))

# Set the starting camera position
glwidget.opts['center'] = Vector(center[0],center[1],center[2])
glwidget.opts['distance'] = 3.0*diam
glwidget.opts['azimuth'] = 0

# Set the "floor" grid at 2% below the object
gscale = diam/10
gridz = gl.GLGridItem()
gridz.scale(gscale, gscale, gscale)
gridz.translate(center[0], center[1], min_xyz[2]-0.02*(max_xyz[2]-min_xyz[2]))
glwidget.addItem(gridz)

# Define the pointcloud graphics item
graph_item = GLPointCloudPlotItem.GLPointCloudPlotItem(
    points=points, colors=colors, point_size=2 )
glwidget.addItem(graph_item)

# Execute the application
QtGui.QApplication.instance().exec_()