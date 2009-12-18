function newParticuleSet = cumulativeWeights(particuleSet)

newParticuleSet = particuleSet;

sum = 0;
for j = 1:length(particuleSet)

    sum = sum + particuleSet(j).weight;
    newParticuleSet(j).weight = sum;

end

if(abs(sum-1) > 10^-10)
    warning(strcat('ParticulesWeight sum up to == ',num2str(sum)));
end