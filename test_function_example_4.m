function y = test_function_example_4(x,d)

% y = test_function_example_1(x,d)
%
% Example test function from GECCO paper
%
% (c) Jonathan Fieldsend, University of Exeter, 2016

if (d~=4)
    error('this is a four-objective problem');
end
P(1).M = [0.8, 3; 2.8, 1; 0.3, 0.5; 2.3,2.5; 3.3 3.5]/4.0;
P(2).M = [1, 3.2; 3,1.2; 1.5,1.7; 2.5, 2.7; 3.5 3.7]/4.0;
P(3).M = [1.2, 3; 3.2,1; 0.7 0.5; 1.7 1.5; 2.7 2.5]/4.0;
P(4).M = [1, 2.8; 3, 0.8; 0.5 0.3; 1.5 1.3; 3.5 3.3]/4.0;

y = get_min_Euclidean_distance(x,P,d);