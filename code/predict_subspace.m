function [sub_prediction] = predict_subspace(trainset, trainset_lbl, testset, ens_size)
    
    for i=1:ens_size
        [trainset_sub, testset_sub] = create_subspace(trainset,testset);        
        prediction(:,i) = predict_single(trainset_sub, trainset_lbl, testset_sub);
        
    end
    sub_prediction = mode(prediction,2);
end