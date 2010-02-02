function points = getRobotPath()

yMax  =1.25;
xMax  = 1.5;

centerX = 0.5;
centerY = -0.25;

k = 0;
i = 1;


for j = 0:1
    k = k+1;

    points(k,1) = centerX + i*xMax;
    points(k,2) = centerY + j*yMax;

end

for i = 0:-1:-1
    k = k+1;
    points(k,1) = centerX + i*xMax;
    points(k,2) = centerY + j*yMax;
end

for j=  0:-1:-1
    k = k+1;
    points(k,1) = centerX + i*xMax;
    points(k,2) = centerY + j*yMax;
end

for i= 0:1
    k = k+1;
    points(k,1) = centerX + i*xMax;
    points(k,2) = centerY + j*yMax;

end
