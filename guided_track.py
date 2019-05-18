import numpy as np

#### NDARRAY CREATION ####
print "Create a 1D ndarray:"
a = np.array([0, 1, 2, 3])
print "a = %(a)s.\n" % {"a":a}

raw_input("Press enter key...")

### NDARRAY NUMBER OF DIMENSIONS AND SHAPE ###
print "Access to the ndim and shape attributes of a ndarray:"
print "a.ndim = %(ndim)s" % { "ndim" : a.ndim }
print "a.shape = %(shape)s" % { "shape" : a.shape }
print "len(a) = %(len)s.\n" % { "len" : len(a) } #len return the length of the first dimension

raw_input("Press enter key...")

### 2D NDARRAY ###
print "Creating a 2D ndarray:"
b = np.array([[0, 1, 2], [3, 4, 5]])    # 2 x 3 array
print "b = %(b)s" % {"b":b}
print "b.ndim = %(ndim)s" % {"ndim":b.ndim}
print "b.shape = %(shape)s" % {"shape":b.shape}
print "len(b) = %(len)s.\n" % {"len":len(b)}

raw_input("Press enter key...")

### 3D NDARRAY ###
print "Creating a 3D ndarray:"
c = np.array([[[1], [2]], [[3], [4]]])    # 2 x 2 x 1 array
print "c = %(c)s" % {"c":c}
print "c.ndim = %(ndim)s" % {"ndim":c.ndim}
print "c.shape = %(shape)s" % {"shape":c.shape}
print "len(c) = %(len)s.\n" % {"len":len(c)}

raw_input("Press enter key...")

### NDARRAY WITH np.arange ### 
print "Construct a ndarray with np.arange:"
a = np.arange(10)
print "np.arange(10) = %(a)s.\n" % {"a":a}

raw_input("Press enter key...")

### NDARRAY WITH np.arange WITH MORE PARAMETERS ###
print "Use np.arange with more parameters:"
b = np.arange(1,9,2) # start = 1 ; end = 9 ; step = 2
print "np.arange(1,9,2) = %(b)s.\n" % {"b":b}

raw_input("Press enter key...")

### NDARRAY WITH np.linspace ###
print "Construct a ndarray with np.linspace:"
a = np.linspace(0,1,6) # start = 0 ; end = 1 ; number of points in between = 6
print "np.linspace(0,1,6) = %(linspace)s" % {"linspace":a}
print " ... and if you want to omit the endpoint in the sequence:"
b = np.linspace(0,1,6,endpoint=False)
print "np.linspace(0,1,6,endpoint=False) = %(linspace)s.\n" % {"linspace":b}

raw_input("Press enter key...")

### NDARRAY WITH np.zeros ###
print "Construct a ndarray with np.zeros:"
a = np.zeros( (3,3) )  #the size of the zeros array is specified with a tuple
print "np.zeros( (3,3) ) = %(zeros)s.\n" % {"zeros":a}

raw_input("Press enter key...")

### NDARRAY WITH np.ones ###
print "Construct a ndarray with np.ones:"
b = np.ones( (3,3) )  #the size of the ones array is specified with a tuple
print "np.ones( (3,3) ) = %(ones)s.\n" % {"ones":b}

raw_input("Press enter key...")

### NDARRAY WITH np.eye ###
print "Construct a ndarray with np.eye:"
c = np.eye(3)  #the number of ones in the diagonal in the identity matrix is specified as a parameter
print "np.eye(3) = %(eye)s.\n" % {"eye":c}

raw_input("Press enter key...")

### NDARRAY WITH np.diag ###
print "Construct a ndarray with np.diag:"
d = np.diag([1,2,3,4]) #the items in the diagonal are specified as a list
print "np.diag([1,2,3,4]) = %(diag)s.\n" % {"diag":d}

raw_input("Press enter key...")

