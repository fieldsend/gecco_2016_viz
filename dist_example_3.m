function y = dist_example_3(x,d)

if (d~=4)
    error('this is a four objective problem');
end
v1 = [0.8, 3; 2.8, 1; 1.4,3.2; 3.4,1.2]/4.0;
v2 = [1,3.2; 3,1.2; 1.2,2.6; 3.2,0.6]/4.0;
v3 = [1.2,3; 3.2,1; 0.6,2.8; 2.6,0.8]/4.0;
v4 = [1,2.8; 3, 0.8; 0.8,3.4; 2.8,1.4]/4.0;

y(1) = sqrt(min(dist2(x,v1)));
y(2) = sqrt(min(dist2(x,v2)));
y(3) = sqrt(min(dist2(x,v3)));
y(4) = sqrt(min(dist2(x,v4)));
