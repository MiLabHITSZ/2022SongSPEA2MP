function [final_EP,final_offs] = moead_final(MOP,SC,N)

    % MOP:multiobjective problem
    % SC:stopping criterion
    % N:the number of the subproblems considered in MOEA/D

    population = Init_Pop(MOP,N);
    rate_T = 0.1;
    T = ceil(N * rate_T);
    
    update_pop = 0.6;%按概率更新个体
    
   % sel_neighbor = 0.5;
    cal_sc = 0;%初始评估个体数cal_sc     

    % 生成均匀分布权重向量，存于W
    M = MOP.M;%M为目标函数维度，也就是目标函数包含的“小”目标个数
    DM = MOP.DM;
    W = WV_generator(N,M/DM);
    N = size(W,1);
    
    % 计算函数值，FV为N*M矩阵
    population = population(1:N,:);
    repair_population = zeros(N,MOP.D);
    for t = 1:N
        repair_population(t,:) = repair_s(MOP,population(t,:));
    end
    FV = MOP.CalV(repair_population);

    %初始化参考界面Z
    Z = max(FV,[],1);
    
    %初始化EP    
    EP = [];
    offs = [];
    
    % 计算各权重向量相互间欧几里得距离,并找出每个向量距离最近的T个邻居向量（包括自身）
    D_of_W = zeros([N,N]);
    for i = 1:N
        for j = 1:N
            D_of_W(i,j) = pdist2(W(i,:),W(j,:));
        end
    end    

    B = zeros(N,T);
    TempB = zeros(N,N);
    
    for i = 1:N
        [~,TempB(i,:)] = sort(D_of_W(i,:),2);
        B(i,:) = TempB(i,1:T);
    end
    
    % 开始循环
    while cal_sc < SC
        for dm = 1:DM 
            
            cut = M/DM;
            count_dm = (1+(dm-1)*cut):(dm*cut);  
            
            [Num_of_P,~] = size(population);
            cal_sc = cal_sc + Num_of_P;
            for i = 1:N               
                P = randperm(T,2);
                offspring_y = DE_with_pm(population(B(i,P(1)),:),population(B(i,P(2)),:),MOP);
                
                re_y = repair_s(MOP,offspring_y);
                re_F_y=MOP.CalV(re_y);
                
                Z = max(Z,re_F_y);
                for j = 1:T
                    g_x = max(abs(FV(B(i,j),count_dm)-Z(:,count_dm)).*W(B(i,j),:)); %B(i,j)返回范围1：N的序号，对应某个个体
                    g_y = max(abs(re_F_y(:,count_dm)-Z(:,count_dm)).*W(B(i,j),:));                 
                    if g_y <= g_x
                        if rand < update_pop
                            population(B(i,j),:) = offspring_y;
                            FV(B(i,j),:) = re_F_y;
                        end
                        EP = [EP;re_F_y];
                        offs = [offs;re_y];
                    end
                end
            end
        end
        
        [EP,iEP,~] = unique(EP,"rows");
        offs = offs(iEP,:);
        [Num_of_EP,~] = size(EP);
        NonDominated = true(Num_of_EP,1);
        for m=1:DM
            NonDominated = NonDominated & (FNDS(EP(:,(m-1)*M/DM+1:m*M/DM)) == 1);
        end
        
        EP = EP(NonDominated,:);
        offs = offs(NonDominated,:);      
    end
   
    final_EP = EP;
    final_offs = offs;
end