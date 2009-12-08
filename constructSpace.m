robotPositionAnt = [-inf -inf -inf];
lineCounter = 0;

readingFile = fopen('space.txt','r');
while(1)
	line = fgetl(readingFile);
        if (~ischar(line))
            break;
        else
            lineCounter = lineCounter + 1;
        end
end

totalLines = lineCounter;
lineCounter = 0;

readingFile = fopen('space.txt','r');

positionsX = zeros(1,totalLines);
positionsY = zeros(1,totalLines);

while(1)

    line = fgetl(readingFile);
    if (~ischar(line))
        break;
    else
        porcent = lineCounter / totalLines*100
        lineCounter = lineCounter + 1;
        
        tagId = char(sscanf(line,'%*f %*f %*f %s %*d %*d %*d %*d %*d %*d %*d %*d')');
        values =sscanf(line,'%f %f %f %*s %d %d %d %d %d %d %d %d');

        robotPosition = [values(1) values(2) values(3)];
        
        positionsX(lineCounter) = values(1);
        positionsY(lineCounter) = values(2);
    end
end

plot(positionsX,positionsY,'x',positionsX,positionsY)
    