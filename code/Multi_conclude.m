function Multi_conclude()
    delete(gcp('nocreate'));
    parpool(30);
    a = MPMOKP;
    for dim = [30 50 100]
        evalu = 1000*dim*2;
        result = [];
        for k = 1:10
            s = load(sprintf('Problems/%d/MPMOKP%d_%d',dim,dim,k));
            profit00 = s.profit00;
            profit01 = s.profit01;
            profit10 = s.profit10;
            profit11 = s.profit11;
            
            weight = s.weight;
            
            common_solution = s.common_solution;
            
            a.Init_D(dim,profit00,profit01,profit10,profit11,weight,weight,weight,weight);
            common_PF = a.CalV(common_solution);
            
            Score1 = [];
            Score2 = [];
            Score3 = [];
            Score4 = [];
            solution_count1 = [];
            solution_count2 = [];
            solution_count3 = [];
            solution_count4 = [];
            parfor i = 1:30
                s = RandStream.create('mrg32k3a','NumStreams',30,'StreamIndices',i);
                RandStream.setGlobalStream(s); 
                [obj1,~] = moead_final(a,evalu,100);
                [obj2,~] = mpnds_final(a,evalu,100,1);
                [obj3,~] = mpnds_final(a,evalu,100,2);
                [obj4,~] = spea2_final(a,evalu,100);
                
                solution_count1 = [solution_count1 ,size(obj1,1)];
                solution_count2 = [solution_count2 ,size(obj2,1)];
                solution_count3 = [solution_count3 ,size(obj3,1)];
                solution_count4 = [solution_count4 ,size(obj4,1)];
                
                if size(obj1,1) ~= 0
                    Score1 = [Score1,IGD_mp(obj1,common_PF,2)];
                end
                if size(obj2,1) ~= 0
                    Score2 = [Score2,IGD_mp(obj2,common_PF,2)];
                end
                if size(obj3,1) ~= 0
                    Score3 = [Score3,IGD_mp(obj3,common_PF,2)];
                end
                if size(obj4,1) ~= 0
                    Score4 = [Score4,IGD_mp(obj4,common_PF,2)];
                end
                fprintf("MPMOKP_%d_%d the %d-th running done!\n",dim,k,i);
            end
            result_mean1=mean(Score1);
            result_std1=std(Score1);
            result_mean2=mean(Score2);
            result_std2=std(Score2);  
            result_mean3=mean(Score3);
            result_std3=std(Score3); 
            result_mean4=mean(Score4);
            result_std4=std(Score4); 
            solution_mean1 = mean(solution_count1);
            solution_std1 = std(solution_count1);
            solution_mean2 = mean(solution_count2);
            solution_std2 = std(solution_count2);
            solution_mean3 = mean(solution_count3);
            solution_std3 = std(solution_count3);
            solution_mean4 = mean(solution_count4);
            solution_std4 = std(solution_count4);
            result = [result;result_mean1,result_std1,result_mean2,result_std2,result_mean3,result_std3,result_mean4,result_std4,...
                solution_mean1,solution_std1,solution_mean2,solution_std2,solution_mean3,solution_std3,solution_mean4,solution_std4];
            fprintf("MPMOKP_%d_%d done!\n",dim,k);
        end
        location={sprintf('Data')};
       % [~,~]=mkdir(sprintf('%s/%d/',location{1},dim));
        save(sprintf('%s/result_%d.mat',location{1},dim),'result');
    end
end

