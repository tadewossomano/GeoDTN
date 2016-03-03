""" ex_planes.py - Sampling a plane portion in the 3D space

  In this exercise we sample a rectangular portion of a plane and we position it in the space.

"""
import ex_labfunctions as lf
from pyqtgraph.Qt import QtGui
import pyqtgraph.opengl as gl
import GLCustomViewWidget
import GLPointCloudPlotItem

# Define the QT application and a glwidget
app = QtGui.QApplication([])
glwidget = GLCustomViewWidget.GLCustomViewWidget()

# Compute the points
points = lf.sample_plane_portion(
    width     = 1.0,
    height    = 3.0,
    numpoints = 500,
    center    = [0.0, 0.0, 2.0],
    normal    = [1.0, 1.0, 1.0],
    rotation  = 0.0,
    noise     = [0.0001, 0.0001, 0.0001] )

# Set glwidget initial values
glwidget.resize( 900, 600 )
glwidget.opts['distance'] = 11
glwidget.opts['azimuth'] = 45
glwidget.opts['elevation'] = 40
glwidget.show()

# Define a point-cloud plot-item
pl_points = GLPointCloudPlotItem.GLPointCloudPlotItem(points=points, point_size=4)
glwidget.addItem(pl_points)

# Set the default floor grid
gscale = 0.5
pl_gridz = gl.GLGridItem()
pl_gridz.scale(gscale, gscale, gscale)
glwidget.addItem(pl_gridz)

# Set the axis
pl_axis = gl.GLAxisItem()
glwidget.addItem(pl_axis)

# Execute the application
QtGui.QApplication.instance().exec_()