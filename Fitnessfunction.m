function [fitness,best,average,best_sol] = Fitnessfunction(Sol,np)

for i = 1:np
    total_error = 0;
    for c = 1:9
        error_col = length(Sol{i}(:,c)) - length(unique(Sol{i}(:,c)));
        total_error = total_error + error_col;
    end
    
    for rb = 1:3
        for cb = 1:3
            box = Sol{i}(3*rb-2:3*rb,3*cb-2:3*cb);
            error_box = length(box(:)) - length(unique(box));
            total_error = total_error + error_box;
        end
    end
    fitness(i) = total_error;
end

[best,I] = min(fitness);
best_sol = Sol{I};
average = mean(fitness);