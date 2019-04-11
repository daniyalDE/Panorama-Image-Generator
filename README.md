# Panorama-Image-Generator

# Introduction
A program that can stitch multiple images taken in a sequence to generate an image mosaic. Select multiple corresponding points from the two images, preferably at the edges where the image intersection should happen. Note that, the results will be sensitive to the accuracy of the corresponding points; when providing clicks, choose distinctive points (corners) in the image that appear in both views.

After the points are selected the program computes its associated 3x3 Homography matrix to estimate the homography between the planes. Then the program uses this Homography matrix to compute a warp of the input image with sampled pixel values from nearby pixels. After the source image is warped into the destination image's frame of reference, the images are merged to create the Mosaic.

# Samples

## Input
<img src="/k_a.jpg" width="200">
<img src="/k_b.jpg" width="200">
<img src="/k_c.jpg" width="200">

## Output
<img src="/OUTPUT1.jpg" width="200">
<img src="/OUTPUT2.jpg" width="200">
<img src="/OUTPUT3.jpg" width="200">
<img src="/OUTPUT4.jpg" width="200">
