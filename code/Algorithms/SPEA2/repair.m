function offspring = repair(MOP,off)
    D = MOP.D;
    C=[MOP.c00,MOP.c01,MOP.c10,MOP.c11];
    W=[MOP.weight00;MOP.weight01;MOP.weight10;MOP.weight11];
    S=[MOP.profit00;MOP.profit01;MOP.profit10;MOP.profit11];
    s=sum(S,1)./sum(W,1);
    [~,r]=sort(s,2,'descend');
    
    [m,~]=size(off);
    %disp(off);
    for i = 1:m
        x = off(i,:);
        %disp(size(x));
        R=MOP.CalW(x);
        %drop
        for j = D:-1:1
            if x(r(j))==1 && sum(R>C)>=1   
                x(r(j)) = 0;
                R=R-W(:,r(j))';
            end
        end
        %add
    %     if c == 2
    %         for j = 1:D
    %             if (x(r(j))==0)&&(sum(R+W(:,r(j))'<=C)==M)
    %                 x(r(j))=1;
    %                 R=R+W(:,r(j))';
    %             end
    %         end
    %     end
        off(i,:) = x;
    end
    offspring = off;
end