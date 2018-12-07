%{
    G1 - metal , rail height is variable.
    G2 - glass , rail height is variable.
    G3 - metal , height of the ball reltaive to the rail is variable.
    G4 - glass , height of the ball reltaive to the rail is variable.
%}

classdef Session 
    methods (Static)
        function retid = setId()
            persistent idd;
            if isempty(idd)
                idd = 0 
            end
            idd = idd + 1;    
            retid = idd;
        end 
    end
    properties
        heights;
        distances;
        hbars;
        rbars;
        hbar = 0.3;
        rbar = 0.3;
        material = {"None"};
        id = 0;
    end
    methods
        function obj = Session(G , material)
            obj.heights = G.H;
            obj.distances = G.R;
            obj.hbars = ones( length( obj.heights ),1) * obj.hbar;
            obj.rbars = ones( length( obj.distances ),1) * obj.rbar;
            obj.material = material;
            obj.id = Session.setId();
        end 
        function plot(obj)
            %plot(obj.heights , obj.distances);
            errorbar(obj.heights ,obj.distances,obj.hbars, obj.hbars, obj.rbars,obj.rbars, '.' );
            ann(obj);
        end
        
        function s = var(obj)
            r =  obj.distances(:);
            h = obj.heights(:);
            s = table( h,r);
            k = findgroups(s.h);
            w = splitapply( @var ,s.r , k);
            y = splitapply( @mean , s.h ,k);
            scatter( y , w);   
            ann(obj);
            title(" distance variance per height cluster");
        end
        
        function ann(obj)
            legend(obj.material);
        end 
        
        function log(obj , str)
            fileID = fopen('log' + obj.id + '.txt','a+');
            fprintf(fileID,'%s\n',str);
            fclose(fileID);
        end 
    end 
end


