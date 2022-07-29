function Score= IGD_mp(PopObj,PF,DM)
% <metric> <min>
%%calculate the IGD  for the result
[~,M]=size(PF);
[row,~]=size(PF);
[col,~]=size(PopObj);
Distance_IGD=zeros(row,col);

%we calculate their distance between real PF and PF for each party, sum
%them,and find the min value for each individual
for i=1:DM
    real_PopObj = real(PopObj);
    Distance_IGD = Distance_IGD+pdist2(PF(:,(i-1)*M/DM+1:i*M/DM),real_PopObj(:,(i-1)*M/DM+1:i*M/DM));
end  

Distance_IGD = min(Distance_IGD,[],2);
IGD    = mean(Distance_IGD);

Score = IGD;
end