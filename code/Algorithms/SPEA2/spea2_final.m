function [objs,MPS] = spea2_final(MOP,SC,N)
    DM = 2;
    P = Init_Pop(MOP,N);
    objs = MOP.CalV(repair(MOP,P));
    Fitness = CalFitness(objs);
    
    cal_sc = 0; %初始化评估次数cal_sc
    while cal_sc < SC
        cal_sc = cal_sc + N;
        MatingPool = TournamentSelection(2,N,Fitness);
        Offspring  = GA(P(MatingPool,:),MOP);  
        P = [P;Offspring];
        [P,Fitness] = Environmental_Selection(P,N,MOP);
        %disp(mean(Fitness));
        %disp(size(P,1));
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
%    disp(size(objs,1));
%     weights = MOP.CalW(MPS);
%     wei = MOP.c00;
%     disp(weights);
%     disp(wei);
end

