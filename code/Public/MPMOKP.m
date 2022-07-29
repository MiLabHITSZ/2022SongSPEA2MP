classdef MPMOKP < handle
% <MPMOP>
    properties
    %% Initialization
        M;
        D;
        DM;
        profit00;
        profit01;
        profit10;
        profit11;
        weight00;
        weight01;
        weight10;
        weight11;
        c00;
        c01;
        c10;
        c11;
        encoding = 'binary';
    end
    methods
        %% Initialization
        function obj = Init_D(obj,d,pro00,pro01,pro10,pro11,wei00,wei01,wei10,wei11)
            obj.M = 4;
            obj.DM = 2;
            obj.D = d;
            
            % random profit generation
            obj.profit00=pro00;
            obj.profit01=pro01;
            obj.profit10=pro10;
            obj.profit11=pro11;
            
            obj.weight00=wei00;
            obj.weight01=wei01;
            obj.weight10=wei10;
            obj.weight11=wei11;
      
            obj.c00=sum(obj.weight00)*0.5;
            obj.c01=sum(obj.weight01)*0.5;
            obj.c10=sum(obj.weight10)*0.5;
            obj.c11=sum(obj.weight11)*0.5;
        end
        %% Calculate objective values for each party
        function PopObj = CalV(obj,PopDec) 
            PopObj(:,[1:obj.M/2])=MPMOKP_Value(obj.profit00,obj.profit01, PopDec);
            PopObj(:,[obj.M/2+1:obj.M])=MPMOKP_Value(obj.profit10,obj.profit11,PopDec);
        end
        function PopObj = CalW(obj,PopDec) 
            PopObj(:,[1:obj.M/2])=MPMOKP_Weight(obj.weight00,obj.weight01, PopDec);
            PopObj(:,[obj.M/2+1:obj.M])=MPMOKP_Weight(obj.weight10,obj.weight11,PopDec);
        end
    end
end