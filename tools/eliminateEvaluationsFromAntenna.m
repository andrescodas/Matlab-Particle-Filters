function eval = eliminateEvaluationsFromAntenna(evaluations,antenna)

eval = evaluations;
evalCount = 0;
for i = 1:length(evaluations)
	if(evaluations(i).antenna == antenna)
    
    else
        evalCount = evalCount + 1;
        eval(evalCount) = evaluations(i);
	end
end

eval = eval(1:evalCount);