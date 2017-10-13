function y = get_min_Euclidean_distance(x,P,d)

%  y = get_min_squared_distance(x,P)
%
% x = design vector
% P = structure with 'd' elements, holding matrices M of vectors to
% calculate mimumum distance from for each of the d objectives
% d = number of objectives
%
% uses dist2 function from Netlab toolbox
% 
% (c) Jonathan Fieldsend, University of Exeter, 2016

y = zeros(1,d);
for i=1:d
   y(i) = sqrt(min(dist2(x,P(i).M))); 
end
