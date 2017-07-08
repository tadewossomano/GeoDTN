""" ex_house.py - create a house pointcloud and recover the walls using J-Linkage

  In this exercise we sample many planes so that the shape of a house is formed. Then we
  apply a J-Linkage clusterization in order to do a planar segmentation of the pointcloud.

"""
import numpy as np
import pyjlinkage as jl
import ex_labfunctions as lf

numpoints = 300

floor = lf.sample_plane_portion(
    width = 2,
    height = 2,
    numpoints = numpoints,
    center = [0,0,0],
    normal = [0,0,1],
    rotation = 0,
    noise = [0.0001, 0.0001, 0.0001] )

wall1 = lf.sample_plane_portion(
    width = 2,
    height = 2,
    numpoints = numpoints,
    center = [-1,0,1],
    normal = [1,0,0],
    rotation = 0,
    noise = [0.0001, 0.0001, 0.0001] )

wall2 = lf.sample_plane_portion(
    width = 2,
    height = 2,
    numpoints = numpoints,
    center = [0,1,1],
    normal = [0,1,0],
    rotation = 0,
    noise = [0.0001, 0.0001, 0.0001] )

wall3 = lf.sample_plane_portion(
    width = 2,
    height = 2,
    numpoints = numpoints,
    center = [1,0,1],
    normal = [1,0,0],
    rotation = 0,
    noise = [0.0001, 0.0001, 0.0001] )

wall4 = lf.sample_plane_portion(
    width = 2,
    height = 2,
    numpoints = numpoints,
    center = [0,-1,1],
    normal = [0,1,0],
    rotation = 0,
    noise = [0.0001, 0.0001, 0.0001] )

roof1 = lf.sample_plane_portion(
    width = 2,
    height = 2,
    numpoints = numpoints,
    center = [0.7,0,2.2],
    normal = [-1,0,-1],
    rotation = 0,
    noise = [0.0001, 0.0001, 0.0001] )

roof2 = lf.sample_plane_portion(
    width = 2,
    height = 2,
    numpoints = numpoints,
    center = [-0.7,0,2.2],
    normal = [1,0,-1],
    rotation = 0,
    noise = [0.0001, 0.0001, 0.0001] )

points = np.vstack([floor, wall1, wall2, wall3, wall4, roof1, roof2])

print "Visualizing the points..."
lf.preview_points(points)

# <<<
# <<< Exercise: add code below [less than 22 lines]. You have to:
# <<< (1) define a J-Linkage segmenter and set its parameters...
# <<< (2) add the points...
# <<< (3) run the segmenter...
# <<< (4) get the point labels...
# <<< (5) visualize the pointcloud using a different color for each label
# <<<     (use lf.color_palette for defining the colors and then lf.preview_points)
# <<<
