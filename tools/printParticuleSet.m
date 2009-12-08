function [] = printParticuleSet(particuleSet,options)

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
end