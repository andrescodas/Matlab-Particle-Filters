function dist = distanceMatlab(a1,a2)

dist = a1;

for i = 1:length(dist) 
    dist(i) = sqrt(a1(i)^2+a2(i)^2);
end