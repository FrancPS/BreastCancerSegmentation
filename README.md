# Breast region Segmentation and Density analysis in Tomosynthesis and Mammographic images
BACHELOR’S DEGREE IN COMPUTER ENGINEERING FINAL PROJECT

## Abstract
In automatic Breast Cancer Detection, breast masses appear as white spots in mammograms, and therefore Computer-aided detection and diagnosis (CAD) systems meet a challenge when working with images in the medio-lateral oblique (MLO) view, due to the presence of the pectoral muscle, which has similar radiographic density than the dense regions of the breast, that increases the false positive rate in CAD systems.  
The focus of this project is the implementation of an algorithm that is able to segment the pectoral muscles in Tomosynthesis and Mammographic MLO images, and to tune and refine the outputs by introducing a new meta-heuristic optimization technique in the process,
called Grey Wolf Optimizer.  
The algorithm will output an image of the breast, with the segmented pectoral, from which we will be able to segment the dense regions of the breast and determine its density and BI-RADS level. This information might be useful in later works for breast cancer detection, as it is proved that the density has an impact in the detection of breast masses as it increases.  
This whole process will be included in a user-friendly application that will show the outputs of the algorithm including the pectoral segmentation and the dense area detection, as well as other meaningful information about the breast image loaded and the process.

## Full Paper
(PDF) Pectoral Muscle Segmentation in Tomosynthesis Images Using Geometry Information and Grey Wolf Optimizer.  
Available from: https://www.researchgate.net/publication/338488138_Pectoral_Muscle_Segmentation_in_Tomosynthesis_Images_Using_Geometry_Information_and_Grey_Wolf_Optimizer

## Installation Guide
I dont have the full licence of Matlab so I can't create the standalone executable file. If any time I am able to do so, i will create a release for the program. Meanwhile, follow the next steps to try it.

## Code Usage
To run the files through Matlab, you will need the following
- A Matlab 2019+ installed in your computer
- The following Matlab add-ons:
  - Image Processing Toolbox
  - Mapping Toolbox
  - Maximum Inscribed Circle using Distance Transform

## Using the App
1.  Open the executable file 'SegMammo.m' on Matlab, and click RUN.
2.  Click 'Browse' to select the image in your system, or write the path manually in the 'Image path' text-box.
3.  Click 'Load' to load the image into the workspace.  It will be displayed in the centerpart of the window. This is the base image you will work from now on, until another image is loaded.
4. OPTIONAL: Open the popup menu and choose an optimization process. Default option is an unoptimized execution.
5. OPTIONAL: Write the number of iterations of the optimization process. Note that higher the number, slower the process will be, but with better approximations. Default number of iterations is 10.
6.  Click 'RUN'. Once the process is finished it will show the image BI-RADS level and other info, and allow the display buttons in the lower part of the commands window.
7.  Click on the 'Show' buttons to display the output images of the process on the right window of the interface.
