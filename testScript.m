
close all
clear all
clc

m1 = [ -0.009012,0.074029,0.181707,-0.033214,-0.143492;-0.107641,0.166102,-0.044821,-0.167839,0.052637;1.920705,1.750401,1.748809,1.760258,1.750929];
m2 = [ -0.008961,0.074056,0.181519,-0.033214,-0.144097;-0.107303,0.166234,-0.044678,-0.167839,0.053124;1.920859,1.750555,1.749032,1.760258,1.750775];
m3 = [ -0.006654,-0.289149,-0.148345,0.061795,-0.082174;-0.101993,-0.150014,0.040808,-0.102056,-0.294456;1.921098,1.749645,1.748433,1.750711,1.760739];
m4 = [ -0.013037,0.155916,-0.076845,-0.036100,0.195843;-0.102019,-0.333343,-0.293995,-0.043499,-0.090504;1.921628,1.749475,1.746806,1.759738,1.751483];


measures = [struct('m',m1),struct('m',m2),struct('m',m3),struct('m',m4)];


close all
figure(1);
hold all;

for i = 1:4
    for j = 1:5
           
        
           if (j == 2)
               plot(measures(i).m(1,j),measures(i).m(2,j),'x');
               
           elseif (j == 3 )
               plot(measures(i).m(1,j),measures(i).m(2,j),'+');
           elseif (j == 4 )
            plot(measures(i).m(1,j),measures(i).m(2,j),'*');
           elseif (j == 5 )
            plot(measures(i).m(1,j),measures(i).m(2,j),'s');
           else 
               plot(measures(i).m(1,j),measures(i).m(2,j),'o');
           end
           
        
    end
end
    

%xlim([-0.5 0.5])
%ylim([-0.5 0.5])
    
    centerCircles = zeros(2,4);

for markerIt = 2:5

        
        x1 = measures(1).m(1,markerIt);
        x2 = measures(2).m(1,markerIt);
        x3 = measures(3).m(1,markerIt);
        y1 = measures(1).m(2,markerIt);
        y2 = measures(2).m(2,markerIt);
        y3 = measures(3).m(2,markerIt);
        
        
		a = (x1-x2);
		b = (y1-y2);
		c = (x1-x3);
		d = (y1-y3);

		doubledet = 2 * (a*d-b*c);


		r1 = (x1*x1-x2*x2+y1*y1-y2*y2);
		r2 = (x1*x1-x3*x3+y1*y1-y3*y3);

              
		centerCircles(1,markerIt-1) = ( d  * r1  -  b*r2 )/(doubledet);
		centerCircles(2,markerIt-1) = (-c  * r1  +  a*r2 )/(doubledet);

end
    

   for i = 1:3
    for j = 2:5
           
  
           if (j == 2)
               plot(centerCircles(1,j-1),centerCircles(2,j-1),'x');       
           elseif (j == 3 )
              plot(centerCircles(1,j-1),centerCircles(2,j-1),'+');
           elseif (j == 4 )
            plot(centerCircles(1,j-1),centerCircles(2,j-1),'*');
           elseif (j == 5 )
            plot(centerCircles(1,j-1),centerCircles(2,j-1),'s');
           end
           
        
    end
   end

    meanCenterx = 0;
    meanCentery = 0;
   
	for i = 1:4
		meanCenterx = meanCenterx + centerCircles(1,i);
		meanCentery = meanCentery + centerCircles(2,i);
    end


	meanCenterx = meanCenterx/4;
	meanCentery = meanCentery/4;



% 	// up == 0
% 	// front == 1
% 	// right == 2
% 	// behind == 3
% 	// left == 4

	vertical1Before = measures(3).m(2,2) - measures(3).m(2,4);
	vertical2Before = measures(3).m(2,3) - measures(3).m(2,5);
	horizontal1Before = measures(3).m(1,2) - measures(3).m(1,4);
	horizontal2Before = measures(3).m(1,3) - measures(3).m(1,5);

	angle1Before = atan2(vertical1Before,horizontal1Before);
	angle2Before = atan2(vertical2Before,horizontal2Before);

	meanAnglesBefore = anglesMean(angle1Before,angle2Before);
% 
% 	printf("AB1: %lf\t",angle1Before*180/PI);
% 	printf("AB2: %lf\t",angle2Before*180/PI);r
% 	printf("AB: %lf\n",meanAnglesBefore*180/PI);

	vertical1After = measures(4).m(2,2) - measures(4).m(2,4)
	vertical2After = measures(4).m(2,3) - measures(4).m(2,5)
	horizontal1After = measures(4).m(1,2) - measures(4).m(1,4)
	horizontal2After = measures(4).m(1,3) - measures(4).m(1,5)

	angle1After = atan2(vertical1After,horizontal1After)
	angle2After = atan2(vertical2After,horizontal2After)
	meanAnglesAfter = anglesMean(angle1After , angle2After)
% 
% 	printf("AF1: %lf\t",angle1After*180/PI);
% 	printf("AF2: %lf\t",angle2After*180/PI);
% 	printf("AF: %lf\n",meanAnglesAfter*180/PI);

	meanAngles = anglesMean( meanAnglesAfter , meanAnglesBefore );
% 	printf("AA: %lf\n",meanAngles*180/PI);

	forwardX = 0;
	forwardY = 0;
	

	for markerIt = 1:5
		forwardX = forwardX + measures(4).m(1,markerIt) - measures(3).m(1,markerIt);
		forwardY = forwardY + measures(4).m(2,markerIt) - measures(3).m(2,markerIt);
	end

	forwardDirection = atan2(forwardY,forwardX);
% 	printf("FD: %lf\n",forwardDirection*180/PI);
	angleError = forwardDirection - meanAngles;
	angleError = angleWrap(angleError);

	resultCalibration.angleCorrection = angleError*180/pi

% 	printf("angle Correction: %lf\n",angleError*180/PI);




	angle1Error = (atan2(meanCentery - measures(3).m(2,4),meanCenterx - measures(3).m(1,4))- angle1Before)*180/pi
	angle2Error = (atan2(meanCentery - measures(3).m(2,5),meanCenterx - measures(3).m(1,5)) - angle2Before)*180/pi 

	distance1 = distanceMatlab(meanCentery - measures(3).m(2,3),meanCenterx - measures(3).m(1,3))
	distance2 = distanceMatlab(meanCentery - measures(3).m(2,4),meanCenterx - measures(3).m(1,4))

% 	resultCalibration.vectorCorrection(0)(0) = angle1Error;
% 	resultCalibration.vectorCorrection(0)(1) = angle2Error;
% 	resultCalibration.vectorCorrection(1)(0) = distance1;
% 	resultCalibration.vectorCorrection(1)(1) = distance2;



% 	printf("Calibration Result\nAngle: %lf\nmatrix:\n%lf\t%lf\n%lf\t%lf\n",resultCalibration.angleCorrection,
% 								  resultCalibration.vectorCorrection(0)(0)*180/PI,
% 								  resultCalibration.vectorCorrection(0)(1)*180/PI,
% 								  resultCalibration.vectorCorrection(1)(0),
% 								  resultCalibration.vectorCorrection(1)(1));


% 	return resultCalibration;

