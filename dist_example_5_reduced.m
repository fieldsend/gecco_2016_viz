function y = dist_example_5_reduced(x,d)

if (d~=8)
    error('this is a four objective problem');
end
v1 = [0.8, 3 ]/4.0;
v2 = [0.8696, 3.1414 ]/4.0;
v3 = [1,3.2 ]/4.0;
v4 = [1.1414, 3.1414 ]/4.0;
v5 = [1.2,3]/4.0;
v6 = [1.1414, 2.8696 ]/4.0;
v7 = [1,2.8 ]/4.0;
v8 = [0.8696, 2.8696]/4.0;

y(1) = sqrt(min(dist2(x,v1)));
y(2) = sqrt(min(dist2(x,v2)));
y(3) = sqrt(min(dist2(x,v3)));
y(4) = sqrt(min(dist2(x,v4)));
y(5) = sqrt(min(dist2(x,v5)));
y(6) = sqrt(min(dist2(x,v6)));
y(7) = sqrt(min(dist2(x,v7)));
y(8) = sqrt(min(dist2(x,v8)));