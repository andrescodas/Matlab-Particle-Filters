function [polarModel,cartesianModel] = evaluations2Likelihood(evaluations,fileName,stepDistance,stepAngle,plotBool)
%
% [polarModel,cartesianModel] = evaluations2Likelihood(evaluations,fileName,stepDistance,stepAngle,plotBool)
%

if (nargin < 3)
    stepDistance = 0.2; %% in meters
    stepAngle = 5*pi/180;
end

if (nargin < 5)
    plotBool = 0;
end


likelihoodMatrixPolar = getLikelihoodMatrixPolar(evaluations,stepDistance,stepAngle);
newPolar = smoothMatrix(likelihoodMatrixPolar);
newPolarSmooth = mergeLikelihoodSmooth(likelihoodMatrixPolar,newPolar);

polarModel = struct('stepDistance',stepDistance,'stepAngle',stepAngle,'likelihood',newPolarSmooth);
polarModel = getPositionLikelihoodModel(polarModel);

if(plotBool)
   
    [maxDistance,maxAngle] = size(likelihoodMatrixPolar);
    
    figure
    surf((0:maxAngle-1)*stepAngle*180/pi,(0:(maxDistance-1))*stepDistance,likelihoodMatrixPolar);
    
    ylabel('Distance (m)')
    xlabel('Angle (Degrees)')
    title('P(z = 1 | antennaPosition, TagPosition)')

    figure
    surf((0:maxAngle-1)*stepAngle*180/pi,(0:(maxDistance-1))*stepDistance,newPolar,'EdgeColor','none');

    plotPolarModel(polarModel)

end


fid = fopen(strcat(fileName,'_P.in'),'w');
fprintf(fid,'%d %d %f %f\n',size(likelihoodMatrixPolar,1),size(likelihoodMatrixPolar,2),stepDistance,stepAngle);

for i = 1:size(likelihoodMatrixPolar,1);
    for j = 1:size(likelihoodMatrixPolar,2)
        fprintf(fid,'%f ',newPolarSmooth(i,j));
    end
    fprintf(fid,'\n');
end

fclose(fid);

polarModel = getPositionLikelihoodModel(polarModel);


fid = fopen(strcat(fileName,'_L.in'),'w');
fprintf(fid,'%d %d %f %f\n',size(polarModel.positionLikelihood,1),size(polarModel.positionLikelihood,2),stepDistance,stepAngle);

for i = 1:size(polarModel.positionLikelihood,1);
    for j = 1:size(polarModel.positionLikelihood,2)
        fprintf(fid,'%f ',polarModel.positionLikelihood(i,j));
    end
    fprintf(fid,'\n');
end

fclose(fid);



likelihoodMatrixSquare = getLikelihoodMatrixCartesian(evaluations,stepDistance);

[reducedX,reducedY] = size(likelihoodMatrixSquare);

newSquare = smoothMatrix(likelihoodMatrixSquare);

newSquareSmooth = mergeLikelihoodSmooth(likelihoodMatrixSquare,newSquare);

if(plotBool)

    figure
    surf((-floor(reducedX/2):floor(reducedX/2))*stepDistance,(-floor(reducedY/2):floor(reducedY/2))*stepDistance,likelihoodMatrixSquare');
    
    xlabel('X coordinate(m)')
    ylabel('Y coordinate(m)')
    title('P(z = 1 | antennaPosition, TagPosition)')

    figure
    surf((-floor(reducedX/2):floor(reducedX/2))*stepDistance,(-floor(reducedY/2):floor(reducedY/2))*stepDistance,newSquare');

    xlabel('X coordinate(m)')
    ylabel('Y coordinate(m)')
    title('P(z = 1 | antennaPosition, TagPosition)')
    
    
    figure
    surf((-floor(reducedX/2):floor(reducedX/2))*stepDistance,(-floor(reducedY/2):floor(reducedY/2))*stepDistance,newSquareSmooth','EdgeColor','none');

    xlabel('X coordinate(m)')
    ylabel('Y coordinate(m)')
    title('P(z = 1 | antennaPosition, TagPosition)')

end

fid = fopen(strcat(fileName,'_C.in'),'w');
fprintf(fid,'%d %d %f\n',size(newSquareSmooth,1),size(newSquareSmooth,2),stepDistance);

for i = 1:size(newSquareSmooth,1);
    for j = 1:size(newSquareSmooth,2)
        fprintf(fid,'%f ',newSquareSmooth(i,j));
    end
    fprintf(fid,'\n');
end

fclose(fid);

cartesianModel = struct('stepDistance',stepDistance,'likelihood',newSquareSmooth);
