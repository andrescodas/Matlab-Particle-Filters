covp = [0.0103627681568 0.0068661286895 0.0164752331102 0.00920907680532 0.0137788006366 0.0185557046544];

cov = zeros(3,3);

cov(1,1) = covp(1);
cov(1,2) = covp(2);
cov(2,1) = covp(2);
cov(2,2) = covp(3);
cov(1,3) = covp(4);
cov(3,1) = covp(4);
cov(2,3) = covp(5);
cov(3,2) = covp(5);
cov(3,3) = covp(6);

c = [0,0,0];

Ellipse_plot(cov,c,50)