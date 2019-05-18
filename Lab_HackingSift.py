#-------------------------------------------------------------------------------
# REMOTE SENSING LAB
# Hacking Sift
#-------------------------------------------------------------------------------

import cv2
import numpy as np
from lab_functions import filter_matches
from lab_functions import images_blending
#from lab_functions import explore_match

img1 = cv2.imread('rockfeller_1.jpg')
size = img1.shape[:2]
img1 = cv2.resize(img1,(int(size[1]/4),int(size[0]/4)))

img2 = cv2.imread('rockfeller_2.jpg')
size = img2.shape[:2]
img2 = cv2.resize(img2,(int(size[1]/4),int(size[0]/4)))

detector = cv2.SIFT(nfeatures=0, nOctaveLayers=3, contrastThreshold=0.03, edgeThreshold=10, sigma=1.6)
kp1, desc1 = detector.detectAndCompute(img1, None)
kp2, desc2 = detector.detectAndCompute(img2, None)
FLANN_INDEX_KDTREE = 1
norm = cv2.NORM_L2
flann_params = dict(algorithm = FLANN_INDEX_KDTREE, trees = 5)
matcher = cv2.FlannBasedMatcher(flann_params, {})
raw_matches = matcher.knnMatch(desc1, trainDescriptors = desc2, k=2)
p1, p2, kp_pairs = filter_matches(kp1, kp2, raw_matches)

if len(p1) >= 4:
    H, status = cv2.findHomography(np.array(p2), np.array(p1), method = cv2.RANSAC, ransacReprojThreshold = 5.0)

[panorama_image, panorama1, panorama2]= images_blending(img1, img2, 4272/2, 2848/4, H, 200)

pan1 = cv2.imwrite('panorama1.jpg',panorama1)
pan2 = cv2.imwrite('panorama2.jpg',panorama2)
panorama = cv2.imwrite('panorama.jpg',panorama_image)

#v=explore_match(img1, img2, kp_pairs, status = None, H = None)