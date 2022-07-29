function offspring = DE_with_pm(X1,X2,MOP)

    D = MOP.D;
    x_1=zeros(1,D);
    x_2=zeros(1,D);
%     %Uniform Crossover
%     c=rand(1,D)<0.5;
%     for i = 1:D
%         if c(i) == 0
%             x_1(i) = X1(i);
%             x_2(i) = X2(i);
%         else
%             x_1(i) = X2(i);
%             x_2(i) = X1(i);
%         end
%     end
    %One Point Crossover
    point=randi(D-1);
    x_1(1:point)=X1(1:point);
    x_1(point+1:D)=X2(point+1:D);
    x_2(1:point)=X2(1:point);
    x_2(point+1:D)=X1(point+1:D);
    
    %mutation
    m=rand(1,D)<1/D;
    n=rand(1,D)<1/D;
    for i = 1:D
        if m(i) == 1
            x_1(i)=1-x_1(i);
        end
        if n(i) == 1
            x_2(i)=1-x_2(i);
        end
    end

    %repair
%     if c == 1
%         x1=repair(MOP,x_1);
%         x2=repair(MOP,x_2);
%    
%         x1 = x_1;
%         x2 = x_2;
%     end

    x1=repair_s(MOP,x_1);
    x2=repair_s(MOP,x_2);
    
    val_x1 = MOP.CalV(x1);
    Val_x2 = MOP.CalV(x2);
    
    if  dominate_max(val_x1,Val_x2)
        x = x_1;
    else
        if dominate_max(Val_x2,val_x1)
            x = x_2;
        else
            if rand < 0.5
                x = x_1;
            else
                x = x_2;
            end
        end 
    end
   offspring = x;         
end