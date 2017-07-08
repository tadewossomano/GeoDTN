""" ex_labfunctions.py - a collection of auxiliary functions

  This file contains a list of useful functions for managing point coordinates.

"""
import numpy as np
from Matrix4x4Np import Matrix4x4Np

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

    z = np.linspace(0.0, 2.0*np.pi, numrings)
    x = 2.0+np.cos(0.38*np.pi*(z+np.pi))
    zxcurve = np.column_stack([z,x])
    return zxcurve

def surface_of_revolution( zxcurve, numtheta ):

    """ Return the pointcloud of the surface of revolution of the curve

      Return a numpy array with shape [zxcurve.shape[0]*numtheta, 3] containing floating point
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
            theta = 2.0*np.pi*itheta/numtheta
            z, x = zxcurve[icurve]
            points[i,0] = x*np.cos(theta)
            points[i,1] = x*np.sin(theta)
            points[i,2] = z
            i += 1

    return points

def zxcurve_pinch_in( zxcurve, i ):

    """ Pinch a point of a curve and lower its x coordinate

      Given a xzcurve and an index i, modify the neighbors of the point xzcurve[i] so that
      the corresponding rings will be smaller.

    """
    window = [ 0.99, 0.98, 0.97, 0.98, 0.99 ]
    winsize = len(window)
    for j in xrange(winsize):
        index = i+j-winsize/2
        if index >= 0 and index < zxcurve.shape[0]:
            zxcurve[index,1] *= window[j]

def angle_between(v1, v2):

    """ Returns the angle in radians between vectors 'v1' and 'v2'

      >>> angle_between((1, 0, 0), (0, 1, 0))
      1.5707963267948966
      >>> angle_between((1, 0, 0), (1, 0, 0))
      0.0
      >>> angle_between((1, 0, 0), (-1, 0, 0))
      3.141592653589793
    """
    v1_u = v1/np.linalg.norm(v1)
    v2_u = v2/np.linalg.norm(v2)
    angle = np.arccos(np.dot(v1_u, v2_u))
    if np.isnan(angle):
        if (v1_u == v2_u).all():
            return 0.0
        else:
            return np.pi
    return angle

def xyrectangle_points( width, height, numpoints ):

    """ Sample some random points inside a given rectangle centered on the XY plane

      Arguments:
        width     =  a float number: the width of the rectangle
        height    =  a float: the height of the rectangle
        numpoints =  the number of points to sample

    """
    x = np.random.uniform(-width/2.0, width/2.0, numpoints)
    y = np.random.uniform(-height/2.0, height/2.0, numpoints)
    z = np.zeros(numpoints)
    return np.column_stack([x,y,z])

def sample_plane_portion(
        width     = 1.0,
        height    = 1.0,
        numpoints = 100,
        center    = [0.0, 0.0, 0.0],
        normal    = [0.0, 0.0, 1.0],
        rotation  = 0.0,
        noise     = None ):

    """ Sample points on a plane portion of given width and position in space

      Arguments:
        width     =  a float number, the width of the plane
        height    =  a float number, the height of the plane
        numpoints =  the number of sampled points
        center    =  the center of the resulting plane
        normal    =  the normal vector of the resulting plane
        rotation  =  the rotation angle of the rectangle in the plane, in degrees
        noise     =  a vector with 3 floats, the variance of some additional gaussian noise

    """

    # Some constants
    epsilon = 0.000001
    yaxis = np.array([0.0, 1.0, 0.0])
    zaxis = np.array([0.0, 0.0, 1.0])

    # Sample points on XY plane
    points = xyrectangle_points(width, height, numpoints)

    # Compute the axis of rotation
    normal = normal/np.linalg.norm(normal)
    nrot_axis = np.cross(normal, zaxis)
    nrot_norm = np.linalg.norm(nrot_axis)

    # Approximate solution in degenerate cases
    if nrot_norm < epsilon: nrot_axis = yaxis   #trick used in videogmes
    else: nrot_axis = nrot_axis/nrot_norm

    # Compute the angle of rotation
    nrot_angle = -angle_between(normal, zaxis) * (360.0/(2*np.pi))

    # Assemble the transformation matrix
    M = Matrix4x4Np()
    M.np_translate(center)
    M.np_rotate(rotation, normal)
    M.np_rotate(nrot_angle, nrot_axis)

    # Apply the transformation
    M.np_apply(points)

    # Eventually gaussian noise
    if not noise is None:
        mean = np.zeros(3)
        covariance_matrix = np.array([
            [ noise[0],   0.0,      0.0     ],
            [   0.0,    noise[1],   0.0     ],
            [   0.0,      0.0,    noise[2] ]])
        for i in xrange(points.shape[0]):
            points[i] += np.random.multivariate_normal(mean, covariance_matrix)

    return points
