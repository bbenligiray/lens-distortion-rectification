function outLineGroups = groupLineSegments(lineGroups, distThres, angleThres)

noOfLineGroups = size(lineGroups, 2);
outLineGroups = {};

for i = 1:noOfLineGroups
	noOfLineSegments = size(lineGroups{i}, 1);
    
    % find the errors of consecutive line segments
	errors = zeros(noOfLineSegments, 1);
	for indLineSeg1 = 1:noOfLineSegments
        indLineSeg2 = mod(indLineSeg1, noOfLineSegments) + 1;
        errors(indLineSeg1) = getLineError(lineGroups{i}(indLineSeg1, :), lineGroups{i}(indLineSeg2, :));
	end
    
    % use this to keep track of the line segments that are already grouped
    usedLines = zeros(noOfLineSegments, 1);
    while true
        % if there are no line segments close enough to group, break
        [minError, minErrorID] = min(errors);
        if minError > distThres
            break;
        end
        
        % select the closest line segment pair as seeds
        seedSeg = [minErrorID  mod(minErrorID, noOfLineSegments) + 1];
        groupIndices = seedSeg;
        % mark them, so they don't get selected again
        errors(seedSeg(1)) = Inf;
        
        % if the angle difference between the seed segments is larger than
        % the threshold, move on
        ang1 = getLineSegmentAngle(lineGroups{i}(seedSeg(1), :));
        ang2 = getLineSegmentAngle(lineGroups{i}(seedSeg(2), :));
        angDiff = getDifferenceOfAngles(ang1, ang2);
        if angDiff > angleThres
            continue;
        end
        
        % these lines are used
        usedLines(seedSeg(1)) = 1;
        usedLines(seedSeg(2)) = 1;
        
        % check the line segment before
        indLineSeg0 = mod(seedSeg(1) - 2, noOfLineSegments) + 1;
        if usedLines(indLineSeg0) == 0
            ang0 = getLineSegmentAngle(lineGroups{i}(indLineSeg0, :));
            angDiff = getDifferenceOfAngles(ang1, ang0);
            if angDiff < angleThres
                if errors(indLineSeg0) < distThres
                    errors(indLineSeg0) = Inf;
                    usedLines(indLineSeg0) = 1;
                    groupIndices = [indLineSeg0 groupIndices];
                end
            end
        end
        
        % check the line segment after
        indLineSeg3 = mod(seedSeg(2), noOfLineSegments) + 1;
        if usedLines(indLineSeg3) == 0
            ang3 = getLineSegmentAngle(lineGroups{i}(indLineSeg3, :));
            angDiff = getDifferenceOfAngles(ang1, ang3);
            if angDiff < angleThres
                if errors(indLineSeg3) < distThres
                    errors(indLineSeg3) = Inf;
                    usedLines(indLineSeg3) = 1;
                    groupIndices = [groupIndices indLineSeg3];
                end
            end
        end
        
        outLineGroups{end + 1} = zeros(size(groupIndices, 2), 4);
        for j = 1:size(groupIndices,2)
            outLineGroups{end}(j, :) = lineGroups{i}(groupIndices(j), :);
        end
    end
end


% returns the smaller angle between two angles
function angDiff = getDifferenceOfAngles(ang1, ang2)
angDiff = abs(ang1 - ang2);
if angDiff > 180
    angDiff = 360 - angDiff;
end


% returns the angle of the line segment (-180, 180)
function ang = getLineSegmentAngle(lineSeg)
ang = radtodeg(atan2(lineSeg(4) - lineSeg(2), lineSeg(3) - lineSeg(1)));


% returns the "error" of two line segments (their minimum distance from
% their intersection)
function error = getLineError(lineSeg1, lineSeg2)
% find the homogeneous representation of the line that passes through the
% start and end points of the first line segment
line1 = cross([lineSeg1(1) lineSeg1(2) 1], [lineSeg1(3) lineSeg1(4) 1]);
% normalize the line
norm = sqrt(line1(1)^2 + line1(2)^2);
line1 = line1 / norm;
% find the distances of the line to the start and end points of the second
% line segment
dist1 = dot(line1, [lineSeg2(1) lineSeg2(2) 1]);
dist2 = dot(line1, [lineSeg2(3) lineSeg2(4) 1]);
% error is the smaller distance
error1 = min(dist1, dist2);

% do the same, in the reverse direction
line2 = cross([lineSeg2(1) lineSeg2(2) 1], [lineSeg2(3) lineSeg2(4) 1]);
norm = sqrt(line2(1)^2 + line2(2)^2);
line2 = line2 / norm;
dist3 = dot(line2, [lineSeg1(1) lineSeg1(2) 1]);
dist4 = dot(line2, [lineSeg1(3) lineSeg1(4) 1]);
error2 = min(dist3, dist4);

% return the smaller of the errors
error = min(error1, error2);