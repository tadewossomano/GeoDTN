""" ex_plot2d - basic plotting example using pyqtgraph

  This example is copied from the PyQTGraph examples and demonstrates a basic 2D plot.

"""
from pyqtgraph.Qt import QtGui
import pyqtgraph as pg
import numpy as np

app = QtGui.QApplication([])
win = pg.GraphicsWindow(title="ex_plot2d.py")
win.resize(900, 500)

# Plotting a function, like in MATLAB!
plt = win.addPlot(title="y = sin(x)")
x = np.linspace(0.0, 2.0*np.pi, 300)
y = np.sin(x)
plt.plot(x, y, pen=(255,255,255))

QtGui.QApplication.instance().exec_()