### INITIALIZE THE PSEUDO RANDOM NUMBER GENERATOR WITH np.random.seed ###
print "Initialize the pseudo random number generator with np.random.seed ...\n"
np.random.seed()

raw_input("Press enter key...")

### RANDOM NDARRAY WITH np.random.rand ###
print "Construct a ndarray with np.rand:"
a = np.random.rand(4) #vector of 4 items chosen according to a U[0,1] prob. distribution
print "np.random.rand(4) = %(rand)s.\n" % {"rand":a}

raw_input("Press enter key...")

### RANDOM NDARRAY WITH np.random.randn ###
print "Construct a ndarray with np.random.randn:"
b = np.random.randn(4) #vector of 4 items chosen according to gaussian dist., mean = 0, sigma = 1
print "np.random.randn(4) = %(randn)s.\n" % {"randn":b}

raw_input("Press enter key...")

### dtype ATTRIBUTE IN ndarray ###
print "Check the type of the items by means of dtype attribute:"
a = np.array([0,1,2,3])
print "a.dtype of a = np.array([0,1,2,3]) is %(dtype)s." % {"dtype":a.dtype}
b = np.array([0.,1.,2.,3.])
print "b.dtype of b = np.array([0.,1.,2.,3.]) is %(dtype)s." % {"dtype":b.dtype}
print "You can also explicitely specify the type of the array that you are creating:"
c = np.array([0,1,2,3],dtype=float)
print "c.dtype of c = np.array([0,1,2,3],dtype=float) is %(dtype)s." % {"dtype":c.dtype}
print "The default data type is float:"
d = np.ones((3,3))
print "d.dtype of d = np.ones((3,3)) is %(dtype)s." % {"dtype":d.dtype}
print "Following some other types:"
e = np.array([1+2j, 3+4j, 5+6*1j])
print "e.dtype of e = np.array([1+2j, 3+4j, 5+6*1j]) is %(dtype)s." % {"dtype":e.dtype}
f = np.array([True, False, False, True])
print "f.dtype of f = np.array([True, False, False, True]) is %(dtype)s." % {"dtype":f.dtype}
g = np.array(['Bonjour', 'Hello', 'Hallo',])
print "g.dtype of g = np.array(['Bonjour', 'Hello', 'Hallo',]) is %(dtype)s." % {"dtype":g.dtype}
print "It is a string of maximum 7 characters!"
print "Some others useful types are int8, int16, int32, int64, uint8, uint16, uint32, uint34, float32 and many others. uint8 and float32 are especially useful if you use OpenCV library python bindings.\n"

raw_input("Press enter key...")

### IMPORT THE MATPLOTLIB MODULE ###
import matplotlib.pyplot as plt  # the tidy way

print "Basic usage of matplotlib for 1D plotting...\n"

### POPULATE THE X AND Y ARRAY FOR PLOTTING THE GRAPH ###
x = np.linspace(0, 3, 20)
y = np.linspace(0, 9, 20)

### 1D LINE PLOT OF THE GRAPH ###
plt.plot(x, y)       # line plot 
plt.show()           # <-- shows the plot

### 1D POINTS PLOT OF THE GRAPH ###
plt.plot(x, y, 'o')  # dot plot
plt.show()           # <-- shows the plot

### 2D PLOT ###
print "Basic usage of matplotlib for 2D plotting...\n"
image = np.random.rand(30, 30)
plt.imshow(image, cmap=plt.cm.hot)  
plt.colorbar()
plt.show()

### INDEXING OF NUMPY ARRAYS ###
print "Indexing of numpy array's items:"
a = np.arange(10)
a_items = (a[0], a[3], a[-1]) #the index equals to -1 points to the last item
print "(a[0], a[3], a[-1]) = %(tuple)s where a = %(arange)s.\n" % {"tuple":a_items,"arange":a}

raw_input("Press enter key...")

