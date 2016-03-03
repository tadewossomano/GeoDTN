""" ex_visualize_moebius - Visualize the moebius strip in solid white

  This auxiliary script visualizes the Moebius strip in solid white

"""
from pyqtgraph.Qt import QtGui    #library from QTGUI
import pyqtgraph.opengl as gl
from pyqtgraph import Vector
import numpy as np
import GLCustomViewWidget
import GLPointCloudPlotItem
from ex_moebius import moebius_strip

# Define the QT application
app = QtGui.QApplication([])

# Create a custom glwidget object
glwidget = GLCustomViewWidget.GLCustomViewWidget() #OpenGL Widget

# Compute the moebius strip
points = moebius_strip(nu=320, nv=40)
numpoints = points.shape[0]

# Compute centroid and bounding box
center = np.sum(points, axis=0)/float(numpoints)
min_xyz, max_xyz = np.min(points, axis=0), np.max(points, axis=0)
maxSize = max([max_xyz[0]-min_xyz[0],max_xyz[1]-min_xyz[1],max_xyz[2]-min_xyz[2]])

# Set glwidget initial values
glwidget.setWindowTitle('ex_visualize_moebius.py')
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
pointcloud = GLPointCloudPlotItem.GLPointCloudPlotItem(points=points, point_size=1)
glwidget.addItem(pointcloud)

QtGui.QApplication.instance().exec_()