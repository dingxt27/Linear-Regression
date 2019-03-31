clc
clear all;
%read auto-mpg.data in access and convert it to csv, load data auto-mpg.csv
% %column by column and concatenate them into A
% A  = [Column1 Column2 Column3 Column4 Column5 Column6 Column7 Column8];
% %the real output
% t = A(:,1);
load ('A.mat');

X_all = A;
%normalize the whole dataset with zero mean and unit var
for d = 1:8
    X_norm(:,d) = (X_all(:,d)-mean(X_all(:,d)))./std(X_all(:,d));
end
 data_train = X_norm(1:100,:);
 
 numBasisF = 90;

lambda = [0,0.01,0.1,1,10,100,1000];

error_val = zeros(10,size(lambda,2));
error_train = zeros(10,size(lambda,2));
for i =1:size(lambda,2)
    groups = crossvalind('Kfold', 100, 10);
    k = randperm(numBasisF); 
    numFeat = 7;
    mui = zeros(numBasisF,numFeat);
      
    for j = 1:10 %1 10 validation data

        data_train1 = data_train(find(groups~=j),:);
        data_val = data_train(find(groups == j),:);
        
        for n = 1:numBasisF
          mui(n,:) = data_train1(k(n),2:end);
        end
        
        %get Fi_sudo, and calculate W for each lambda
        [Fi,Fi_sudo] = calculateW (numBasisF,data_train1(:,2:end),mui,lambda(i));
        W = Fi_sudo*data_train1(:,1);%X_norm(j+10:100,1);
        y_est_train  = Fi*W;

        %get Fi for validation dataset, and calculate estimated y for val_dataset
        [Fi_val,Fi_sudo_val] = calculateW (numBasisF,data_val(:,2:end),mui,lambda(i));
        y_est_val = Fi_val*W;

        
        %validation error
        error_val(j,i) = sqrt(mean((y_est_val-data_val(:,1)).^2));
        error_train(j,i) = sqrt(mean((y_est_train-data_train1(:,1)).^2));
    %end
    end
    
end

avg_error_val = zeros(1,7);
avg_error_train = zeros(1,7);
for m=1:7
    avg_error_val(m)= mean(error_val(:,m));
    avg_error_train(m) = mean(error_train(:,m));
end


 semilogx(lambda,avg_error_train,'b')
 hold on
 semilogx(lambda,avg_error_val,'r')
 legend({'error_train','error_test'},'Location','northwest')
 
[min_error_val,I] = min(avg_error_val);
opt_lambda = lambda(I);





