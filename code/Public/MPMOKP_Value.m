function f=MPMOKP(profit1,profit2, x)
% INPUT:
%       probID: test problem identifier (i.e. 'DF1')
%       x:      variable vector
%
% OUTPUT:
%       f:      objective vector
%

    %[~,n]=size(x); % number of variables
    a=x.*repmat(profit1,size(x,1),1);
    b=x.*repmat(profit2,size(x,1),1);
    f(:,1)=sum(a');
    f(:,2)=sum(b');
end