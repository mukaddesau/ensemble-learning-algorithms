fid = fopen('C:\\Users\\Mukaddes\\Desktop\\arff_files.txt');
directories = textscan(fid,'%s','Delimiter','\n');

ensemble_size = 20; 
% read datasets
for i=1:size(directories{1},1)
%     disp(directories{1,1}(i));
     directory = char(directories{1,1}(i));
     [samples, labels] = arffoku(directory);
     [num_of_samples,num_of_features] = size(samples);
     
      if(mod(num_of_samples,2)==0)
        fold_size = num_of_samples / 2;
      else
        fold_size = floor(num_of_samples / 2);
      end
      
     bagging_pred = zeros(fold_size, 10);
     subspace_pred = zeros(fold_size, 10);
     random_forest_pred = zeros(fold_size, 10);
     single_pred = zeros(fold_size, 10);

k = 1; m = 1, n=1;

% Predict with Bagging and compute accuracy
for j=1:5  

    indices = generate_random_fold(fold_size);
    trainset = samples(indices,:);
    testset = samples(setdiff(1:(fold_size*2),indices(1,:)),:);

    trainset_lbl = labels(indices,:);
    testset_lbl = labels(setdiff(1:(fold_size*2),indices(1,:)),:);

    bagging_pred(:,k) = predict_bagging(ensemble_size,trainset,trainset_lbl,testset,fold_size);
    single_pred(:,k) = predict_single(trainset, trainset_lbl, testset);
    accuracy_bagg(k) = compute_accuracy(bagging_pred(:,k),testset_lbl);
    accuracy_single(k) = compute_accuracy(single_pred(:,k),testset_lbl);
    k = k + 1;
    bagging_pred(:,k) = predict_bagging(ensemble_size,testset,testset_lbl,trainset,fold_size);
    single_pred(:,k) = predict_single(trainset, trainset_lbl, testset);
    accuracy_bagg(k) = compute_accuracy(bagging_pred(:,k),trainset_lbl);
    accuracy_single(k) = compute_accuracy(single_pred(:,k),trainset_lbl);
    k = k + 1;
end
   
% Predict with Random Subspace and  compute accuracy
for l=1:5 
    
    subspace_pred(:,m) = predict_subspace(trainset, trainset_lbl, testset, ensemble_size);
    accuracy_sub(m) = compute_accuracy(subspace_pred(:,m),testset_lbl);
    m = m + 1;
    subspace_pred(:,m) = predict_subspace(testset, testset_lbl, trainset, ensemble_size);
    accuracy_sub(m) = compute_accuracy(subspace_pred(:,m),trainset_lbl);
    m = m + 1;
 

end

% Predict with Random Forest and  compute accuracy
selected_features = round(log2(num_of_features));
for t= 1:5   
        
    random_forest_pred(:,n)  = predict_random_forest(ensemble_size,trainset, trainset_lbl, testset,fold_size,selected_features);
    accuracy_rf(n) = compute_accuracy(random_forest_pred(:,n),testset_lbl);
    n = n + 1;
    random_forest_pred(:,n)  = predict_random_forest(ensemble_size,testset, testset_lbl, trainset,fold_size,selected_features);
    accuracy_rf(n) = compute_accuracy(random_forest_pred(:,n),trainset_lbl);
    n = n + 1;  

end
    
    all_acc_single(i,:) = accuracy_single;
    all_acc_bagg(i,:) = accuracy_bagg;
    all_acc_sub(i,:) = accuracy_sub;
    all_acc_rf(i,:) = accuracy_rf;
    
    dec_acc_bagg =  round(all_acc_bagg,2);
    dec_acc_sub = round(all_acc_sub,2);
    dec_acc_rf = round(all_acc_rf,2);
    
    all_acc_single_mean = mean(all_acc_single,2);
    all_acc_bagg_mean = mean(all_acc_bagg,2);
    all_acc_sub_mean = mean(all_acc_sub,2);
    all_acc_rf_mean = mean(all_acc_rf,2);
    
    dec_all_acc_bagg_mean = round(all_acc_bagg_mean,2); 
    dec_all_acc_sub_mean = round(all_acc_sub_mean,2);
    dec_all_acc_rf_mean = round(all_acc_rf_mean,2);
end
 
% Compare algoritm pairs using t-test
for i=1:20

    [h_bagg_sub(i),p_bagg_sup(i)] = ttest(all_acc_bagg(i,:),all_acc_sub(i,:));
    [h_bagg_rf(i),p_bagg_rf(i)] = ttest(all_acc_bagg(i,:),all_acc_rf(i,:));
    [h_sub_rf(i),p_sub_rf(i)] = ttest(all_acc_sub(i,:),all_acc_rf(i,:));  % 'Alpha',0.05
%     [h1,p1] = ttest2(accuracy_bagg,accuracy_sub)
end

% Choose H1 hypothesis  
coor_diff_bagg_sub =  find(h_bagg_sub == 1);
coor_diff_bagg_rf = find(h_bagg_rf == 1);
coor_diff_sub_rf = find(h_sub_rf == 1);
