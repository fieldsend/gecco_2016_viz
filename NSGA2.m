function [A,Ao,P,P_objectives,C_objectives,samples] = NSGA2(pop_size,evaluations,cost_function,l,num_obj,p_ensure,history_flag)
  
  %[A,Ao] =
  % NSGA2(pop_size,evaluations,cost_function,l,num_obj)
  %
  % popsize = population size
  % evaluations = total number of function evaluations
  % cost_function = string containing name of function to be optimised
  % l = number of continuous decision params (assumes valid range is (0,1))
  % num_obj = number of objectives
  % history_flag = pass flag in if complete state tracked at each
  %                generation -- expensive in memory and will slow down alg 
  %
  % Jonathan Fieldsend, University of Exeter, 4/9/2013, based upon
  % description in Coello et al textbook, 2007
  %
  % Ammended for GECCO 2016 paper
  
  if exist('p_ensure','var')==0
    p_ensure=0;
  end
  samples=[];
  % Create 'mu' random indiviuals (Uniform) and evaluate 
  P = rand(pop_size,l);
  if (p_ensure==1) %special situation for real valued permutation mapping
      P = ensure_permutation_uniqueness(P);
  end
  P_objectives = zeros(pop_size,num_obj);
  for i=1:pop_size
      P_objectives(i,:) = feval(cost_function,P(i,:),num_obj);
  end
  % Get shell index of initial population 
  [P_ranks] = recursive_pareto_shell_with_duplicates(P_objectives,0);
  
  
  % In the case of the first iteration, solutions with rank 0 
  % are the estimated Pareto front
  I = find(P_ranks==0);
  A = P(I,:);
  Ao = P_objectives(I,:);
  
  % make child population
  C = binary_tournament_selection(P,P_ranks);
  C = variation(C);
  C_objectives = zeros(pop_size,num_obj);
  if (p_ensure==1) %special situation for real valued permutation mapping
      C = ensure_permutation_uniqueness(C);
  end
  for i=1:pop_size
     C_objectives(i,:)=feval(cost_function,C(i,:),num_obj);
     [A,Ao]=update_archive(A,Ao,C(i,:),C_objectives(i,:)); %update passive archive
  end
  %initalise evaluation counter and print counter
  num_evaluations = pop_size*2;
  print_counter = num_evaluations;
  %Iterate until number of evalutions reaches maximium
  gen=1;
  while (num_evaluations<evaluations)
      
      combined_pop = [P; C];
      combined_obj = [P_objectives; C_objectives];
      combined_ranks = recursive_pareto_shell_with_duplicates(combined_obj,0);
     
      rank_index = 0;
      old_size=0;
      % keep adding shells until cannot add anymore with extending beyond
      % population limits
      P=[];
      P_ranks=[];
      P_objectives=[];
      while (size(P,1) <pop_size)
         old_size = size(P,1); % keep track of how big before spills over
         P = [P; combined_pop(combined_ranks==rank_index,:)]; 
         P_ranks = [P_ranks; combined_ranks(combined_ranks==rank_index,:)];
         P_objectives = [P_objectives; combined_obj(combined_ranks==rank_index,:)]; 
         distances = calc_crowding_dist(P_objectives);
         rank_index = rank_index+1;
      end
      % fill remaining elements by sampling from the rank_index shell
      % according to crowding distances
      if (size(P,1)>pop_size)
          remove_number = size(P,1)-pop_size;
          % have to many, so sort based first on rank, and then on
          % distance, as we have an index into last shell added we can
          % simply focus on these though :)
          curr_pop_len = size(P,1);
          
          [~, I_rem] = sort(distances(old_size+1:curr_pop_len));
          % I_rem gives indices of those to remove from smallest to largest
          % of the last shell added, need to shift index by previous shells
          % added though
          I_rem = I_rem + old_size;
          P(I_rem(1:remove_number),:)=[];
          P_ranks(I_rem(1:remove_number))=[];
          P_objectives(I_rem(1:remove_number),:)=[];
      end
      
      C = binary_tournament_selection(P,P_ranks);
      C = variation(C);
      % special situation for real valued permutation mapping
      if (p_ensure==1)
        C = ensure_permutation_uniqueness(C);
      end
      for i=1:pop_size
        C_objectives(i,:)=feval(cost_function,C(i,:),num_obj);
        [A,Ao]=update_archive(A,Ao,C(i,:),C_objectives(i,:)); %update passive archive
      end
      
      num_evaluations = num_evaluations+pop_size;
      
      print_counter = print_counter + pop_size;
      if (print_counter >= 1000)
        fprintf('Evaluations %d, Archive size %d \n', num_evaluations, size(A,1));
        print_counter = print_counter - 1000;
      end
      
      % track passive archive and total search population (before trimming) 
      % at end of each generation
      if exist('hisory_flag','var')
        samples{gen,1} = A;
        samples{gen,2} = Ao;
        samples{gen,3} = [P; C];
        samples{gen,4} = [P_objectives; C_objectives];
      end
      gen = gen+1;
  end
