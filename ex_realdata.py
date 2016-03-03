import numpy as np
import pyjlinkage as jl
import ex_labfunctions as lf

filename = "carterpart.xyz"
points = lf.load_xyz(filename)

assert not points is None
print points.shape

print "Visualizing the points..."
lf.preview_points(points)

seg = jl.JLSegmenter()
print "Adding points..."

seg.add_points(points)

print "Running J-Linkage..."
seg.run()
labels = seg.get_labels()

print "We have %d different clusters!"%seg.num_labels()

print "Saving labels..."
outfilename = "result.lab"
with open(outfilename, "w") as f:
    for i in xrange(len(labels)):
        f.write("%d\n"%labels[i])        
print "Complete!"
        
print "Visualizing the clusters..."
palette, _ = lf.color_map_array(seg.num_labels(), shuffle=True)
print palette.shape
colors = np.empty([points.shape[0],3])
for i in xrange(colors.shape[0]):
    colors[i] = palette[labels[i]]
lf.preview_points(points, colors)