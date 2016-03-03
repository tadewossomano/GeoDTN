""" ex_vaseprofile.py - Display the profile of the vase

  Takes the function vase_profile in ex_laboratory function and plot the curve in the ZX plane.

"""
import ex_labfunctions as lf
from ex_labfunctions import np
from pyqtgraph.Qt import QtGui
import pyqtgraph.opengl as gl
from pyqtgraph import Vector
import GLCustomViewWidget

# Define the QT application and a glwidget
app = QtGui.QApplication([])
glwidget = GLCustomViewWidget.GLCustomViewWidget()

# Compute the points
numrings = 200
zxcurve = lf.vase_profile(numrings)

# Set glwidget initial values
glwidget.resize( 900, 600 )
glwidget.opts['center'] = Vector(0,0,2)
glwidget.opts['distance'] = 20
glwidget.opts['azimuth'] = -90
glwidget.opts['elevation'] = 20
glwidget.show()

# Set the "floor" grid 2% below the object
gscale = 0.5
pl_gridz = gl.GLGridItem()
pl_gridz.scale(gscale, gscale, gscale)
glwidget.addItem(pl_gridz)

# Define a line plot-item for the curve
curve = np.column_stack([zxcurve[:,1], np.zeros(numrings), zxcurve[:,0] ])
pl_curve = gl.GLLinePlotItem(pos=curve, color=(1.0,1.0,1.0,0.5))
glwidget.addItem(pl_curve)

# Execute the application
QtGui.QApplication.instance().exec_()