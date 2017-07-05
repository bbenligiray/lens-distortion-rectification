function lineGroups = selectLineSegmentGroups(lineGroups, I)

minNoLineGroups = 5;

while true
    % better not eliminate if there are already few groups
	noLineGroups = length(lineGroups);
    if noLineGroups <= minNoLineGroups
        break;
	end
    
    funToSolve = @(x)getDistParamError(x, I, lineGroups);
	[~, error] = fminsearch(funToSolve, [0;0]);
	minError = error;
	origLineGroups = lineGroups;
    
    % eliminate each line segment group and search for a distortion
    % parameter
	indToEliminate = 0;
	for i = 1:noLineGroups
        lineGroups = {};
        for j = 1:noLineGroups
            if j ~= i
                lineGroups{end + 1} = origLineGroups{j};
            end
        end
        funToSolve = @(x)getDistParamError(x, I, lineGroups);
        [~, error] = fminsearch(funToSolve, [0;0]);
        if (error < minError)
            minError = error;
            indToEliminate = i;
        end
	end
    
    % if eliminating any of the line segment groups didn't help, break
	if indToEliminate == 0
        lineGroups = origLineGroups;
		break;
    else
        disp(['Eliminating line segment group #' num2str(indToEliminate)]);
        lineGroups = {};
        for j = 1:noLineGroups
            if j ~= indToEliminate
                lineGroups{end + 1} = origLineGroups{j};
            end
        end
	end
end