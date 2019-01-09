function [bag_prediction] = predict_bagging(ens_size,trainset, labels, testset,fold_size)
% [train_size,col] = size(trainset);

  for i = 1:ens_size
        coors = randi([1 fold_size],fold_size,1);
        ensemble = trainset(coors(:,1),:);        
%         ensemble = sort(ensemble,'ascend');
%         for j = 1:train_size
% %              [~,indices(j)]=ismember(ensemble(j,:),trainset,'rows' );
%              indices=find(ismember(trainset,ensemble(j,:),'rows'));
% 
%         end
%         indices = uint16(indices);
        ens_labels = labels(coors(:,1),1);
        
        Mdl = fitctree(ensemble,ens_labels);
        prediction(:,i) = predict(Mdl,testset);
                
  end   
  bag_prediction = mode(prediction,2);
  
end