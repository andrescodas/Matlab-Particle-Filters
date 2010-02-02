function [positionsX,positionsY] = readTagPositionFile(fileName)

lineCounter = 0;

readingFile = fopen(fileName,'r');
while(1)
	line = fgetl(readingFile);
        if (~ischar(line))
            break;
        else
            lineCounter = lineCounter + 1;
        end
end
fclose(readingFile);

totalLines = lineCounter;
lineCounter = 0;

readingFile = fopen(fileName,'r');

positionsX = zeros(1,totalLines);
positionsY = zeros(1,totalLines);

while(1)

    line = fgetl(readingFile);
    if (~ischar(line))
        break;
    else
       %porcent = lineCounter / totalLines*100
        lineCounter = lineCounter + 1;
        
        values =sscanf(line,'%d %f %f');
        
        if(values(1) ~= lineCounter)
        %    warning('Data may be not aligned');
        end
        
        positionsX(lineCounter) = values(2);
        positionsY(lineCounter) = values(3);
        
    end
end
fclose(readingFile);
