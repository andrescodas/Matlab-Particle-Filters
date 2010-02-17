close all
clear all;
figure(1)

[positionsXM,positionsYM,positionsTM] = readPositionFile('/home/andres/simulation/mocapPositionSet.txt');

%positionsXMD = positionsXM - [0 positionsXM(1:(length((positionsXM))-1))];
%positionsYMD = positionsYM - [0 positionsYM(1:(length((positionsYM))-1))];
%positionsTMD = positionsTM - [0 positionsTM(1:(length((positionsTM))-1))];

    subplot(3,1,1)
    hold off
    plot(positionsXM,positionsYM,'h',positionsXM,positionsYM)
    xlim([-1.5 3])
    hold all

[positionsXO,positionsYO,positionsTO] = readPositionFile('/home/andres/simulation/rflexPositionSet.txt');

    grid
    subplot(3,1,2)
    plot(positionsXO,positionsYO,'o',positionsXO,positionsYO)
    grid
    
%positionsXOD = positionsXO - [0 positionsXO(1:(length((positionsXO))-1))];
%positionsYOD = positionsYO - [0 positionsYO(1:(length((positionsYO))-1))];
%positionsTOD = positionsTO - [0 positionsTO(1:(length((positionsTO))-1))];


[positionsXRF,positionsYRF,positionsTRF] = readPositionFile('rfidPositionSet.txt');

    
    subplot(3,1,3)
    plot(positionsXRF,positionsYRF,'h',positionsXRF,positionsYRF)
    grid
%    
%positionsXRFD = positionsXRF - [0 positionsXRF(1:(length((positionsXRF))-1))];
%positionsYRFD = positionsYRF - [0 positionsYRF(1:(length((positionsYRF))-1))];
%positionsTRFD = positionsTRF - [0 positionsTRF(1:(length((positionsTRF))-1))];


errorO = distanceMatlab(positionsXO-positionsXM,positionsYO-positionsYM);
errorRF = distanceMatlab(positionsXRF-positionsXM,positionsYRF-positionsYM);




    figure(2)
    hold off
    plot(errorO,'o')
    hold all
    plot(errorRF,'h')
    plot(errorO)
    plot(errorRF)
    grid
    title('Error Comparison respect to Motion Capture System ')
    xlabel('Iteration Step')
    ylabel('Absolute error (m)')
    legend('Odometry','Odometry-RFID')    
    
    figure(3)
    subplot(3,2,1)
    hold off
    plot(positionsXO-positionsXM,'o')
    hold all
    plot(positionsXO-positionsXM)
    plot(positionsXRF-positionsXM,'h')
    plot(positionsXRF-positionsXM)
    grid

    subplot(3,2,2)
    hold off
    plot(abs(positionsXO-positionsXM),'o')
    hold all
    plot(abs(positionsXO-positionsXM))
    plot(abs(positionsXRF-positionsXM),'h')
    plot(abs(positionsXRF-positionsXM))
    grid

    subplot(3,2,3)
    hold off
    plot(positionsYO-positionsYM,'o')
    hold all
    plot(positionsYRF-positionsYM,'h')
    plot(positionsYO-positionsYM)
    plot(positionsYRF-positionsYM)
    grid
    
    
    subplot(3,2,4)
    hold off
    plot(abs(positionsYO-positionsYM),'o')
    hold all
    plot(abs(positionsYO-positionsYM))
    plot(abs(positionsYRF-positionsYM),'h')
    plot(abs(positionsYRF-positionsYM))
    grid
    
    subplot(3,2,5)
    hold off
    plot(180/pi*angleWrap(positionsTO-positionsTM),'o')
    hold all
    plot(180/pi*angleWrap(positionsTO-positionsTM))
    plot(180/pi*angleWrap(positionsTRF-positionsTM),'h')
    plot(180/pi*angleWrap(positionsTRF-positionsTM))
    grid
    
    subplot(3,2,6)
    hold off
    plot(abs(180/pi*angleWrap(positionsTO-positionsTM)),'o')
    hold all
    plot(abs(180/pi*angleWrap(positionsTRF-positionsTM)),'h')
    plot(abs(180/pi*angleWrap(positionsTO-positionsTM)))
    plot(abs(180/pi*angleWrap(positionsTRF-positionsTM)))
    grid

    title('Error Comparison respect to Motion Capture System ')
    xlabel('Iteration Step')
    ylabel('Absolute angle error (degree)')
    legend('Odometry','Odometry-RFID')


    
