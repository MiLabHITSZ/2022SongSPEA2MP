function [Population,FrontNo,CrowdDis] = EnvironmentalSelection(Population,MOP,N,opt)
%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------
    repair_P = repair(MOP,Population);
    objs = MOP.CalV(repair_P);
    if opt == 1
        [FrontNo,~] = MPNDS(objs,N,MOP);
    else
        [FrontNo,~] = MPNDS2(objs,N);
    end

    CrowdDis = CrowdingDistance(objs,FrontNo);
    
    front = 1;
    count = 0;
    Next = zeros(1,size(Population,1));
    
    Last = find(FrontNo == front);
    temp = size(Last,2);
    count = count + temp;
    
    while count < N
       Next(Last) = true;
       front = front + 1;
       Last = find(FrontNo == front);
       temp = size(Last,2);
       count = count + temp;
    end
    [~,Rank] = sort(CrowdDis(Last),'descend');
    Next(Last(Rank(1:N-sum(Next)))) = true;
    index = find(Next);
    Population = Population(index,:);
    FrontNo    = FrontNo(index);
    CrowdDis   = CrowdDis(index);
end

