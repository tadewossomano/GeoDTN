#-------------------------------------------------------------------------------
# REMOTE SENSING LAB
# Hacking Sift
# FUNCTIONS
#-------------------------------------------------------------------------------
import cv2
import numpy as np

def filter_matches(kp1, kp2, raw_matches):

    ratio = 0.8
    i=0
    new_kp1 = []
    new_kp2 = []
    new_kp_pairs = []

    for m in raw_matches:
        if len(m) == 2 and m[0].distance < m[1].distance*ratio:
            new_kp1.append(kp1[m[0].queryIdx].pt)
            new_kp2.append(kp2[m[0].trainIdx].pt)
            new_kp_pairs.append(raw_matches[i])
            i+=1
    return new_kp1, new_kp2, new_kp_pairs


def blending_mask(height, width, barrier, smoothing_window, left_biased=True):

    assert barrier < width
    mask = np.zeros((height, width))
    offset = int(smoothing_window/2)

    if left_biased:
        mask[:, barrier-offset:barrier+offset+1]=np.tile(np.linspace(1, 0, 2*offset+1).T, (height, 1))
        mask[:, :barrier-offset] = 1
    else:
        mask[:, barrier-offset:barrier+offset+1]=np.tile(np.linspace(0, 1, 2*offset+1).T, (height, 1))
        mask[:, barrier+offset:] = 1

    return cv2.merge([mask, mask, mask])


def images_blending(img1, img2, width_panorama, height_panorama, H, smoothing_window = 400):

    barrier = img1.shape[1]-int(smoothing_window/2)

    panorama1 = np.zeros((height_panorama, width_panorama, 3))
    mask1 = blending_mask(height_panorama, width_panorama, barrier, smoothing_window = smoothing_window, left_biased = True)
    panorama1[0:img1.shape[0], 0:img1.shape[1], :] = img1
    panorama1 *= mask1

    mask2 = blending_mask(height_panorama, width_panorama, barrier, smoothing_window = smoothing_window, left_biased = False)
    panorama2 = cv2.warpPerspective(img2, H, (width_panorama, height_panorama))*mask2

    return panorama1+panorama2, panorama1, panorama2


##def explore_match(img1, img2, kp_pairs, status = None, H = None):
##
##    h1, w1 = img1.shape[:2]
##    h2, w2 = img2.shape[:2]
##    vis = np.zeros((max(h1, h2), w1+w2), np.uint8)
##    vis[:h1, :w1] = img1
##    vis[:h2, w1:w1+w2] = img2
##    vis = cv2.cvtColor(vis, cv2.COLOR_GRAY2BGR)
##
##    if H is not None:
##        corners = np.float32([[0, 0], [w1, 0], [w1, h1], [0, h1]])
##        corners = np.int32(cv2.perspectiveTransform(corners.reshape(1, -1, 2), H).reshape(-1, 2) + (w1, 0))
##        cv2.polylines(vis, [corners], True, (255, 255, 255))
##
##    if status is None:
##        status = np.ones(len(kp_pairs), np.bool_)
##    p1 = np.int32([kpp[0].pt for kpp in kp_pairs])
##    p2 = np.int32([kpp[1].pt for kpp in kp_pairs]) + (w1, 0)
##
##    green = (0, 255, 0)
##    red = (0, 0, 255)
##    white = (255, 255, 255)
##    kp_color = (51, 103, 236)
##    for (x1, y1), (x2, y2), inlier in zip(p1, p2, status):
##        if inlier:
##            col = green
##            cv2.circle(vis, (x1, y1), 2, col, -1)
##            cv2.circle(vis, (x2, y2), 2, col, -1)
##        else:
##            col = red
##            r = 2
##            thickness = 3
##            cv2.line(vis, (xl-r, yl-r), (xl+r, yl+r), col, thickness)
##            cv2.line(vis, (xl-r, yl+r), (xl+r, yl-r), col, thickness)
##            cv2.line(vis, (x2-r, y2-r), (x2+r, y2+r), col, thickness)
##            cv2.line(vis, (x2-r, y2+r), (x2+r, y2-r), col, thickness)
##    vis0 = vis.copy()
##    for (x1, y1), (x2, y2), inlier in zip(p1, p2, status):
##        if inlier:
##            cv2.line(vis, (x1, y1), (x2, y2), green)
##    return vis