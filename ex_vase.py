""" ex_vase.py - Modeling the shape of a surface of revolution

  In this exercise we define a surface of revolution of a curve placed on the ZX plane around
  the Z axis. We define a pointcloud of that surface and we do color-picking on the rings.
  We then define an animation so that by clicking a ring we locally deform the neighbors!

"""

# Our laboratory functions module!
import ex_labfunctions as lf
from ex_labfunctions import np

# The core part of PyQtGraph
from pyqtgraph.Qt import QtGui, QtCore
import pyqtgraph.opengl as gl

# Some custom modules
import GLCustomViewWidget
import GLPointCloudPlotItem
from pyqtgraph import Vector

# Define the QT application and a glwidget
app = QtGui.QApplication([])
glwidget = GLCustomViewWidget.GLCustomViewWidget()

# Compute the points
numrings, numtheta = 150, 200
zxcurve = lf.vase_profile(numrings)
points = lf.surface_of_revolution(zxcurve, numtheta)

# Define ring colors (numpy hack)
numpoints = points.shape[0]
ring_colors, epsilon = lf.color_map_array(numrings, shuffle=True)
colors = np.column_stack([ring_colors for _ in xrange(numtheta) ]).reshape([numrings*numtheta,3])

# Compute centroid and bounding box
center = np.sum(points, axis=0)/float(numpoints)
min_xyz, max_xyz = np.min(points, axis=0), np.max(points, axis=0)
maxSize = max([max_xyz[0]-min_xyz[0],max_xyz[1]-min_xyz[1],max_xyz[2]-min_xyz[2]])

# Set glwidget initial values
glwidget.resize( 900, 600 )
glwidget.opts['center'] = Vector(center[0],center[1],center[2])
glwidget.opts['distance'] = 3.0*maxSize
glwidget.opts['azimuth'] = -90
glwidget.opts['elevation'] = 20
glwidget.show()

# Set the "floor" grid 2% below the object
gscale = maxSize/10
pl_gridz = gl.GLGridItem()
pl_gridz.translate(center[0], center[1], min_xyz[2]-0.02*(max_xyz[2]-min_xyz[2]))
pl_gridz.scale(gscale, gscale, gscale)
glwidget.addItem(pl_gridz)

# Define a point-cloud plot-item
pl_points = GLPointCloudPlotItem.GLPointCloudPlotItem(points=points, colors=colors, point_size=8)
glwidget.addItem(pl_points)

# Define a line plot-item for the curve
curve = np.column_stack([zxcurve[:,1], np.zeros(numrings), zxcurve[:,0] ])
pl_curve = gl.GLLinePlotItem(pos=curve, color=(1.0,1.0,1.0,0.5))
glwidget.addItem(pl_curve)

# Global animation auxiliary variables
white = np.array([1.0, 1.0, 1.0])
black = np.array([0.0, 0.0, 0.0])
oldcol = black

# Define the animation function
def check_pick_and_model():
    """ Deform a vase pointcloud by piching the rings
    
      When a new color is picked (glwidget.picked_color change its value) we:
      1) find the ring R with the picked color (linear search);
      2) change the shape of the neighbors rings so that we pinch-in the ring
      
      Optional exercise: make the vase rotate and stabilize the view angle!
      
      Note: this is a dirty animation script with poor design
    
    """
    global glwidget, pointcloud
    global points, zxcurve, colors, numpoints, numtheta
    global epsilon, white, black
    global oldcol
    
    col = glwidget.picked_color
    
    new_valid_color = col <> None and oldcol <> None and np.linalg.norm(col-oldcol) > epsilon 
    
    if new_valid_color: 
        
        not_black = np.linalg.norm(col-black) > epsilon
        not_white = np.linalg.norm(col-white) > epsilon
        
        if not_black and not_white:
        
            # Search the ring with that color
            index = None
            for i in xrange(ring_colors.shape[0]):
                if np.linalg.norm(ring_colors[i]-col) < epsilon:
                    index = i
                    break
            
            # Pinch in the vase
            if index <> None:
                lf.zxcurve_pinch_in(zxcurve, index)
                points = lf.surface_of_revolution(zxcurve, numtheta)
                pl_points.setData(points=points)
            
            glwidget.picked_color = None
            oldcol = black
        

# Define a new timer and connect the animation to it
timer = QtCore.QTimer()
timer.timeout.connect(check_pick_and_model)
timer.start(30)

# Execute the application
print "Right click on a ring to deform the vase..."
QtGui.QApplication.instance().exec_()