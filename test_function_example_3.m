function y = test_function_example_3(x,d)

% y = test_function_example_1(x,d)
%
% Example test function from GECCO paper
%
% (c) Jonathan Fieldsend, University of Exeter, 2016

if (d~=4)
    error('this is a four-objective problem');
end
P(1).M = [0.8, 3; 2.8, 1; 1.4,3.2; 3.4,1.2]/4.0;
P(2).M = [1,3.2; 3,1.2; 1.2,2.6; 3.2,0.6]/4.0;
P(3).M = [1.2,3; 3.2,1; 0.6,2.8; 2.6,0.8]/4.0;
P(4).M = [1,2.8; 3, 0.8; 0.8,3.4; 2.8,1.4]/4.0;

y = get_min_Euclidean_distance(x,P,d);