### INDEXING OF NUMPY ARRAYS ###
print "Indexing of numpy array's items:"
a = np.arange(10)
a_items = (a[0], a[3], a[-1]) #the index equals to -1 points to the last item
print "(a[0], a[3], a[-1]) = %(tuple)s where a = %(arange)s.\n" % {"tuple":a_items,"arange":a}

raw_input("Press enter key...")

### MULTIMENSIONAL INDEXING OF NUMPY ARRAYS ###
print "Multidimensional indexing of numpy array's items:"
a = np.diag(np.arange(3))
print "a[1, 1] = %(a11)s where a = %(a)s" % {"a11":a[1,1],"a":a}
print "Assigning of multidimensional numpy arrays:"
a[2,1]=10
print "if a[2,1] is assigned equal to 10, where a was %(a)s, then a = %(a_new)s.\n" % {"a":np.diag(np.arange(3)),"a_new":a}

raw_input("Press enter key...")

### SLICING OF NUMPY ARRAYS ###
print "Slicing of numpy arrays:"
a = np.arange(10)
a_sliced = a[2:9:3] # [start:end:step]
print "a[2:9:3] = %(a_sliced)s where a = %(a)s. The order of the indices used to slice the array is relatively [start:end:step]. If the step index is omitted, by default is equal to 1." % {"a_sliced":a_sliced,"a":a}
a_sliced_2 = a[:4] # [0:end:1]
print "a[:4] = %(a_sliced_2)s where a = %(a)s. The start index is missing, so the slicing start by default from the index 0. Also the step index is missing, so by default the step is 1." % {"a_sliced_2":a_sliced_2,"a":a}
a_sliced_3 = a[1:3]
print "a[1:3] = %(a_sliced_3)s where a = %(a)s. The step index is missing, so by default is missing." % {"a_sliced_3":a_sliced_3,"a":a}
a_sliced_4 = a[::2]
print "a[::2] = %(a_sliced_4)s where a = %(a)s. The start is set by default at the beginning of the vector, the end to the end of the vector, while the step is set to 2." % {"a_sliced_4":a_sliced_4,"a":a}
a_sliced_5 = a[3:]
print "a[3:] = %(a_sliced_5)s where a = %(a)s. In this case, the vector is sliced starting from the 4th item till its end, with step 1." % {"a_sliced_5":a_sliced_5,"a":a}
print "What about if you want to reverse the access order of the sequence?"
print "a[::-1] = %(a_reversed)s where a = %(a)s. The step index set to -1 reverse the accessing order of the sequence.\n" % {"a_reversed":a[::-1],"a":a}

print "How to combine slicing and assigning:"
a[5:]=10
print "a = %(a)s, if the assignement is performed a[5:]=10.\n" % {"a":a} 

raw_input("Press enter key...")

### COPIES VS VIEWS ###

print "Slicing does not copy the array, it just creates a view of the original array:"
a = np.arange(10)
b = a[::2]
print "a = np.arange(10) and b = a[::2]. Do they share memory? %(bool)s" % {"bool" : np.may_share_memory(a, b)}

print "Explicit copy of a numpy array:"
a = np.arange(10)
b = a[::2].copy()
print "a = np.arange(10) and b = a[::2].copy().Do they share memory? %(bool)s.\n" % {"bool" : np.may_share_memory(a, b) }

raw_input("Press enter key...")

### FANCY INDEXING ###

print "Fancy indexing:"
np.random.seed(3)
a = np.random.random_integers(0, 20, 15)
mask = (a % 3 == 0)
print "a = %(a)s" % {"a":a}
print "The mask contains whether the value of an item is multiple of 3 or not. mask = (a %% 3 == 0) = %(mask)s" % {"mask":mask}
print "a[mask] = %(a_masked)s.\n" % {"a_masked":a[mask]}

print "Fancy indexing with integers arrays:"
a = np.arange(0, 100, 10)
print "a = np.arange(0, 100, 10) and a[[2, 3, 2, 4, 2]] = %(a_indexed)s" % {"a_indexed" : a[[2, 3, 2, 4, 2]]}
