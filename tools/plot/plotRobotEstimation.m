function [] = plotRobotEstimation(robotByParticules,inferingTags,robotPosition,rflexPosition)


figure(1)
hold off

for j = 1:length(inferingTags)
	
    plot(inferingTags(j).position(1),inferingTags(j).position(2),strcat('b','o'))
    if (j == 1)
        hold all;
    end
    plot(robotPosition(1),robotPosition(2),'rh')

    xlim([-3 3])
    ylim([-3 3])
end
 
for k = 1:length(robotByParticules.particuleSet)
    plot(robotByParticules.particuleSet(k).position(1),robotByParticules.particuleSet(k).position(2),strcat('g','.'));
    [u,v] = pol2cart(robotByParticules.particuleSet(k).position(3),0.5);
    quiver(robotByParticules.particuleSet(k).position(1),robotByParticules.particuleSet(k).position(2),u,v);
end

plot(robotByParticules.position(1),robotByParticules.position(2),strcat('k','o'))
    [u,v] = pol2cart(robotByParticules.position(3),0.5);
    quiver(robotByParticules.position(1),robotByParticules.position(2),u,v);

if(nargin > 2)
    plot(robotPosition(1),robotPosition(2),strcat('k','*'))
    [u,v] = pol2cart(robotPosition(3),0.5);
    quiver(robotPosition(1),robotPosition(2),u,v);
end

[u,v] = pol2cart(rflexPosition(3),2);
quiver(rflexPosition(1),rflexPosition(2),u,v);


figure(2)

hold off;

angles = zeros(1,length(robotByParticules.particuleSet)) ;

for k = 1:length(robotByParticules.particuleSet)
    angles(k) = angleWrap(robotByParticules.particuleSet(k).position(3)-robotPosition(3))*180/pi;
end

if(abs(max(angles))>30)
    hist(angles,-180:180)
else
    hist(angles,-30:30)
end

figure(3)
hold off
rose(angles/180*pi)



%plot(0,robotByParticules.position(3)*180/pi,strcat('k','o'))
%plot(0,robotPosition(3)*180/pi,strcat('k','*'))    

 %ylim([-180 180])
