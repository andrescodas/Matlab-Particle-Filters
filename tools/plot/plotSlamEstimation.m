function []  = plotSlamEstimation(inferingTags,robotbyParticules,robotPosition,realTags,angle,translation)
%
% plotSlamEstimation(inferingTags,robotbyParticules,robotPosition,realTags,angle,translation)
%

if(nargin < 5)
    costheta = 1;
    sintheta = 0;
    translation = [0 0];

else
    costheta = cos(angle);
    sintheta = sin(angle);
end

rotationMatrix = [costheta,-sintheta;sintheta,costheta]';

for j = 1:length(inferingTags)

    figure(j)
    hold off

    toPlot = inferingTags(j).particuleSet(1).position * rotationMatrix + translation;

    plot(toPlot(1),toPlot(2),strcat('g','.'));
    xlim([-3 3])
    ylim([-3 3])
    grid
    hold all;

    for k = 2:length(inferingTags(j).particuleSet)
        toPlot = inferingTags(j).particuleSet(k).position * rotationMatrix + translation;
        plot(toPlot(1),toPlot(2),strcat('g','.'));
    end
    toPlot = inferingTags(j).position * rotationMatrix + translation;
    plot(toPlot(1),toPlot(2),strcat('b','o'))

    m = searchTag(realTags,inferingTags(j).tagId);
    plot(realTags(m).position(1),realTags(m).position(2),strcat('k','*'))


    for k = 1:length(robotbyParticules.particuleSet)
        toPlot = robotbyParticules.particuleSet(k).position(1:2) * rotationMatrix + translation;
        plot(toPlot(1),toPlot(2),strcat('y','.'));
    end
    plot(robotPosition(1),robotPosition(2),'rh')

end
