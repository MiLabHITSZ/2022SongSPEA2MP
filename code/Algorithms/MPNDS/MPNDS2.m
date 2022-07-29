function [FrontNo,MaxFNo] = MPNDS2(objs,N)
    L(:,1) = FNDS(objs(:,1:2));
    L(:,2) = FNDS(objs(:,3:4));
    [FrontNo,MaxFNo] = NDSort(L,N);
end

