function y = dist_example_2_reduced(x,d)

if (d~=3)
    error('this is a three objective problem');
end
v1 = [0.85, 3; 2.85, 1; ]/4.0;
v2 = [1.15,3; 3.15,1; ]/4.0;
v3 = [1.0,3.2598; 3.0,1.2598; ]/4.0;

y(1) = sqrt(min(dist2(x,v1)));
y(2) = sqrt(min(dist2(x,v2)));
y(3) = sqrt(min(dist2(x,v3)));
