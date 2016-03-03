""" pyjlinkage.py - A python interface for the J-Linkage library

  This defines a wrapper interface to the J-Linkage class. At the moment it can do only
  planar segmentations and it has many problems (the points are copied multiple times).
  
  Last update: 04/11/2013, Marco Centin (marco.centin@gmail.com)

"""

import ctypes as ct

_LibPyJLinkage = ct.cdll.LoadLibrary('PyJLinkage')

class JLSegmenter(object):
    
    def __init__(self):
        
        """ JLSegmenter object - clusterize points according to a given model

          This class is an interface for the J-Linkage method developed by Andrea Fusiello and
          Roberto Toldo. Here some online references, where you can download the original code:
           * http://www.3dflow.net/technology/jlinkage-multiple-models-fitting/
           * http://www.diegm.uniud.it/fusiello/demo/jlk/
          The method is well described in this paper:
           * 2008 - Fusiello, Toldo - Robust Multiple Structures Estimation with JLinkage
          
          Example:
          
            >>> import numpy as np
            >>> import pyjlinkage as jl
            >>> num = 5
            >>> index = 0
            >>> points = np.empty([num*num*2,3])
            >>> start, end = -5.0, 5.0
            >>> step = (end-start)/num
            >>> for i in xrange(num):
            ...     for j in xrange(num):
            ...         points[index] = np.array([ start+i*step, start+j*step, 0 ])
            ...         index += 1
            ... 
            >>> for i in xrange(num):
            ...     for j in xrange(num):
            ...         points[index] = np.array([ 0, start+i*step,  start+j*step ])
            ...         index += 1
            ... 
            >>> seg = jl.JLSegmenter()
            >>> seg.add_points(points)
            >>> seg.run()
            >>> labels = seg.get_labels()
            >>> labels
              [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
                1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1  ]
        
        """

        # Create an instance of JLSegmenter
        self._obj = _LibPyJLinkage.JLSegmenter_new()
        
        # Set ctypes return values
        _LibPyJLinkage.JLSegmenter_labelAt.restype = ct.c_int
        _LibPyJLinkage.JLSegmenter_sizePoints.restype = ct.c_size_t
        _LibPyJLinkage.JLSegmenter_sizeModels.restype = ct.c_size_t
        _LibPyJLinkage.JLSegmenter_sizeLabels.restype = ct.c_size_t
        _LibPyJLinkage.JLSegmenter_numLabels.restype = ct.c_int
        _LibPyJLinkage.JLSegmenter_getParamDimension.restype = ct.c_size_t
        _LibPyJLinkage.JLSegmenter_getParamModelFunction.restype = ct.c_size_t
        _LibPyJLinkage.JLSegmenter_getParamDistanceFunction.restype = ct.c_size_t
        _LibPyJLinkage.JLSegmenter_getParamNumMinimumSampleSet.restype = ct.c_size_t
        _LibPyJLinkage.JLSegmenter_getParamNumberOfSamples.restype = ct.c_size_t
        _LibPyJLinkage.JLSegmenter_getParamSamplingType.restype = ct.c_size_t
        _LibPyJLinkage.JLSegmenter_getParamKnnRange.restype = ct.c_size_t
        _LibPyJLinkage.JLSegmenter_getParamKnnCloseProb.restype = ct.c_double
        _LibPyJLinkage.JLSegmenter_getParamKnnFarProb.restype = ct.c_double
        _LibPyJLinkage.JLSegmenter_getParamSigmaExp.restype = ct.c_double
        _LibPyJLinkage.JLSegmenter_getParamInlierThreshold.restype = ct.c_double
        
        # Set default parameters
        self.set_parameters(
            dimension=3,
            getModelFunction=0,
            getDistanceFunction=0,
            numMinimumSampleSet=3,
            numberOfSamples=8000,
            samplingType=2,
            knnRange=10,
            knnCloseProb=0.8,
            knnFarProb=0.2,
            sigmaExp=1.0,
            inlierThreshold=0.1 )
        
    def __exit__(self, type, value, traceback):
        
        """ Perform cleaning on exit """

        self.erase()

    def __repr__(self):
        
        """ Defines how an object of this type is print in the console """
        
        s  = "JLSegmenter object:\n"
        s += "* point vector size = %d\n"%self.size_points()
        s += "* model vector size = %d\n"%self.size_models()
        s += "* label vector size = %d\n"%self.size_labels()
        s += "* number of labels  = %d\n"%self.num_labels()
        s += "Parameters:\n"
        params = self.get_parameters()
        for key in params.keys():
            s += "- %s = %s\n"%(key, str(params[key]))
        
        return s
        
    def get_parameters(self):
        
        """ Return the list of parameters

           This method reads the options directly from the C++ object, so one can control the
           final result after a parameter set call.
           
           Example:
           
            >>> import pyjlinkage as jl
            >>> seg = jl.JLSegmenter()
            >>> seg.get_parameters()
            {'knnFarProb': 0.2, 'sigmaExp': 1.0, 'getModelFunction': 0, 'knnCloseProb': 0.8,
            'numberOfSamples': 8000, 'samplingType': 2, 'inlierThreshold': 0.1,
            'numMinimumSampleSet': 3, 'knnRange': 10, 'dimension': 3, 'getDistanceFunction': 0}
        
        """
        
        # Get the parameters from the JLSegmenter
        dimension = int(_LibPyJLinkage.JLSegmenter_getParamDimension(self._obj))
        getModelFunction = int(_LibPyJLinkage.JLSegmenter_getParamModelFunction(self._obj))
        getDistanceFunction = int(_LibPyJLinkage.JLSegmenter_getParamDistanceFunction(self._obj))
        numMinimumSampleSet = int(_LibPyJLinkage.JLSegmenter_getParamNumMinimumSampleSet(self._obj))
        numberOfSamples = int(_LibPyJLinkage.JLSegmenter_getParamNumberOfSamples(self._obj))
        samplingType = int(_LibPyJLinkage.JLSegmenter_getParamSamplingType(self._obj))
        knnRange = int(_LibPyJLinkage.JLSegmenter_getParamKnnRange(self._obj))
        knnCloseProb = float(_LibPyJLinkage.JLSegmenter_getParamKnnCloseProb(self._obj))
        knnFarProb = float(_LibPyJLinkage.JLSegmenter_getParamKnnFarProb(self._obj))
        sigmaExp = float(_LibPyJLinkage.JLSegmenter_getParamSigmaExp(self._obj))
        inlierThreshold = float(_LibPyJLinkage.JLSegmenter_getParamInlierThreshold(self._obj))
        
        # Read the actual values
        params = {}
        params[self._parnames[0]] = dimension
        params[self._parnames[1]] = getModelFunction
        params[self._parnames[2]] = getDistanceFunction
        params[self._parnames[3]] = numMinimumSampleSet
        params[self._parnames[4]] = numberOfSamples
        params[self._parnames[5]] = samplingType
        params[self._parnames[6]] = knnRange
        params[self._parnames[7]] = knnCloseProb
        params[self._parnames[8]] = knnFarProb
        params[self._parnames[9]] = sigmaExp
        params[self._parnames[10]] = inlierThreshold
        return params
        
    def set_parameters(self, **kwds):
        
        """ Set one or more parameters through their keyword
        
          Usage:
          
            import pyjlinkage as jl
            seg = jl.JLSegmenter()
            seg.set_parameters(
                numberOfSamples=8000,
                samplingType=2,
                knnRange=10,
                knnCloseProb=0.8,
                knnFarProb=0.2,
                sigmaExp=1.0,
                inlierThreshold=0.1 )
        
          Description:
          
            There are many parameters to set, but basically we have 3 things
          
            (1) One have to specify the dimension of the points and the models used inside
                J-Linkage. At the moment there is no choice: you can segment only 3d-planes:
                - dimension            =  3 (our points have 3 coordinates)
                - numMinimumSampleSet  =  3 (a plane is described by 3 points)
                - getModelFunction     =  0 (select the points2planeparams function)
                - getDistanceFunction  =  0 (select the point2plane-distance function)
                Any different configuration of these parameter will produce only errors!
              
            (2) Then we need to specify the parameters used in the "RandomSampler". This is
                the part of J-Linkage which sample a bunch of minimal sample set (3 points) and
                computes a bunch of candidate models. When sampling the points the closest are
                sampled with higher probability (with exponential distribution):
                - samplingType =  (int) the type of sampling (0=EXP, 1=NN, 2=NN_ME, 3=UNIFORM)
                                  [how to sample the models, exponential?, nearest-neighbor?]
                - knnRange     =  (int) the number of neighbors used (in case of NN)
                - knnCloseProb =  (float) the probability of the closest point
                - knnFarProb   =  (float) the probability of the farthest point
                - sigmaExp     =  (float) the value of sigma in the exponential distribution
              
            (3) Finally the J-Linkage do an agglomerative clustering of the points. This
                parameter is quite important and determine the threshold level for the clustering:
                - inlierThreshold = (float) the value of the inlier threshold

          Implementation note:
          
            This is really not elegant, but what we have to do is to dispatch the keywords
            and invoke the different parameter-setters call in the DLL. It is easy to add
            options or modify the names if we keep the list of the setters separated from the
            names of the parameters. I should also add more controls on the values.
        
        """
        
        self._parnames = [
                'dimension', #0
                'getModelFunction', #1
                'getDistanceFunction', #2
                'numMinimumSampleSet', #3
                'numberOfSamples', #4
                'samplingType', #5
                'knnRange', #6
                'knnCloseProb', #7
                'knnFarProb', #8
                'sigmaExp', #9
                'inlierThreshold' ] #10
        
        for k in kwds.keys():
            if k not in self._parnames:
                raise Exception('Invalid parameter name: %s (allowed: %s)'%(k,str(self._parnames)))
        
        key = self._parnames[0]
        if key in kwds:
            value = int(kwds[key])
            _LibPyJLinkage.JLSegmenter_setParamDimension(self._obj, ct.c_size_t(value))
            
        key = self._parnames[1]
        if key in kwds:
            value = int(kwds[key])
            _LibPyJLinkage.JLSegmenter_setParamModelFunction(self._obj, ct.c_size_t(value))
        
        key = self._parnames[2]
        if key in kwds:
            value = int(kwds[key])
            _LibPyJLinkage.JLSegmenter_setParamDistanceFunction(self._obj, ct.c_size_t(value))
            
        key = self._parnames[3]
        if key in kwds:
            value = int(kwds[key])
            _LibPyJLinkage.JLSegmenter_setParamNumMinimumSampleSet(self._obj, ct.c_size_t(value))
            
        key = self._parnames[4]
        if key in kwds:
            value = int(kwds[key])
            _LibPyJLinkage.JLSegmenter_setParamNumberOfSamples(self._obj, ct.c_size_t(value))
            
        key = self._parnames[5]
        if key in kwds:
            value = int(kwds[key])
            _LibPyJLinkage.JLSegmenter_setParamSamplingType(self._obj, ct.c_size_t(value))
            
        key = self._parnames[6]
        if key in kwds:
            value = int(kwds[key])
            _LibPyJLinkage.JLSegmenter_setParamKnnRange(self._obj, ct.c_size_t(value))
            
        key = self._parnames[7]
        if key in kwds:
            value = float(kwds[key])
            _LibPyJLinkage.JLSegmenter_setParamKnnCloseProb(self._obj, ct.c_double(value))
            
        key = self._parnames[8]
        if key in kwds:
            value = float(kwds[key])
            _LibPyJLinkage.JLSegmenter_setParamKnnFarProb(self._obj, ct.c_double(value))
            
        key = self._parnames[9]
        if key in kwds:
            value = float(kwds[key])
            _LibPyJLinkage.JLSegmenter_setParamSigmaExp(self._obj, ct.c_double(value))
            
        key = self._parnames[10]
        if key in kwds:
            value = float(kwds[key])
            _LibPyJLinkage.JLSegmenter_setParamInlierThreshold(self._obj, ct.c_double(value))
        
    def erase(self):
        
        """ Erase the data in this object and free memory """
        
        _LibPyJLinkage.JLSegmenter_erase(self._obj)
        
    def reserve(self, n):
        
        """ Reserve space for the points """
        
        n = int(n)
        _LibPyJLinkage.JLSegmenter_reserve(self._obj, ct.c_int(n))
        
    def add_points(self, points):
        
        """ Add the points to the segmenter, requires a numpy array """
        
        shape = points.shape  
        for i in xrange(shape[0]):
            self.add_point(points[i])
        
    def add_point(self, point):
        
        """ Add a point to the segmenter """
        
        n = len(point)
        
        if n == 2:
            _LibPyJLinkage.JLSegmenter_addPoint2d(
                self._obj,
                ct.c_float(point[0]),
                ct.c_float(point[1]) )
            return
            
        if n == 3:
            _LibPyJLinkage.JLSegmenter_addPoint3d(
                self._obj,
                ct.c_float(point[0]),
                ct.c_float(point[1]),
                ct.c_float(point[2]) )
            return
            
    def size_points(self):
        
        """ Return the number of points loaded in this object """
        
        return int(_LibPyJLinkage.JLSegmenter_sizePoints(self._obj))
        
    def size_models(self):
        
        """ Return the number of models loaded in this object """
        
        return int(_LibPyJLinkage.JLSegmenter_sizeModels(self._obj))
        
    def size_labels(self):
        
        """ Return the number of labels loaded in this object """
        
        return int(_LibPyJLinkage.JLSegmenter_sizeLabels(self._obj))
        
    def num_labels(self):
        
        """ Return the number of different labels """
        
        return int(_LibPyJLinkage.JLSegmenter_numLabels(self._obj))
            
    def get_labels(self):
        
        label_at = lambda i : int(_LibPyJLinkage.JLSegmenter_labelAt(self._obj, ct.c_int(i)))
        return [ label_at(i) for i in xrange(self.size_labels()) ]

    def run(self):
        
        """ Run the J-Linkage segmentation """
        
        _LibPyJLinkage.JLSegmenter_run(self._obj)
