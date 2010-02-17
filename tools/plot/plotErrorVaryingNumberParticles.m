[positionsXM,positionsYM,positionsTM] = readPositionFile('/home/andres/simulation/mocapPositionSet.txt');
positionsXMD = positionsXM - [0 positionsXM(1:(length((positionsXM))-1))];
positionsYMD = positionsYM - [0 positionsYM(1:(length((positionsYM))-1))];
positionsTMD = positionsTM - [0 positionsTM(1:(length((positionsTM))-1))];

numdata = 100;


tests = 0:1:numdata;
error = zeros(size(tests)) ;
i = 1;
for k = tests;

    if ( k == floor(k))
        [positionsXRF,positionsYRF,positionsTRF] = readPositionFile(strcat('rfidPositionSet',num2str(k,'%0.1f'),'.txt'));
    else
        [positionsXRF,positionsYRF,positionsTRF] = readPositionFile(strcat('rfidPositionSet',num2str(k),'.txt'));
    end
    errorRF = distanceMatlab(positionsXRF-positionsXM,positionsYRF-positionsYM);
error(i) = mean(errorRF);
i = i+1;
end

plot(tests/100,error);
ylabel('Error Mean (m)')
xlabel('Inertia_r')
grid on
