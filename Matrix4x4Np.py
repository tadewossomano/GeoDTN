""" Matrix4x4Np - A simple interface from QtGui::Matrix4x4 to NumPy

  This file contains a class which extends the QMatrix4x4 for a better NumPy integration

"""
import numpy as np
from pyqtgraph.Qt import QtGui

class Matrix4x4Np(QtGui.QMatrix4x4):
    
    def __repr__( self ):
        
        """ Defines how an object of this type is print into the console """
        
        l1 = "Matrix4x4Np transformation object:"
        l2 = " [[ %9.6f, %9.6f, %9.6f, %9.6f ],"%(self[0,0], self[0,1], self[0,2], self[0,3])
        l3 = "  [ %9.6f, %9.6f, %9.6f, %9.6f ],"%(self[1,0], self[1,1], self[1,2], self[1,3])
        l4 = "  [ %9.6f, %9.6f, %9.6f, %9.6f ],"%(self[2,0], self[2,1], self[2,2], self[2,3])
        l5 = "  [ %9.6f, %9.6f, %9.6f, %9.6f ]]"%(self[3,0], self[3,1], self[3,2], self[3,3])
        return "%s\n%s\n%s\n%s\n%s\n"%(l1, l2, l3, l4, l5)
        
    def np_matrix( self ):
        
        """ Return the 4x4 numpy matrix correspondg to the transformation """        
        
        M = np.array([
            [ self[0,0], self[0,1], self[0,2], self[0,3] ],
            [ self[1,0], self[1,1], self[1,2], self[1,3] ],
            [ self[2,0], self[2,1], self[2,2], self[2,3] ],
            [ self[3,0], self[3,1], self[3,2], self[3,3] ]
            ])
        return M
        
    def np_scale( self, scale ):
        
        """ Compose the current transformation with a scale transformation
        
          Arguments:
            scale =  a vector of three float numbers: the scale factors in X, Y, Z direction
                     if a single floating point is given, then scale uniformly on all axis
        
        """
        scale = np.array(scale).reshape(-1)
        if scale.shape[0] == 3:
            self.scale(QtGui.QVector3D(scale[0], scale[1], scale[2]))
        elif scale.shape[0] == 1:
            self.scale(QtGui.QVector3D(scale[0], scale[0], scale[0]))
        
    def np_rotate( self, angle, axis ):
        
        """ Compose the current transformation with a rotation of angle around the axis
        
          Arguments:
            angle =  a float number with the degrees of rotation (anti-clock orientation)
            axis  =  a vector of three float coordinates: the axis of rotation
        
        """

        self.rotate(angle, QtGui.QVector3D(axis[0], axis[1], axis[2]))
    
    def np_translate( self, vector ):
        
        """ Compose the current transformation with a translaton of the given numpy vector
        
          Arguments:
            vector = a vector with three float coordinates: the translation vector
          
        """

        self.translate(QtGui.QVector3D(vector[0], vector[1], vector[2]))
        
    def np_apply( self, points ):
        
        """ Apply the given transformation to some points (a numpy vector of shape [n,3]) """
        
        for i in xrange(points.shape[0]):
            q = self.map( QtGui.QVector3D(*points[i]) )
            points[i,0], points[i,1], points[i,2] = q.x(), q.y(), q.z()
            

            