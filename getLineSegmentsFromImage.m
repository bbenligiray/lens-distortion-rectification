function lineGroups = getLineSegmentsFromImage(I)

% detect line segments with EDPF + EDLines
lineSegments = EDPFLines(I);
lineGroups = {};
noLines = size(lineSegments, 1);
if (noLines == 0)
    return;
end

% represent line segments with their start and end points
ls = zeros(noLines, 4);
for i = 1:noLines
	ls(i, 1) = lineSegments(i).sx;
    ls(i, 2) = lineSegments(i).sy;
	ls(i, 3) = lineSegments(i).ex;
	ls(i, 4) = lineSegments(i).ey;
end

% put the line segments extracted from the same edge segment together
curEdgeSeg = -1;
for i = 1:noLines
    if lineSegments(i).segmentNo ~= curEdgeSeg
        if i == noLines
            continue;
        end
        if lineSegments(i + 1).segmentNo ~= lineSegments(i).segmentNo
            continue;
        end
        curEdgeSeg = lineSegments(i).segmentNo;
        lineGroups{end + 1} = ls(i, :);
    else
        lineGroups{end} = [lineGroups{end}; ls(i, :)];
    end
end