close all, clear all, clc

tic
np = 50;   %number of population
ng = 100;   %number of generation
Pc = 0.9;   %crossover probability
Pm = 0.02;  %mutation probability

x = xlsread('Sudoku','D2:L10');

n = 1:9;
for i = 1:9
    y = x(i,:);         %extract row from question
    p = setdiff(n,y);   %possible numbers in the row
    slot = isnan(y);    %slot to fill in number
    for j = 1:np
        S = p(randperm(length(p))); %randomly order possible numbers
        y(slot) = S;                %fill in empty slot
        Sol{j}(i,:) = y;
    end
end

[fitness,best,average,best_sol] = Fitnessfunction(Sol,np);

for k = 1:ng
    for j = 1:np
        %mutation
        if rand < Pm
            for r = 1:9
                mutation = Sol{j}(r,isnan(x(r,:)));
                m = randperm(length(mutation),2);
                mutation(m) = mutation(fliplr(m));
                Sol{j}(r,isnan(x(r,:))) = mutation;
            end
        end
        
        index = false(9);
        %determine the index of repeated numbers in 3x3 subgrid
        for rb = 1:3
            for cb = 1:3
                subgrid = Sol{j}(3*rb-2:3*rb,3*cb-2:3*cb);
                num = unique(subgrid);
                n = histc(subgrid(:),num);
                position = find(ismember(subgrid(:),(num(n>1))));
                index_sub = false(3);
                index_sub(position) = true;
                index(3*rb-2:3*rb,3*cb-2:3*cb) = index_sub;
            end
        end
        
        %determine the index of repeated numbers in row
        for c = 1:9
            col = Sol{j}(:,c);
            num = unique(col);
            n = histc(col,num);
            position = find(ismember(col,num(n>1)));
            index(position,c) = true;
            
            %excluding the index of question
            index(~isnan(x(:,c)),c) = false;
        end
        
        %crossover
        for r = 1:9
            if rand < Pc
                cross = Sol{j}(r,index(r,:));
                Sol{j}(r,index(r,:)) = cross(randperm(length(cross)));
            end
        end
    end
    
    [fitness,best,average,best_sol] = Fitnessfunction(Sol,np);
    Best_Solution{k} = best_sol;
    Best_fitness(k) = best;
    Average_fitness(k) = average;
end

plot(1:ng,Best_fitness,1:ng,Average_fitness);
legend('Best fitness','Average fitness');
xlabel('Number of generation');
ylabel('Fitness/Number of errors');

[l,choice] = min(Best_fitness);
Answer = Best_Solution{choice}
toc