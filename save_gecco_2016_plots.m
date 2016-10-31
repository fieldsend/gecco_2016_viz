function save_gecco_2016_plots(name, gens, Archive, P, problem_index)

% save_gecco_2016_plots(name, gens, Archive, P, problem_index)
%
% Processed passive archive and search population data for visualisation
%
% name = string containing name to use at start of eps figure filename
% (e.g. 'nsga2_'
% gens = number of generations data is for (will be in saved filename)
% Archive = design locations of non-dominated solutions identified by end
% of corresponding generation
% P = design location of serach population at end of corresponding
% generation
% problem_index = index of problem (used in GECCO paper)
%
% Jonathan Fieldsend, University of Exeter, for GECCO 2016 paper

[prop,p_locs] = in_pareto_set_distance_problems(problem_index,Archive);
res_r_A(1) = prop;
plot_gecco_2016_only_dr( Archive, strcat(name,int2str(problem_index),'_', int2str(gens),'_arc'),p_locs , res_r_A );
        
[prop,p_locs] = in_pareto_set_distance_problems(problem_index,P);
res_r_P(1) = prop;
plot_gecco_2016_only_dr( P, strcat(name,int2str(problem_index),'_', int2str(gens),'_search'),p_locs ,res_r_P );


