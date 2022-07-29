function f=MPMOKP(weight1,weight2, x)
% INPUT:
%       probID: test problem identifier (i.e. 'DF1')
%       x:      variable vector
%
% OUTPUT:
%       f:      objective vector
%

    %[~,n]=size(x); % number of variables
    a=x.*repmat(weight1,size(x,1),1);
    b=x.*repmat(weight2,size(x,1),1);
    f(:,1)=sum(a');
    f(:,2)=sum(b');
end