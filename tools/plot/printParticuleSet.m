function [] = printParticuleSet(particuleSet,options,stepDistance)

if nargin < 2

    for i = 1:length(particuleSet)
        if (particuleSet(i).weight > 0)
            plot(particuleSet(i).position(1),particuleSet(i).position(2),'b.');
            hold all;
        end
   

    end

elseif nargin < 3

    hold all


    for i = 1:length(particuleSet)
        if (particuleSet(i).weight > 0)
            plot(particuleSet(i).position(1),particuleSet(i).position(2),options);
        end

    end


elseif nargin < 4

    
    xiMax = -inf;
    yiMax = -inf;
    
    for i = 1:length(particuleSet)

        xiMax = max(abs(round(particuleSet(i).position(1)/stepDistance)),xiMax);
        yiMax = max(abs(round(particuleSet(i).position(2)/stepDistance)),yiMax);

    end

    plotMatrix = zeros(2*xiMax+1,2*yiMax+1);

    
    for i = 1:length(particuleSet)
        
        
        xi = round(particuleSet(i).position(1)/stepDistance) + xiMax+ 1  ;
        yi = round(particuleSet(i).position(2)/stepDistance) + yiMax+ 1  ;

        plotMatrix(xi,yi) = plotMatrix(xi,yi) + particuleSet(i).weight;

    end
    
    surf((-xiMax:xiMax)*stepDistance,(-yiMax:yiMax)*stepDistance,plotMatrix');
    
end
grid on

position = estimateTagPosition(particuleSet);
plot(position(1),position(2),'o')