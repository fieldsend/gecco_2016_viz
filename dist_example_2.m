function y = dist_example_2(x,d)

if (d~=3)
    error('this is a three objective problem');
end
v1 = [0.85, 3; 2.85, 1; 0.85, 1; 1.85, 2]/4.0;
v2 = [1.15,3; 3.15,1; 1.15,1; 2.85, 3]/4.0;
v3 = [1.0,3.2598; 3.0,1.2598; 2.15,2; 3.15,3]/4.0;

y(1) = sqrt(min(dist2(x,v1)));
y(2) = sqrt(min(dist2(x,v2)));
y(3) = sqrt(min(dist2(x,v3)));
