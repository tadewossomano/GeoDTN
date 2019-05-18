""" ex_colmap.py - Function for defining a big array of different colors

  Exercise 2: define a function which returns an array of different colors, and a number
  epsilon which discriminates between two of them (using numpy.linalg.norm)

"""
import numpy as np

def color_map_array( size, shuffle = False ):

    """ Return an array of different colors

      Given a size number returns an array of different floating point RGB colors and the
      minimum distance between two colors. Pure white and pure black are avoided.

      Arguments/parameters:
        size = an integer: the size of the color array (size > 1)
        shuffle = a boolean, tells if the function should shuffle the array

      Returns:
        colors  = a numpy array with shape [size,3] containing the colors
        epsilon = a distance which isolate two colors

    """

    assert size > 1

    # Compute how many steps for each channel
    k = int(size**(1/3.0))+1 #** is the power function
    numcols = k*k*k
    colors = np.empty([numcols, 3])

    # Set the channel range and the step
    colrange = [0.0001, 0.9999] #from almost 0 to almost 1
    colstep = (colrange[1]-colrange[0])/float(k) #python don't have statyc types so i cannod divide by integers

    # Fill-in the colors
    i = 0
    for ir in xrange(k):
        for ig in xrange(k):
            for ib in xrange(k):
                colors[i,0] = colstep*ir
                colors[i,1] = colstep*ig
                colors[i,2] = colstep*ib
                i += 1

    # The first two have minimum distance!
    epsilon = 0.4999*np.linalg.norm(colors[0]-colors[1])
    if shuffle: np.random.shuffle(colors)

    return colors[0:size], epsilon  #we can return multiple values