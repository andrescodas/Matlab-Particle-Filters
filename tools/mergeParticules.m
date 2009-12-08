function newParticuleSet = mergeParticules(set1,weightSet1,set2,weightSet2)

if(size(set1,1)*size(set1,2) == 0)
    newParticuleSet = set2;
elseif(size(set2,1)*size(set2,2) == 0)
    newParticuleSet = set1;
else
    newSet1 = scaleParticuleSet(set1,weightSet1);
    newSet2 = scaleParticuleSet(set2,weightSet2);
    
    newParticuleSet = [newSet1 newSet2];
end