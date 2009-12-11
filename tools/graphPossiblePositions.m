%function [] = graphPossiblePositions(polarModel,detections,tags)

stepDistance = 0.1;
stepAngle = pi/180*5;
maxDistance = 10;

points = -ones(2*maxDistance/stepDistance+1,2*maxDistance/stepDistance+1,2*pi/stepAngle);



i = 0;
for x = -maxDistance:stepDistance:maxDistance
    display(strcat('Complete =  ', num2str(i*100/(2*maxDistance/stepDistance+1)),'%'))
    i = i+1;
    j = 0;
    for y = -maxDistance:stepDistance:maxDistance
        j = j+1;
        k = 0;
        for t = stepAngle:stepAngle:2*pi
            k = k +1;

            points(i,j,k) = getSimilarityProbability(detections,[x y t],tags,8,polarModel);

        end
    end
end

figure(1)

pXY = -ones(2*maxDistance/stepDistance+1,2*maxDistance/stepDistance+1);

p = -ones(1:2*pi/stepAngle);

i=0;
for x = -maxDistance:stepDistance:maxDistance
    i = i+1;
    j = 0;
    for y = -maxDistance:stepDistance:maxDistance
        j = j+1;

        p(1:2*pi/stepAngle) = points(i,j,:);
        pXY(i,j) = max(p);

    end
end

surf(-maxDistance:stepDistance:maxDistance,-maxDistance:stepDistance:maxDistance,pXY)

figure(2)

pXT = -ones(2*maxDistance/stepDistance+1,2*pi/stepAngle);
p = -ones(1:2*maxDistance/stepDistance+1);

i = 0;
for x = -maxDistance:stepDistance:maxDistance
    i = i+1;
    k = 0;
    for t = stepAngle:stepAngle:2*pi
        k = k +1;

        p(1:2*maxDistance/stepDistance+1) = points(i,:,k);

        pXT(i,k) = max(p);

    end
end

surf(-maxDistance:stepDistance:maxDistance,stepAngle:stepAngle:2*pi,pXT)

figure(3)

pYT = -ones(2*maxDistance/stepDistance+1,2*pi/stepAngle);
p = -ones(1:2*maxDistance/stepDistance+1);

j = 0;
for y = -maxDistance:stepDistance:maxDistance
    j = j+1;
    k = 0;
    for t = stepAngle:stepAngle:2*pi
        k = k +1;

        p(1:2*maxDistance/stepDistance+1) = points(:,j,k);
        pYT(j,k) = max(p);

    end
end

surf(-maxDistance:stepDistance:maxDistance,stepAngle:stepAngle:2*pi,pYT)