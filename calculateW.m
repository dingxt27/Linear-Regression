%this function calculate the pseudo-inverse of Fi
function  [Fi,Fi_sudo] = calculateW (numBasisF,X,mui,lambda)

Fi = zeros(size(X,1),numBasisF);

for m=1:numBasisF
    for n =1:size(X,1)
        a = X(n,:);
        b = mui(m,:);
         c = a-b;
         Fi(n,m)= exp(-(1/2)*(c)*(inv(2*(eye(7))))*(c'));
    end
end

Fi_sudo = pinv(lambda*eye(numBasisF)+Fi'*Fi)*Fi';



end




        
    
    
    


    
    