[positionsXT,positionsYT] = readTagPositionFile('tagPositionSet.txt');

tagRealPos = [1.5 0.5];

figure
plot(positionsXT,positionsYT,tagRealPos(1),tagRealPos(2),'k*')

title('Tag position Estimation')
xlabel('position (m)')
ylabel('position (m)')
legend('Estimations','Real Position')
grid on

figure
tagErrorX = positionsXT - tagRealPos(1)*ones(size(positionsXT));
tagErrorY = positionsYT - tagRealPos(2)*ones(size(positionsYT));
errorTag = distanceMatlab(tagErrorX,tagErrorY);
plot(errorTag);
title('Absolute error Tag')
xlabel('Iteration Step')
ylabel('Distance Between Real Position and Estimated Position (m)')
grid on
    

cond = input('Plot Robot Frames (1/0)');
if( cond == 1 )

minX = inf;
maxX = -inf;

minY = inf;
maxY = -inf;

numToPlot = inf;

i = 1;
file =strcat('Robotmovement',num2str(i),'.m');
fid = fopen(file);
while(fid ~= -1)
    fclose(fid);
    simulations = [];
    file =strcat('Robotmovement',num2str(i));
    eval(file);

    minX = min(min(simulations.pos(:,1)),minX);
    maxX = max(max(simulations.pos(:,1)),maxX);

    minY = min(min(simulations.pos(:,2)),minY);
    maxY = max(max(simulations.pos(:,2)),maxY);

    simulations = [];
    file =strcat('Robotresampled',num2str(i));
    eval(file);

    minX = min(min(simulations.pos(:,1)),minX);
    maxX = max(max(simulations.pos(:,1)),maxX);

    minY = min(min(simulations.pos(:,2)),minY);
    maxY = max(max(simulations.pos(:,2)),maxY);
    
    i = i+1;
    file =strcat('Robotmovement',num2str(i),'.m');
    fid = fopen(file);
end

numberOfFiles = i-1;

figure(1);
f = getframe;
frames = repmat(f,1,numberOfFiles);

        
   figure()
    for i = 1:numberOfFiles

        % input(strcat('Step = ',num2str(i),' Plot initStep?'))

        


        hold off
        simulations = [];
        file =strcat('RobotinitStep',num2str(i));
        eval(file);
        initStep = simulations;
        for j = 1:min(size(simulations(1).pos,1),numToPlot)
            plot(simulations(1).pos(j,1),simulations(1).pos(j,2),'b.');
            hold all
            %%[u,v] = pol2cart(simulations.pos(i,3),0.01);
            %%quiver(simulations(1).pos(j,1),simulations(1).pos(j,2),u,v,'b');
        end
        xlim([minX,maxX]);
        ylim([minY,maxY]);
        grid
        % input(strcat('Step = ',num2str(i),'Plot afterOdometry?'))

        simulations = [];
        file =strcat('Robotmovement',num2str(i));
        eval(file);
        for j = 1:min(size(simulations(1).pos,1),numToPlot)
            plot(simulations(1).pos(j,1),simulations(1).pos(j,2),'ko');
            %%[u,v] = pol2cart(simulations.pos(i,3),0.01);
            %%quiver(simulations(1).pos(j,1),simulations(1).pos(j,2),u,v,'k');
        end



        file =strcat('Robotweighted',num2str(i));
        eval(file);

        sumWeights = sum(particules.pos(:,4));
        display(strcat('Sum of weights == ',num2str(sumWeights)));
        weightPos = particules.pos;

        file =strcat('Robotnormalized',num2str(i));
        eval(file);

             for j = 1:size(simulations(1).pos,1)
        
                 if(particules.pos(j,1:3) ~= weightPos(j,1:3))
                     warining('not same particule')
                 elseif(sumWeights == 0)
        
                 elseif(abs(particules.pos(j,4)-weightPos(j,4)/sumWeights) > 10^-5 )
                     display(strcat('notWell weighted == ',num2str(abs(particules.pos(j,4)-weightPos(j,4)/sumWeights))))
                     display(strcat('set == ',num2str(i)))
                     %warning('notWell weighted')
                 else
                    %display(strcat(num2str(i),' sum weights ~= 0'));
        
                 end
             end

        %     input(strcat('Step = ',num2str(i),'Plot afterResample?'))

        simulations = [];
        file =strcat('Robotresampled',num2str(i));
        eval(file);
        for j = 1:min(size(simulations(1).pos,1),numToPlot)
            plot(simulations(1).pos(j,1),simulations(1).pos(j,2),'r*');
            %%[u,v] = pol2cart(simulations.pos(i,3),0.01);
            %%quiver(simulations(1).pos(j,1),simulations(1).pos(j,2),u,v,'r');
        end
        covMatrix = cov(particules.pos(:,1:2));
        meanParticles = mean(particules.pos(:,1:2));
        error_ellipse(covMatrix,meanParticles,'conf',0.99)
        plot(positionsXM(i),positionsYM(i),'gd');
        

        frames(i) = getframe;

    end
    cond = input('Save frames (1/0)');
    if( cond == 1 )
        save framesRobot frames
    end