%--------------------------------------------------------------------------
function C = binary_tournament_selection(P,P_ranks)

[n,m] = size(P);
C = zeros(n,m);
for i=1:n
    k = randperm(n);
    j = randperm(n);
    if P_ranks(k(1))<P_ranks(j(1))
        C(i,:) = P(k(1),:);
    else
        C(i,:) = P(j(1),:);
    end
end

%--------------------------------------------------------------------------
function  C=variation(P)

[n,m] = size(P);
C = P;
SBX_n=20;
p_xover =0.8;
mutation_width =0.1;
for i=1:n % for each member of C
    if (rand()<p_xover) % 80% chance of crossover
        T1=zeros(1,m);
        T2=zeros(1,m);
        other_parent = randperm(n);
        if other_parent(1)==i
            other_parent(1) = other_parent(end); % should crossover with itself
        end
        for k=1:m
            if rand()<0.5 % probability of crossing over variable
                valid=0;
                while (valid==0)
                    u=rand();
                    if (u<0.5)
                        beta=(2*u)^(1/(SBX_n+1));
                    else
                        beta=(0.5/(1-u))^(1/(SBX_n+1));
                    end
                    mean_p=0.5*(P(i,k)+P(other_parent(1),k));
                    c1=mean_p-0.5*beta*abs(P(i,k)-P(other_parent(1),k));
                    c2=mean_p+0.5*beta*abs(P(i,k)-P(other_parent(1),k));
                    if (c1>=0.0 && c1<=1.0) && (c2>=0.0 && c2<=1.0)
                        valid=1;
                    end
                end
                T1(1,k)=c1;
                T2(1,k)=c2;
            end
        end
        if rand()<0.5
            C(i,:)=T1;
        else
            C(i,:)=T2;
        end
    end
    I =randperm(m);
    r = -1;
    while (r<0) || (r>1)
        r=C(i,I(1))+randn()*mutation_width;
    end
    
    C(i,I(1)) = r;
end


%--------------------------------------------------------------------------
function distances = calc_crowding_dist(X)

[n,m] = size(X);
distances = zeros(n,1);
for j=1:m
   [~,Im] = sort(X); % get index of sorted solutions on each dimension
   distances(Im(1)) = inf;
   distances(Im(end)) = inf;
   for i=2:n-1
      distances(Im(i)) = distances(Im(i)) + (X(Im(i+1),j)-X(Im(i-1),j)); 
   end
end


%--------------------------------------------------------------------------
function [A,Ao]=update_archive(A,Ao,x,objs)
  % Inserts x into archive if not weakly dominated by members, and removes 
  % any dominated members from archive      
  [num,num_obj] = size(Ao);
  dominating = zeros(num,1); % count dominating archive members 
  for i=1:num_obj
    dominating = dominating + (Ao(:,i)<=objs(i));
  end;
  I=find(dominating==num_obj);  % indices of dominating elements of archive
  if (length(I)==0)             % nothing dominates in current archive
    dominated = zeros(num,1);   % count dominated archive members
    for i=1:num_obj
        dominated = dominated + (Ao(:,i)>=objs(i));
    end
    I=find(dominated==num_obj); % find and remove dominated archive members
    A(I,:)=[];
    Ao(I,:)=[];
    A=[A; x];                   % insert new archive member
    Ao=[Ao; objs];
  end
%--------------------------------------------------------------------------
%function x=dominates(u,v,num_obj)
%  % Returns 1 if u dominates v, 0 otherwise
%  x = 0;
%  wd = sum(u<=v);
%  d = sum(u<v);
%  if ((wd==num_obj) && (d>0))
%    x = 1;
%  end
%--------------------------------------------------------------------------
function P = ensure_permutation_uniqueness(P)

% if the real values re placeholders for permutations (gained by sorting)
% want to ensure there are no repititions
[~,m]= size(P);

[~, II] = sort(P,2);
P = II/m;

