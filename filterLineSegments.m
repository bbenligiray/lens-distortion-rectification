function outLineGroups = filterLineSegments(lineGroups, imageSize, lengthThres, radDistThres)

noOfLineGroups = size(lineGroups, 2);
imageCenter = [imageSize(2)/2 imageSize(1)/2 1];

outLineGroups = {};

for i = 1:noOfLineGroups
	noOfLineSegments = size(lineGroups{i}, 1);
    newLineGroup = [];
    
    for j = 1:noOfLineSegments
        % if the line segment is too short, discard
        currLine = lineGroups{i}(j, :);
        dist = (currLine(1) - currLine(3))^2 + (currLine(2) - currLine(4))^2;
        if dist < lengthThres * lengthThres
            continue;
        end
        % if the line segment passes to close to the image center, discard
        line = cross([currLine(1) currLine(2) 1], [currLine(3) currLine(4) 1]);
        norm = sqrt(line(1)^2 + line(2)^2);
        line = line / norm;
        distFromCent = abs(dot(line, imageCenter));
        if distFromCent < radDistThres
            continue;
        end
        % if the line segment is not discarded, add it to the current group
        newLineGroup(end + 1, :) = currLine;
    end
    % keep the current group if it has more than 1 line segment
    if size(newLineGroup, 1) > 1
        outLineGroups{end + 1} = newLineGroup;
    end
end