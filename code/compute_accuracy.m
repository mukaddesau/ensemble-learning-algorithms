function [accuracy] = compute_accuracy(prediction, test_label)

accuracy_mat =(prediction == test_label);
sum_acc = sum(accuracy_mat(:) == 1);
sum_wrong = sum(accuracy_mat(:) == 0);

accuracy = sum_acc / (sum_acc + sum_wrong);

end