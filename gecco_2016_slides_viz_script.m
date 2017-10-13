
m=1;
gens(1) = 1000;
gens(2) = 10000;
gens(3) = 100000;
o(1:2) = 3;
o(3:4) = 4;
o(5) = 8;
p_size(1:2) = 150;
p_size(3:4) = 250;
p_size(5) = 500;
res_d_A = zeros(m,1);
res_d_P = zeros(m,1);
res_r_A = zeros(m,1);
res_r_P = zeros(m,1);
%NSGA-II
% for j=3:3
%     for i=3:5
%         for k=2:m
%             k
%             if ((i==1) || (i==3) || (i==5))
%                 % 1 & 2 the same, as are 3 & 4
%                 rng(k); [A,Ao,P,P_objectives,C_objectives,samples] = NSGA2(p_size(i),gens(j),strcat('dist_example_',int2str(i),'_reduced'),2,o(i));
%                 [p_A] = in_pareto_set_distance_problems(i,A);
%                 [p_P] = in_pareto_set_distance_problems(i,P);
%                 res_d_A(k) = p_A;
%                 res_d_P(k) = p_P;
%             end
%             
%             
%             rng(k); [A,Ao,P,P_objectives,C_objectives,samples] = NSGA2(p_size(i),gens(j),strcat('dist_example_',int2str(i)),2,o(i));
%             [p_A] = in_pareto_set_distance_problems(i,A);
%             [p_P] = in_pareto_set_distance_problems(i,P);
%             res_r_A(k) = p_A;
%             res_r_P(k) = p_P;
%             
%         end
%         if ((i==1) || (i==3) || (i==5))
%             % 1 & 2 the same, as are 3 & 4
%             rng('default'); [A,Ao,P,P_objectives,C_objectives,samples] = NSGA2(p_size(i),gens(j),strcat('dist_example_',int2str(i),'_reduced'),2,o(i));
%             [p_A] = in_pareto_set_distance_problems(i,A);
%             [p_P] = in_pareto_set_distance_problems(i,P);
%             res_d_A(1) = p_A;
%             res_d_P(1) = p_P;
%         end
%         rng('default'); [A,Ao,P,P_objectives,C_objectives,samples] = NSGA2(p_size(i),gens(j),strcat('dist_example_',int2str(i)),2,o(i));
%         
%         [prop,p_locs] = in_pareto_set_distance_problems(i,A);
%         res_r_A(1) = prop;
%         plot_gecco_2016( A, strcat('nsga2_p',int2str(i),'_', int2str(gens(j)),'_arc'), res_d_A ,p_locs, res_r_A );
%         
%         [prop,p_locs] = in_pareto_set_distance_problems(i,P);
%         res_r_P(1) = prop;
%         plot_gecco_2016( P, strcat('nsga2_p',int2str(i),'_', int2str(gens(j)),'_search'),res_d_P,p_locs,res_r_P  );
%     end
% end
%IBEA
i=4;
rng('default'); 
[A,Ao,P,P_objectives,C_objectives,samples] = NSGA2(p_size(i),gens(3),strcat('dist_example_',int2str(i)),2,o(i));
%[Archive,Archive_objectives,samples, samples_objectives, P, Po] = IBEA(p_size(i), floor(gens(3)/p_size(i))-1, strcat('dist_example_',int2str(i)), 2, o(i));
