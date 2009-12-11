function [] = graphPossiblePositions(detections,maxDistance,maxAngle,meanAngle,stepDistance,stepAngle,tags,polarModel)

if(nargin < 8)
    load polarModel
    if (nargin <  7)
        tags = realTagsPosition();
        if (nargin < 6)
            stepAngle = pi/180*5;
            if (nargin < 5)
                stepDistance = 0.2;
                if (nargin < 4)
                    meanAngle = 0;
                    if (nargin < 3)
                        maxAngle = pi;%pi/180*30;
                        if (nargin < 2)
                            maxDistance = 5;
                        end
                    end
                end
            end
        end
    end
end



points = -ones(2*maxDistance/stepDistance+1,2*maxDistance/stepDistance+1,2*maxAngle/stepAngle+1);



i = 0;
for x = -maxDistance:stepDistance:maxDistance
    display(strcat('Complete =  ', num2str(i*100/(2*maxDistance/stepDistance+1)),'%'))
    i = i+1;
    j = 0;
    for y = -maxDistance:stepDistance:maxDistance
        j = j+1;
        k = 0;
        for t = meanAngle-maxAngle:stepAngle:meanAngle+maxAngle
            k = k +1;

            points(i,j,k) = getSimilarityProbability(detections,[x y t],tags,8,polarModel);

        end
    end
end

figure(1)

pXY = -ones(2*maxDistance/stepDistance+1,2*maxDistance/stepDistance+1);

p = -ones(1,2*maxAngle/stepAngle+1);

i=0;
for x = -maxDistance:stepDistance:maxDistance
    i = i+1;
    j = 0;
    for y = -maxDistance:stepDistance:maxDistance
        j = j+1;

        p(1:2*maxAngle/stepAngle+1) = points(i,j,:);
        pXY(i,j) = max(p);

    end
end

surf(-maxDistance:stepDistance:maxDistance,-maxDistance:stepDistance:maxDistance,pXY')

figure(2)

pXT = -ones(2*maxDistance/stepDistance+1,2*maxAngle/stepAngle+1);
p = -ones(1,2*maxDistance/stepDistance+1);

i = 0;
for x = -maxDistance:stepDistance:maxDistance
    i = i+1;
    k = 0;
    for t = meanAngle-maxAngle:stepAngle:meanAngle+maxAngle
        k = k +1;

        p(1:2*maxDistance/stepDistance+1) = points(i,:,k);

        pXT(i,k) = max(p);

    end
end

surf(-maxDistance:stepDistance:maxDistance,meanAngle-maxAngle:stepAngle:meanAngle+maxAngle,pXT')

figure(3)

pYT = -ones(2*maxDistance/stepDistance+1,2*maxAngle/stepAngle+1);
p = -ones(1,2*maxDistance/stepDistance+1);

j = 0;
for y = -maxDistance:stepDistance:maxDistance
    j = j+1;
    k = 0;
    for t = meanAngle-maxAngle:stepAngle:meanAngle+maxAngle
        k = k +1;

        p(1:2*maxDistance/stepDistance+1) = points(:,j,k);
        pYT(j,k) = max(p);

    end
end

surf(-maxDistance:stepDistance:maxDistance,meanAngle-maxAngle:stepAngle:meanAngle+maxAngle,pYT')