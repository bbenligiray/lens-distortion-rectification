function error = getDistParamError(kParams, I, lineGroups)

params = struct('fx',1, 'fy', 1, 'cx', size(I, 2) / 2, 'cy', size(I, 1) / 2, 'k1', 0, 'k2', 0, 'k3', 0, 'p1', 0, 'p2', 0);
params.k1 = kParams(1);
params.k2 = kParams(2);

lineGroups = undistortLineGroups(lineGroups, params);
error = gradeLineGroups(lineGroups);


function lineGroups = undistortLineGroups(lineGroups, params)
for i = 1:size(lineGroups,2)
    lineGroups{i} = undistortLineGroup(lineGroups{i}, params);
end


function outLineGroup = undistortLineGroup(lineGroup, params)
fx = params.fx;
fy = params.fy;
cx = params.cx;
cy = params.cy;
k1 = params.k1;
k2 = params.k2;
k3 = params.k3;
% p1 = params.p1;
% p2 = params.p2;
K = [fx 0 cx; 0 fy cy; 0 0 1];

noLines = size(lineGroup, 1);
pts = [lineGroup(:,1:2); lineGroup(:,3:4)];

% Xp = the xyz vals of points on the z plane
hpts = inv(K)*[pts(:,1) pts(:,2) ones(length(pts),1)]';

% we calculate the undistorted points with the Newton-Raphson method
x2 = hpts(1,:);
y2 = hpts(2,:);
r2 = sqrt(x2.^2 + y2.^2);

iterations = 10;

r = r2;
x = r;
y = r;
for i = 1:length(r2)
	for j = 1:iterations
		r(i) = r(i) - (r(i) + k1*r(i)^3 + k2*r(i)^5 - r2(i))/(1 + 3*k1*r(i)^2 + 5*k2*r(i)^4);
	end
	x(i) = x2(i) / (1 + k1*r(i)^2 + k2*r(i)^4);
	y(i) = y2(i) / (1 + k1*r(i)^2 + k2*r(i)^4);
end

pts(:, 1) = x * fx + cx;
pts(:, 2) = y * fy + cy;

outLineGroup = [pts(1:noLines,:) pts(noLines + 1:noLines * 2, :)];


function error = gradeLineGroups(lineGroups)
noOfLineGroups = size(lineGroups,2);
groupErrors = zeros(noOfLineGroups,1);
for i = 1:noOfLineGroups
    noOfLines = size(lineGroups{i}, 1);
    lineErrors = [];
    for j = 1:noOfLines
        for k = j+1:noOfLines
            lineErrors(end + 1) = angleDiffBetweenLines(lineGroups{i}(j, :), lineGroups{i}(k, :))^2;
        end
    end
    groupErrors(i) = mean(lineErrors);
end
error = mean(groupErrors);


function angDiff = angleDiffBetweenLines(line1, line2)
ang1 = radtodeg(atan2(line1(4) - line1(2), line1(3) - line1(1)));
ang2 = radtodeg(atan2(line2(4) - line2(2), line2(3) - line2(1)));
angDiff = abs(ang1 - ang2);
if angDiff > 180
    angDiff = 360 - angDiff;
end