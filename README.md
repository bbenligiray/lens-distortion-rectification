## Blind Rectification of Radial Distortion by Line Straightness

Code used in the following paper:

[Benligiray, B.; Topal, C., "Blind rectification of radial distortion by line straightness," Proc. Eur. Signal Process. Conf. (EUSIPCO), 2016.](http://ieeexplore.ieee.org/document/7760386/)

The DLLs are built for 64-bit Windows, so the code won't run in other platforms. You may need to install the Visual C++ 2012 redistributable (x64).

#### What is this?

Automatic lens distortion rectification methods rely on the scene to contain almost only linear structures.
The features extracted from non-linear structures tend to deteriorate the results.

This is a robust lens distortion rectification method that selects feature groups that are likely to be extracted from linear structures in the following ways:
* The line segments are extracted from edge segments. Only consecutive line segments on an edge segment are grouped. This results in much less false groups compared to testing all line segment combinations.
* After grouping the line segments, backward feature elimination is applied. False groups are easily eliminated because they don't agree with true groups or each other.

<p align="center">
  <img src="https://user-images.githubusercontent.com/19530665/27872692-49477746-61b2-11e7-9557-0fe924bf5243.png"/>
</p>
