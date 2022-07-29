function test()
   a = MPMOKP;
    for dim = 30
        refPoint = [0,0];
        evalu = 1000*dim*2;
        result = [];
        for k = 1:3
            s = load(sprintf('data2/%d/MPMOKP%d_%d',dim,dim,k));
            profit00 = s.pro00;
            profit01 = s.pro01;
            profit10 = s.pro10;
            profit11 = s.pro11;
            
            weight00 = s.wei00;
            weight01 = s.wei01;
            weight10 = s.wei10;
            weight11 = s.wei11;
            
            a.Init_D(dim,profit00,profit01,profit10,profit11,weight00,weight01,weight10,weight11);
            
            Score1 = [];
            Score2 = [];
            solution_count1 = [];
            solution_count2 = [];
            for i = 3
                [m,~] = moead_final(a,evalu,100,0);
                [n,~] = xmoead_final(a,evalu,100,1);
                solution_count1 = [solution_count1 ,size(m,1)];
                solution_count2 = [solution_count2 ,size(n,1)];
                if size(m,1) ~= 0
                    Score1 = [Score1,HV(m(:,1:2),refPoint)+HV(m(:,3:4),refPoint)];
                end
                if size(n,1) ~= 0
                    Score2 = [Score2,HV(n(:,1:2),refPoint)+HV(n(:,3:4),refPoint)];
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
            result = [result;result_mean1,result_std1,result_mean2,result_std2,solution_mean1,solution_std1,solution_mean2,solution_std2];
            fprintf("MPMOKP_%d_%d done!\n",dim,k);
        end
        location={sprintf('data2')};
       % [~,~]=mkdir(sprintf('%s/%d/',location{1},dim));
        save(sprintf('%s/p_%d.mat',location{1},dim),'result');
    end
end