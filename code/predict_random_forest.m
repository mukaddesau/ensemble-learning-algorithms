function [bag_prediction] = predict_random_forest(ens_size,trainset, labels, testset,fold_size,num_of_features)


  for i = 1:ens_size
        coors = randi([1 fold_size],fold_size,1);
        ensemble = trainset(coors(:,1),:);
        ens_labels = labels(coors(:,1),1);
        
        Mdl = fitctree(ensemble,ens_labels,'NumVariablesToSample',num_of_features,'Prune','off','MergeLeaves','off');
        prediction(:,i) = predict(Mdl,testset);
                
  end   
  bag_prediction = mode(prediction,2);
  
end