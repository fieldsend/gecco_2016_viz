function y = test_function_example_2(x,d)

% y = test_function_example_1(x,d)
%
% Example test function from GECCO paper
%
% (c) Jonathan Fieldsend, University of Exeter, 2016

if (d~=3)
    error('this is a three-objective problem');
end
P(1).M = [0.85, 3; 2.85, 1; 0.85, 1; 1.85, 2]/4.0;
P(2).M = [1.15,3; 3.15,1; 1.15,1; 2.85, 3]/4.0;
P(3).M = [1.0,3.2598; 3.0,1.2598; 2.15,2; 3.15,3]/4.0;

y = get_min_Euclidean_distance(x,P,d);