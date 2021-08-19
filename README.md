# BreastCancerSegmentation
BACHELOR’S DEGREE IN COMPUTER ENGINEERING FINAL PROJECT

## Abstract
In automatic Breast Cancer Detection, breast masses appear as white spots in mammograms,
and therefore Computer-aided detection and diagnosis (CAD) systems meet a challenge
when working with images in the medio-lateral oblique (MLO) view, due to the presence
of the pectoral muscle, which has similar radiographic density than the dense regions of the
breast, that increases the false positive rate in CAD systems.
The focus of this project is the implementation of an algorithm that is able to segment
the pectoral muscles in Tomosynthesis and Mammographic MLO images, and to tune and
refine the outputs by introducing a new meta-heuristic optimization technique in the process,
called Grey Wolf Optimizer.
The algorithm will output an image of the breast, with the segmented pectoral, from
which we will be able to segment the dense regions of the breast and determine its density and
BI-RADS level. This information might be useful in later works for breast cancer detection,
as it is proved that the density has an impact in the detection of breast masses as it increases.
This whole process will be included in a user-friendly application that will show the
outputs of the algorithm including the pectoral segmentation and the dense area detection, as
well as other meaningful information about the breast image loaded and the process.


