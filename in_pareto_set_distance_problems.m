function [prop,p_locs] = in_pareto_set_distance_problems(p_num,X)

%[prop,p_locs] = in_pareto_set_distance_problems(p_num,X)
%
% function counts the proportions of the designs in X which lie in the
% Pareto set region for the problem (p_num)
%
% returns the proportion of members who are optimal (prop) and their
% corresponding lcoations (p_locs)
%
% Jonathan Fieldsend, University of Exeter, for GECCO 2016 paper

% vectors defining two Pareto set regions for problems 1 & 2
Y1a = [0.85, 3;1.15,3;1.0,3.2598;]/4.0;
Y1b = [2.85, 1;3.15,1; 3.0,1.2598;]/4.0;

% vectors defining two Pareto set regions for problems 3 & 4
Y3a = [0.8, 3;1,3.2;1.2,3;1,2.8;]/4.0;
Y3b = [2.8, 1;3,1.2;3.2,1;3, 0.8;]/4.0;

% vector defining the single Pareto set region for problem 5
Y5 = [0.8, 3; 0.8696, 3.1414; 1,3.2; 1.1414, 3.1414; 1.2,3; 1.1414, 2.8696;1,2.8;0.8696, 2.8696]/4.0;

if p_num<3
    IN1 = inpolygon(X(:,1),X(:,2),Y1a(:,1),Y1a(:,2));
    IN2 = inpolygon(X(:,1),X(:,2),Y1b(:,1),Y1b(:,2));
    prop = (sum(IN1)+sum(IN2))/size(X,1);
    p_locs = (IN1 | IN2);
elseif p_num <5
    IN1 = inpolygon(X(:,1),X(:,2),Y3a(:,1),Y3a(:,2));
    IN2 = inpolygon(X(:,1),X(:,2),Y3b(:,1),Y3b(:,2));
    prop = (sum(IN1)+sum(IN2))/size(X,1);
    p_locs = (IN1 | IN2);
else
    IN = inpolygon(X(:,1),X(:,2),Y5(:,1),Y5(:,2));
    prop = sum(IN)/size(X,1);
    p_locs = IN;
end
