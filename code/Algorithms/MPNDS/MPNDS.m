function [FrontNo,MaxFNo] = MPNDS(objs,N,MOP)
    DM = MOP.DM;
    [FrontNo,MaxFNo] = MPNDS_Sort(objs,N,DM);  
end

function [FrontNo,MaxFNo] = MPNDS_Sort(PopObj,nSort,DM)
    [PopObj,~,Loc] = unique(PopObj,'rows');
    Table          = hist(Loc,1:max(Loc));
    [N,M]          = size(PopObj);    
    FrontNo        = inf(1,N);
    MaxFNo         = 1;
    FNo=1;
    S=false(1,N);
    Visited=false(1,N);
    Front=inf(DM,N);
    %Fast Non Dominated Sorting for each party
    for k=1:DM
        Front(k,:)=FNDS(PopObj(:,(k-1)*M/DM+1:k*M/DM));
    end
    FrontNo_max=max(Front,[],1);     %find the max level for individual in all parties
    %MPNDS
    while sum(Table(FrontNo<inf)) < min(nSort,length(Loc))
        Fz=true(1,N);
         %Pop(k).frontno==FNo&Pop(k).visited==false represent individulas
         %which are in the Fno_th Front in k decision maker.
        for k=1:DM
            Fz=Fz&Front(k,:)==FNo&Visited==false;%get the union and store in Fz
        end        
        if sum(Fz)==0           
            for k=1:DM 
                S=S|(Front(k,:)==FNo&Visited==false); %S union the rest
            end
            FNo=FNo+1; 
            Fz=S&(FrontNo_max==FNo);
            S(find(Fz~=0))=0;    %S=S-Fz       
        end
        if sum(Fz)~=0            
            FrontNo(Fz)=MaxFNo;
             temp=false(1,N);
             temp(Fz)=true;           
             Visited(temp)=true;%minus the Fz
             MaxFNo = MaxFNo + 1;
        end
    end
    FrontNo = FrontNo(:,Loc);
    MaxFNo=MaxFNo-1;
end




