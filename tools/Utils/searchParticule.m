function topIndex = searchParticule(particuleSet,aleatoryNumber)

bottomIndex = 1;
topIndex = length(particuleSet);

if( aleatoryNumber < particuleSet(1).weight)
    topIndex = 1;
    return
end

if( aleatoryNumber > particuleSet(topIndex).weight )
    warning('Bad top index');
    return
end


while(topIndex - bottomIndex > 1)
    currentIndex = floor((topIndex + bottomIndex)/2);

    if(particuleSet(currentIndex).weight < aleatoryNumber);
        bottomIndex = currentIndex;
    else
        topIndex = currentIndex;
    end
end
