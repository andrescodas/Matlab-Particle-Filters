function [] = plotEvaluations(evaluations,tagId,antenna)
% plotEvaluations(evaluations,tagId,antenna)
%
%
figure
hold all

if (nargin == 1)
    for j = 1:size(evaluations,2)
        plot(evaluations(j).distance*cos(evaluations(j).angleRadians),evaluations(j).distance*sin(evaluations(j).angleRadians),'x');
    end


elseif (nargin == 2)
    title(strcat('Evaluations with tagId == ',tagId))
    for j = 1:size(evaluations,2)
        if (strcmp(evaluations(j).tagId,tagId))
            plot(evaluations(j).distance*cos(evaluations(j).angleRadians),evaluations(j).distance*sin(evaluations(j).angleRadians),'x');
        end
    end
   
    
elseif (nargin == 3)
   
    if (strcmp('',tagId))
        title(strcat('Evaluations from antenna == ',num2str(antenna)))
        for j = 1:size(evaluations,2)
            if (evaluations(j).antenna == antenna)
                plot(evaluations(j).distance*cos(evaluations(j).angleRadians),evaluations(j).distance*sin(evaluations(j).angleRadians),'x');
            end
        end

    else

        title(strcat('Evaluations from antenna == ',num2str(antenna),' and tagId == ',tagId))
        for j = 1:size(evaluations,2)
            if (evaluations(j).antenna == antenna)
                if (strcmp(evaluations(j).tagId,tagId))
                    plot(evaluations(j).distance*cos(evaluations(j).angleRadians),evaluations(j).distance*sin(evaluations(j).angleRadians),'x');
                end
            end
        end
   end
    
    
end