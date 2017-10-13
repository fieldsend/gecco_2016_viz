function [Archive,Archive_objectives,samples, samples_objectives, P, Po] = IBEA(pop_size, generations, cost_function, l, num_obj, p_mut, kappa)

% [Archive,Archive_objectives,samples] = ibea(pop_size,archive_size,generations,cost_function,l,num_obj,p_mut,kappa)
%
%
% Implements the adaptive IBEA_epsilon+ algorithm described in 2004 PPSN paper by
% Zitzler and Kunzli
%
% inputs:
% pop_size = number of mmebers in search population
% generations = number of iterations of algorithm
% cost_function = string containing the name of the objective
%   function to optimise, must take as arguments the decision vector
%   followed by the number of objectives, and return an array (1 by
%   D) of the D objectives evaluated
% l = number of decision parameters
% num_obj = number of objectives
% p_mut = probability of mutation, in paper, 0.01 for continous problems
% kappa = discount factor for indicator, 0.05 in paper
%
% Uses simulated binary crossover (20 genes) and assumes legal
% bounds on decision parameters as [ 0, 1 ]
% returns:
%
% Archive = matrix of archive decision vectors
% Archive_objectives = matrix of archive member evaluations
% samples = history of algorithm state in terms of its locations evaluated
% samples_objectives = corresponding objectives
%
% (c) 2013 Jonathan Fieldsend, University of Exeter


if ~exist('p_mut','var')
    p_mut = 0.01;
end
if ~exist('kappa','var')
    kappa = 0.05;
end


P=[];
Po=[];
SBX_n=20;


% INITIALISATION
samples=zeros((generations+1)*pop_size,l);
samples_objectives=zeros((generations+1)*pop_size,num_obj);

%declare archive and associated objective evaluations as empty
% Create random indiviual (Uniform) and evaluate
X = rand(pop_size,l);
Xo = zeros(pop_size,num_obj);
Archive=[];
Archive_objectives=[];
mating_pool = rand(pop_size,l);
off_o = rand(pop_size,num_obj);

for i=1:pop_size
        Xo(i,:) = feval(cost_function,X(i,:),num_obj);
        
        [Archive,Archive_objectives]=update_archive(Archive,Archive_objectives,X(i,:),Xo(i,:));
end
samples(1:pop_size,:) = X;
samples_objectives(1:pop_size,:) = Xo;
sample_index = pop_size+1;

for kk=1:generations % loop for generations
    % FITNESS ASSIGNMENT
    Xo_scaled = rescale_objectives(Xo);
    [fitness,c] = fitness_assignment(Xo_scaled,kappa);

    % ENVIRONMENTAL SELECTION

    while size(X,1)>pop_size
        [~,j] = min(fitness);
        X(j,:) =[];
        ty = Xo_scaled(j,:);
        Xo(j,:) = [];
        Xo_scaled(j,:)=[];
        fitness(j) = [];
        fitness = update_fitness(fitness,Xo_scaled,kappa,ty,c);
    end
    P=X;
    Po=Xo;
        
    % MATING SELECTION
    for j=1:pop_size
        I=randperm(pop_size);
        %binary tournament selection on fitness value with replacement
        if fitness(I(1))<fitness(I(2))
            mating_pool(j,:)=X(I(1),:);
        else
            mating_pool(j,:)=X(I(2),:);
        end            
    end
    
    
    % Variation, SBX-20 operator is used for recombination and a polynomial distribution for mutation
    %CROSSOVER
    offspring = mating_pool;
    for j=1:2:pop_size-1
        for k=1:l
            if rand()<0.5 %0.5 probability of crossing over variable
                valid=0;
                while (valid==0)
                    u=rand();
                    if (u<0.5)
                        beta=(2*u)^(1/(SBX_n+1));
                    else
                        beta=(0.5/(1-u))^(1/(SBX_n+1));
                    end
                    mean_p=0.5*(mating_pool(j,k)+mating_pool(j+1,k));
                    c1=mean_p-0.5*beta*abs(mating_pool(j,k)-mating_pool(j+1,k));
                    c2=mean_p+0.5*beta*abs(mating_pool(j,k)-mating_pool(j+1,k));   
                    if (c1>=0.0 && c1<=1.0) && (c2>=0.0 && c2<=1.0)
                        valid=1;
                    end
                end
                offspring(j,k)=c1;
                offspring(j+1,k)=c2;
            end
        end
    end
    %MUTATION
    for j=1:pop_size
        for k=1:l
            if rand()<p_mut
                y=2;
                while ((y<0) || (y>1.0))
                    r=rand();
                    if r<0.5
                        delta=(2*r)^(1/(SBX_n+1))-1;
                    else
                        delta=1-(2*(1-r))^(1/(SBX_n+1));
                    end
                    y=offspring(j,k)+delta; %range of variables is 1, so just add delta
                end
                offspring(j,k)=y;
            end
        end
    end
    
    
    % add offspring to population 
    for i=1:pop_size
        off_o(i,:) = feval(cost_function,offspring(i,:),num_obj);
        samples(sample_index,:) = offspring(i,:);
        samples_objectives(sample_index,:) = off_o(i,:);
        sample_index = sample_index+1;
        [Archive,Archive_objectives]=update_archive(Archive,Archive_objectives,offspring(i,:),off_o(i,:));
    end
    if rem(kk,10)==0
        fprintf('Iteration %d, Evaluation %d, passive archive %d\n',kk,kk*pop_size+pop_size,size(Archive_objectives,1));
    end
    Xo = [Xo; off_o];
    X = [X; offspring];
end

% % TERMINATION
% I = pareto_front_with_duplicates(Xo);
% Archive = X(I,:);
% Archive_objectives = Xo(I,:);



%----------------------------------------------
function Xo_scaled = rescale_objectives(Xo)

n = size(Xo,1);
upb = max(Xo);
lwb = min(Xo);

Xo_scaled = (Xo-repmat(lwb,n,1))./repmat(upb-lwb,n,1);
%----------------------------------------------
function [fitness,c] = fitness_assignment(Xo,kappa)

[n,~] = size(Xo);
fitness = zeros(n,1);
indicator = zeros(n,n);

for i=1:n
    for j=1:n
        if i~=j
            indicator(i,j) = max(Xo(i,:)-Xo(j,:)); % get shift value
        end
    end
end

c =max(max(indicator));

for j=1:n
    fitness(j) = sum(-exp(-indicator(:,j)/(c*kappa)));
end


%----------------------------------------------
function fitness = update_fitness(fitness,Xo,kappa,old_val,c)

n = size(Xo,1);
for i=1:n
    indicator = max(old_val-Xo(i,:)); % get shift value
    fitness(i) = fitness(i) + exp(-indicator/(c*kappa)); 
end

%%--------------------------------------------------------------------------
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
  

