function [objs,MPS]=mpnds_final(MOP,SC,N,opt)
    DM = 2;
    P = Init_Pop(MOP,N);
    cal_sc = 0; %初始化评估次数cal_sc 

    [~,FrontNo,CrowdDis] = EnvironmentalSelection(P,MOP,N,opt);
    while cal_sc < SC
        cal_sc = cal_sc + N;
        MatingPool = TournamentSelection(2,N,FrontNo,-CrowdDis);
        Offspring  = GA(P(MatingPool,:),MOP);
        P = [P;Offspring];
        [P,FrontNo,CrowdDis] = EnvironmentalSelection(P,MOP,N,opt);
    end

    P = repair(MOP,P);
    [P,~,~] = unique(P,'rows');
    [Num_of_P,~] = size(P);
    NonDominated = true(Num_of_P,1);
    objs = MOP.CalV(P);
    for m=1:DM
        NonDominated = NonDominated & (FNDS(objs(:,(m-1)*2+1:m*2)) == 1);
    end
    MPS = P(NonDominated,:);
    objs = objs(NonDominated,:);
%     disp(objs);
%     weights = MOP.CalW(MPS);
%     wei = MOP.c00;
%     disp(weights);
%     disp(wei);
end

