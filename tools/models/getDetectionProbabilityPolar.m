function p = getDetectionProbabilityPolar(detectionPolarModel,distance,angleRadians)


d = floor(distance/detectionPolarModel.stepDistance)+1;
a = floor(abs(angleRadians/detectionPolarModel.stepAngle))+1;

if (d > size(detectionPolarModel.likelihood,1))
    p = 0;
    return;
elseif (a > size(detectionPolarModel.likelihood,2))
    a = size(detectionPolarModel.likelihood,2);
end

p = detectionPolarModel.likelihood(d,a);
