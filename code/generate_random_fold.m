function [indices,r] = generate_random_fold(fold_size)
  
    indices = randperm(2*fold_size,fold_size);
    
end