function movementSimulation = simulateMovement(piloMove,robotPosition,rflexPosition)


ifa2a = 0.05;  % imprecisionFactorAxial2Axial
ifa2t = 0.01; % imprecisionFactorAxial2Transversal
ift2t = 0.05;  % imprecisionFactorTransversal2Transversal
ift2a = 0.01; % imprecisionFactorTransversal2Axial
ifo = pi/180*5;   % imprecisionFactorOrientation

newRflexPosition = rflexPosition;

rflexCovariance = diag([ifa2a*abs(piloMove(1)) + ift2a*abs(piloMove(2)), ift2t*abs(piloMove(2))+ifa2t*abs(piloMove(1)),ifo*abs(piloMove(3))]).^2*0.1;

rflexCovarianceSQRT = sqrt(rflexCovariance);


uNoiseRobot = rflexCovarianceSQRT*randn(3,1)/10*0;
uNoiseRflex = rflexCovarianceSQRT*randn(3,1)*0;


newRobotPosition = robotPosition + rotation(piloMove + uNoiseRobot',robotPosition(3)); 
newRobotPosition(3) = angleWrap(newRobotPosition(3)+uNoiseRobot(3));

newRflexPosition = newRflexPosition + rotation(piloMove + uNoiseRflex',newRflexPosition(3));
newRflexPosition(3) = angleWrap(newRflexPosition(3)+uNoiseRflex(3));


movementSimulation = struct('robotPosition',newRobotPosition,'rflexPosition',newRflexPosition,'rflexPositionBefore',rflexPosition,'rflexCov',rflexCovariance);