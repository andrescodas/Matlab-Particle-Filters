function antennaAngle = getAntennaAngle(antennaNumber)
% 

if(antennaNumber == 6)
   antennaNumber = 5;
   
end

antennaAngle = -2*pi/8*antennaNumber + pi;