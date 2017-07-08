""" GLPointCloudPlotItem.py - extension of pyqtgraph for plotting pointclouds

  This file implements an extension of pyqtgraph for visualizing PointClouds.

  Last update: 04/10/2013, Marco Centin (marco.centin@gmail.com)

"""

from OpenGL.GL import *
from pyqtgraph.opengl.GLGraphicsItem import GLGraphicsItem

__all__ = ['GLPointCloudPlotItem']

class GLPointCloudPlotItem(GLGraphicsItem):
    
    """ Plotting a 3D point cloud using pyqtgraph

      Parameters:
      points     =  a numpy array with shape [n,3] with the 3D-point coordinates
      color      =  a solid floating point (r,g,b,a), a is the alpha component
      colors     =  an array of (r,g,b,a) colors with the same size of points
      point_size =  the dimension of each point in the visualization (in pixels)

    """

    def __init__(self, **kwds):
        
        GLGraphicsItem.__init__(self)
        glopts = kwds.pop('glOptions', 'opaque')
        self.setGLOptions(glopts)
        self.points = None
        self.colors = None
        self.width = 1.
        self.color = (1.0,1.0,1.0,1.0)
        self.setData(**kwds)

    def setData(self, **kwds):
        
        """ Update the data displayed by this item """
        
        args = ['points', 'color', 'colors', 'point_size' ]
        for k in kwds.keys():
            if k not in args:
                raise Exception('Invalid keyword argument: %s (allowed: %s)'%(k, str(args)))
                
        for arg in args:
            if arg in kwds:
                setattr(self, arg, kwds[arg])
                
        self.update()

    def initializeGL(self):
        pass

    def paint(self):
        
        """ Paint the pointcloud """
        
        if self.points is None: return
            
        self.setupGLState()
        
        try:
            
            # Set the color state
            if self.colors is None:
                glColor4f(*self.color)
            else:
                glEnableClientState(GL_COLOR_ARRAY)
                glColorPointerf( self.colors )  
            
            glPointSize(self.point_size)
            
            # Draw an array of points            
            glEnableClientState(GL_VERTEX_ARRAY)
            glVertexPointerf(self.points)            
            glDrawArrays(GL_POINTS, 0, self.points.size/self.points.shape[-1])
            
        finally:
            
            glDisableClientState(GL_VERTEX_ARRAY)
            
            if not self.colors is None:
                glDisableClientState(GL_COLOR_ARRAY)
        
