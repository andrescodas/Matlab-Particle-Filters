numdata = 1;


tests = 0:0.01:numdata;
error = zeros(size(tests)) ;
i = 1;

for k = tests;

    if ( k == floor(k))
        [tagX,tagY] = readTagPositionFile(strcat('tagPositionSet',num2str(k,'%0.1f'),'.txt'));
    else
        [tagX,tagY] = readTagPositionFile(strcat('tagPositionSet',num2str(k),'.txt'));
    end
    errorTag = distanceMatlab( tagX-ones(size(tagX))*1.5,tagY-ones(size(tagY))*0.5);
    error(i) = mean(errorTag);
    i = i+1;

end

plot(tests,error);
xlabel('n_t')
ylabel('Error Mean (m)')
grid on