#-------------------------------------------------------------------------------
# Name:        module5
# Purpose:
#
# Author:      tad
#
# Created:     28/11/2013
# Copyright:   (c) tad 2013
# Licence:     <your licence>
#-------------------------------------------------------------------------------

import cv2
import numpy as np   ##cv2.imresize ;img1=cv2.imread(imgName);size=img1.shape[:2]
import sys

img1= cv2.imread('centralpark_1.jpg')
size=img1.shape[:2]
newSize=(int(size[1]/2),int(size[0]/2))
img1=cv2.resize(img1,newSize)
#img1=cv2.resize(img1,(size[1],size[0]))
detector = cv2.SIFT(nfeatures=0,nOctaveLayers=3,contrastThreshold =0.03,edgeThreshold=10,sigma=1.6)
kp1,desc1 = detector.detectAndCompute (img1,None )

img2= cv2.imread('centralpark_2.jpg')
size=img2.shape[:2]
newSize=(int(size[1]/2),int(size[0]/2))
img1=cv2.resize(img2,newSize)
detector = cv2.SIFT(nfeatures=0,nOctaveLayers=3,contrastThreshold =0.03,edgeThreshold=10,sigma=1.6)
kp2,desc2 = detector.detectAndCompute (img2,None )

FLANN_INDEX_KDTREE = 1 # opencv bug : f l ann enums ar e mi s s ing
norm = cv2.NORML2 # with d i f f e r e n t norms parameter s may change
flann_params = dict( algorithm =FLANN_INDEX_KDTREE, trees = 5)
matcher = cv2.FlannBasedMatcher( flann_params , {})
raw_matches = matcher.knnMatch ( desc1 , trainDescriptors = desc2 , k = 2)
p1,p2,kp_pairs = filter_matches ( kp1,kp2,raw_matches )
# define filter

skp_final = []
for i, dis in itertools.izip(idx, dist):
    if dis < distance:
        skp_final.append(skp[i])
    else:
        break

for m in raw_matches :
 if len(m) == 2 and m[0].distance< m[1].distance*ratio :
    if len(p1) >= 4 :
H,status = cv2.findHomography ( p1,p2,method = cv2 .RANSAC, ransacReprojThreshold = 5.0 )


