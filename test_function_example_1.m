function y = test_function_example_1(x,d)

% y = test_function_example_1(x,d)
%
% Example test function from GECCO paper
%
% (c) Jonathan Fieldsend, University of Exeter, 2016

if (d~=3)
    error('this is a three objective problem');
end
P(1).M = [0.85, 3; 2.85, 1; 1.45,3; 3.45,1]/4.0;
P(2).M = [1.15,3; 3.15,1; 1,3.5598; 3,1.5598]/4.0;
P(3).M = [1.0,3.2598; 3.0,1.2598; 0.5,3; 2.5,1]/4.0;

y = get_min_Euclidean_distance(x,P,d);