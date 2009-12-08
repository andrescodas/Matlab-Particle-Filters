function [] = plotPolarModel(polarModel)

    [maxDistance,maxAngle] = size(polarModel.likelihood);
    
    figure
    surf((0:maxAngle-1)*polarModel.stepAngle*180/pi,(0:(maxDistance-1))*polarModel.stepDistance,polarModel.likelihood);
    
    ylabel('Distance (m)')
    xlabel('Angle (Degrees)')
    title('P(z = 1 | robotPosition, TagPosition)')

    
    figure
    
    dif = polarModel.positionLikelihood(:,1);
    dif = dif - [0 ;(dif(1:length(dif)-1))];
    
    bar(((0:(maxDistance-1))*polarModel.stepDistance)+polarModel.stepDistance/2,dif,1);
    
    
    xlabel('Distance (m)')
    ylabel('Position Likelihood')
    title('P(distance | z == 1, TagPosition)')
