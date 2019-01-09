function [prediction] = predict_single(trainset, labels, testset)

        Mdl = fitctree(trainset,labels);
        prediction = predict(Mdl,testset);
    
  
end