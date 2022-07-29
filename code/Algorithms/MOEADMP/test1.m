function test1()
    a = MPMOKP;
    for dim = [30 50 100]
        evalu = 1000*dim*2;
        result = [];
        for k = 1:10
            s = load(sprintf('data1/%d/MPMOKP%d_%d',dim,dim,k));
            profit00 = s.pro00;
            profit01 = s.pro01;
            profit10 = s.pro10;
            profit11 = s.pro11;
            
            weight00 = s.wei;
            weight01 = s.wei;
            weight10 = s.wei;
            weight11 = s.wei;
            
            common_s = s.common_s;
            
            a.Init_D(dim,profit00,profit01,profit10,profit11,weight00,weight01,weight10,weight11);
            PF = a.CalV(common_s);
            
            Score1 = [];
            Score2 = [];
            solution_count1 = [];
            solution_count2 = [];
            for i = 1:30
                [m,~] = moead_final(a,evalu,100,0);
                [n,~] = xmoead_final(a,evalu,100,1);
                solution_count1 = [solution_count1 ,size(m,1)];
                solution_count2 = [solution_count2 ,size(n,1)];
                if size(m,1) ~= 0
                    Score1 = [Score1,IGD_mp(m,PF,2)];
                end
                if size(n,1) ~= 0
                    Score2 = [Score2,IGD_mp(n,PF,2)];
                end
            end
            result_mean1=mean(Score1);
            result_std1=std(Score1);
            result_mean2=mean(Score2);
            result_std2=std(Score2);
            solution_mean1 = mean(solution_count1);
            solution_std1 = std(solution_count1);
            solution_mean2 = mean(solution_count2);
            solution_std2 = std(solution_count2);
            result = [result;result_mean1,result_std1,solution_mean1,solution_std1,result_mean2,result_std2,solution_mean2,solution_std2];
            fprintf("MPMOKP_%d_%d done!\n",dim,k);
        end
        location={sprintf('data1')};
       % [~,~]=mkdir(sprintf('%s/%d/',location{1},dim));
        save(sprintf('%s/%d.mat',location{1},dim),'result');
    end
end

