function []  = plotTagsEstimation(inferingTags,robotPosition,realTags,angle,translation)

for j = 1:length(inferingTags)

    figure(j)
    hold off

    if(nargin>3)

        costheta = cos(angle);
        sintheta = sin(angle);

        rotationMatrix = [costheta,-sintheta;sintheta,costheta]';

        toPlot = inferingTags(j).particuleSet(1).position * rotationMatrix + translation;

        plot(toPlot(1),toPlot(2),strcat('g','.'));
        xlim([-30 30])
        ylim([-30 30])
        grid
        hold all;
        for k = 2:length(inferingTags(j).particuleSet)
            toPlot = inferingTags(j).particuleSet(k).position * rotationMatrix + translation;
            plot(toPlot(1),toPlot(2),strcat('g','.'));
        end
        toPlot = inferingTags(j).position * rotationMatrix + translation;
        plot(toPlot(1),toPlot(2),strcat('b','o'))

    else

        plot(inferingTags(j).particuleSet(1).position(1),inferingTags(j).particuleSet(1).position(2),strcat('g','.'));
        xlim([-30 30])
        ylim([-30 30])
        grid
        hold all;
        for k = 2:length(inferingTags(j).particuleSet)
            plot(inferingTags(j).particuleSet(k).position(1),inferingTags(j).particuleSet(k).position(2),strcat('g','.'));
        end
        plot(inferingTags(j).position(1),inferingTags(j).position (2),strcat('b','o'))
        
        
    end
    if(nargin > 1)

        plot(robotPosition(1),robotPosition(2),'rh')

        if(nargin > 2)

            m = searchTag(realTags,inferingTags(j).tagId);
            plot(realTags(m).position(1),realTags(m).position(2),strcat('k','*'))

        end
    end

end