end

cond = input('Plot Tag Frames (1/0)');

if( cond == 1 )

 tagPositions = [];   
    
minX = inf;
maxX = -inf;

minY = inf;
maxY = -inf;

numToPlot = inf;

i = 2;
file =strcat('Tagresampled',num2str(i),'.m');
fid = fopen(file);
while(fid ~= -1)
    fclose(fid);
    simulations = [];
    file =strcat('Tagresampled',num2str(i));
    eval(file);

    minX = min(min(simulations.pos(:,1)),minX);
    maxX = max(max(simulations.pos(:,1)),maxX);

    minY = min(min(simulations.pos(:,2)),minY);
    maxY = max(max(simulations.pos(:,2)),maxY);
    
    i = i+1;
    file =strcat('Tagresampled',num2str(i),'.m');
    fid = fopen(file);
end

numberOfFiles = i-1;

figure();
f = getframe;
frames = repmat(f,1,numberOfFiles);


    for i = 2:numberOfFiles

        % input(strcat('Step = ',num2str(i),' Plot initStep?'))

        hold off
        simulations = [];
        file =strcat('TaginitStep',num2str(i));
        eval(file);
        initStep = simulations;
        for j = 1:min(size(simulations(1).pos,1),numToPlot)
            plot(simulations(1).pos(j,1),simulations(1).pos(j,2),'b.');
            hold all
            %%[u,v] = pol2cart(simulations.pos(i,3),0.01);
            %%quiver(simulations(1).pos(j,1),simulations(1).pos(j,2),u,v,'b');
        end
        xlim([minX,maxX]);
        ylim([minY,maxY]);
        grid
        % input(strcat('Step = ',num2str(i),'Plot afterOdometry?'))



        file =strcat('Tagweighted',num2str(i));
        eval(file);

        sumWeights = sum(particules.pos(:,3));
       
        if( (sumWeights - 1) > 0.0000001 )
              display(strcat('Sum of weights == ',num2str(sumWeights)));
        end
        plot(particules.pos(:,3)'*particules.pos(:,1),particules.pos(:,3)'*particules.pos(:,2),'ok')
        simulations = [];
        file =strcat('Tagresampled',num2str(i));
        eval(file);
        for j = 1:min(size(simulations(1).pos,1),numToPlot)
            plot(simulations(1).pos(j,1),simulations(1).pos(j,2),'r*');
            %%[u,v] = pol2cart(simulations.pos(i,3),0.01);
            %%quiver(simulations(1).pos(j,1),simulations(1).pos(j,2),u,v,'r');
        end

        tp = [particules.pos(:,3)'*particules.pos(:,1),particules.pos(:,3)'*particules.pos(:,2)];
        
        plot(tp(1),tp(2),'*k')
        tagPositions = [tagPositions;tp];
        
        plot(positionsXM(i),positionsYM(i),'gd');
        

        frames(i) = getframe;

    end
    cond = input('Save Tag frames (1/0)');
    if( cond == 1 )
        save framesTag frames
    end

end

fclose('all')