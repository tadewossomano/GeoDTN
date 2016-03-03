""" ex_labfunctions.py - a collection of auxiliary functions

  This file contains a list of useful functions for managing point coordinates.

"""
import numpy as np

def moebius_strip( nu=800, nv=100 ):

    """ Return a Moebius strip point cloud

      Return a numpy array with shape [nu*nv, 3] containing floating point coordinates
      of a Moebius strip. See also: http://en.wikipedia.org/wiki/Moebius_strip

      Optional arguments:
        nu = discretization of the u parameter (should be about 8*nv)
        nv = discretization of the v parameter

    """

    # Define the parameters range and step
    urange = [ 0.0, 2.0*np.pi ]
    vrange = [ -1.0, 1.0 ]
    ustep = (urange[1]-urange[0])/float(nu)
    vstep = (vrange[1]-vrange[0])/float(nv)

    # Loop on u and v and compute the strip
    i, u = 0, 0.0
    points = np.empty([nu*nv, 3])
    for _ in xrange(nu):
        v = vrange[0]
        for _ in xrange(nv):
            points[i,0] = ( 1.0+(v/2.0)*np.cos(u/2.0) ) * np.cos(u);
            points[i,1] = ( 1.0+(v/2.0)*np.cos(u/2.0) ) * np.sin(u);
            points[i,2] = (v/2.0) * np.sin(u/2.0);
            v += vstep
            i += 1
        u += ustep

    return points

def color_map_array( size, shuffle = False ):

    """ Return an array of different colors

      Given a size number returns an array of different floating point RGB colors and the
      minimum distance between two colors:

      Arguments:
        size = an integer: the size of the color array (size > 1)

      Parameters:
        shuffle = a boolean, tells if the function should shuffle the array

      Returns:
        colors  = a numpy array with shape [size,3] containing the colors
        epsilon = a distance which isolate two colors

    """

    assert size > 1

    # Compute how many steps for each channel
    k = int(size**(1/3.0)+1)
    numcols = k*k*k
    colors = np.empty([numcols, 3])

    # Set the channel range and the step
    colrange = [0.0001, 0.9999]
    colstep = (colrange[1]-colrange[0])/float(k)

    # Fill-in the colors
    i = 0
    for ir in xrange(k):
        for ig in xrange(k):
            for ib in xrange(k):
                colors[i,0] = ir*colstep
                colors[i,1] = ig*colstep
                colors[i,2] = ib*colstep
                i += 1

    # The first two have minimum distance!
    epsilon = 0.499999*np.linalg.norm(colors[0]-colors[1])
    if shuffle: np.random.shuffle(colors)

    return colors[0:size], epsilon

def vase_profile( numrings ):

    """ Return an array of 2D points defining the profile of a vase

      Arguments:
        numrings = an integer, the number of points of the curve

      Return:
        zxcurve = a numpy array of shape [numrings,2] with the (z,x) coordinates

    """

    z = np.linspace(0.0,2.0*np.pi, numrings)
    x = 2.0+np.cos(0.38*np.pi*(z+np.pi))
    return np.column_stack([z,x])

def surface_of_revolution( zxcurve, numtheta ):

    """ Return the pointcloud of the surface of revolution of the curve

      Return a numpy array with shape [zxcurve.shape[0]*ntheta, 3] containing floating point
      coordinates of the surface of revolution obtained by rotating the curve (seen as in
      the XZ-plane, that is, the curve alpha(t)=[ curve[t], 0, t ] ) along the Z axis.

      Arguments:
        xzcurve = a numpy array with shape [n,2] containing (x,0,z) coordinates
        ntheta  = discretization of the rotation (how many angles to span)

      Return:
        points = the 3D-points of the pointcloud

    """

    i = 0
    numcurve = zxcurve.shape[0]
    points = np.empty([zxcurve.shape[0]*numtheta, 3])
    for icurve in xrange(numcurve):
        for itheta in xrange(numtheta):
            theta=itheta*2.0*np.pi/numtheta
            z,x=zxcurve[icurve]
            points[i,0]=x*np.cos(theta)
            points[i,1]=x*np.sin(theta)
            points[i,2]=z
            i+=1


    return points

def zxcurve_pinch_in( zxcurve, i ):

    """ Pinch a point of a curve and lower its x coordinate

      Given a xzcurve and an index i, modify the neighbors of the point xzcurve[i] so that
      the corresponding rings will be smaller.

    """

    window = [ 0.99, 0.98, 0.97, 0.98, 0.99 ]
    #<<<
    #<<< Insert your code here!
    #<<<