function y = dist_example_4(x,d)

if (d~=4)
    error('this is a four objective problem');
end
v1 = [0.8, 3; 2.8, 1; 0.3, 0.5; 2.3,2.5; 3.3 3.5]/4.0;
v2 = [1, 3.2; 3,1.2; 1.5,1.7; 2.5, 2.7; 3.5 3.7]/4.0;
v3 = [1.2, 3; 3.2,1; 0.7 0.5; 1.7 1.5; 2.7 2.5]/4.0;
v4 = [1, 2.8; 3, 0.8; 0.5 0.3; 1.5 1.3; 3.5 3.3]/4.0;

y(1) = sqrt(min(dist2(x,v1)));
y(2) = sqrt(min(dist2(x,v2)));
y(3) = sqrt(min(dist2(x,v3)));
y(4) = sqrt(min(dist2(x,v4)));
