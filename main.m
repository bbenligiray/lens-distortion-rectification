% read the image
I = imread('Department Dataset/Image2_fixed.bmp');

% detect line segment groups with EDPF + EDLines
lineGroups = getLineSegmentsFromImage(I);

% plot the initial line segments
plotTitle = '1 - All line segments';
plotLinesOnImage(I, lineGroups, plotTitle);

% filter line segments
lineGroups = filterLineSegments(lineGroups, size(I), 25, 50);

% plot the filtered line segments
figure;
plotTitle = '2 - Filtered line segments';
plotLinesOnImage(I, lineGroups, plotTitle);

% group the remaining line segments
lineGroups = groupLineSegments(lineGroups, 800, 30);

% plot the line segment groups
figure;
plotTitle = '3 - Line segment groups';
plotLinesOnImage(I, lineGroups, plotTitle);

% select a set of line segment groups with sequential backward selection
lineGroups = selectLineSegmentGroups(lineGroups, I);

% plot the line segment groups
figure;
plotTitle = '4 - Selected line segment groups';
plotLinesOnImage(I, lineGroups, plotTitle);

% find the distortion parameters
funToSolve = @(x)getDistParamError(x, I, lineGroups);
[kParams, ~] = fminsearch(funToSolve, [0;0]);

% undistort the image
IntrinsicMatrix = [1 0 0; 0 1 0; size(I, 2) / 2 size(I, 1) / 2 1];
radialDistortion = [kParams(1) kParams(2) 0];
cameraParams = cameraParameters('IntrinsicMatrix', IntrinsicMatrix, 'RadialDistortion', radialDistortion);
undistI = undistortImage(I, cameraParams);

% plot the undistorted image
figure;
plotTitle = '5 - Undistorted image';
imshow(undistI);