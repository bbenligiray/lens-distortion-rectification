function plotLinesOnImage(I, lineGroups, plotTitle)

imshow(I);
hold on;
noOfLineGroups = size(lineGroups, 2);
cmap = hsv(6);
count=1;
radius = 2;

for i = 1:noOfLineGroups
    for j = 1:size(lineGroups{i}, 1)
        plot([lineGroups{i}(j,1) lineGroups{i}(j,3)], [lineGroups{i}(j,2) lineGroups{i}(j,4)], 'Color', cmap(count,:),'LineWidth',3);
        rectangle('Position',[lineGroups{i}(j,1)-radius,lineGroups{i}(j,2)-radius,radius*2+1,radius+2+1],'Curvature',[1 1],'EdgeColor',cmap(count,:),'FaceColor',cmap(count,:));
        rectangle('Position',[lineGroups{i}(j,3)-radius,lineGroups{i}(j,4)-radius,radius*2+1,radius+2+1],'Curvature',[1 1],'EdgeColor',cmap(count,:),'FaceColor',cmap(count,:));
    end
    count = count + 1;
	if count == 7
        count = 1;
	end
end

title(plotTitle);