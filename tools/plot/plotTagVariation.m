numdata = 200;


tests = 10:10:numdata;
error = zeros(size(tests)) ;
i = 1;

for k = tests;

    %    if ( k == floor(k))
    %        [positionsXRF,positionsYRF,positionsTRF] = readPositionFile(strcat('rfidPositionSet',num2str(k,'%0.1f'),'.txt'));
    %    else
    [tagX,tagY] = readTagPositionFile(strcat('tagPositionSet',num2str(k),'.txt'));
    %    end
    errorTag = distanceMatlab( tagX-ones(size(tagX))*1.5,tagY-ones(size(tagY))*0.5);
    error(i) = mean(errorTag);
    i = i+1;

end

plot(tests,error,tests,error,'.');