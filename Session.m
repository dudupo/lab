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
                idd = 0;
            end
            idd = idd + 1;
            retid = idd;
        end
    end
    properties
        LOGLABEL = " logaritmic scale";
        XLABEL = "";
        YLABEL = "";
        YLABELVAR = "";
        XLABELVAR = "";
        heights;
        distances;
        rheights;
        rdistances;
        hbars;
        rbars;
        hbar = 0.3;
        rbar = 0.3;
        material = {"None"};
        id = 0;
        Title = "";
        eq = "a*(x)^0.5";
        XLIME = [5 , inf];
    end
    methods
        function obj = Session(GH , GR , material)
            function y = meanf(X  , Y)
                s = table( X,  Y);
                k = findgroups(s.X);
                w = splitapply( @mean ,s.Y , k);
                y = splitapply( @mean , s.X ,k);
                y = {y, w};
            end


            obj.rheights = GH;
            obj.rdistances = GR;

            arr = meanf(obj.rheights  , obj.rdistances);
            obj.heights = arr{1};
            obj.distances = arr{2};
            obj.hbars = ones( length( obj.heights ),1) * obj.hbar;
            obj.rbars = ones( length( obj.distances ),1) * obj.rbar;
            obj.material = material;
            obj.id = Session.setId();
        end
        function plot(obj)
            errorbar(obj.heights , obj.distances ,obj.hbars, obj.hbars, obj.rbars,obj.rbars, '.' ); 
            f = fit( obj.heights , obj.distances , obj.eq );
            log(obj, obj.Title);
            log(obj, obj.material);
            log(obj, obj.YLABEL);
            log(obj,  evalc('f'))
            plot(f);
            ann(obj);
            title(obj.Title);
            xlabel(obj.XLABEL);
            ylabel(obj.YLABEL);
            xlim(obj.XLIME);
        end
        
        function s = var(obj)
            r =  obj.rdistances(:);
            h = obj.rheights(:);
            s = table( h,r);
            k = findgroups(s.h);
            w = splitapply( @var ,s.r , k);
            w = sqrt(w);
            y = splitapply( @mean , s.h ,k);
            scatter( y , w);
            ann(obj);
            title(obj.Title);
            xlabel(obj.XLABELVAR);
            ylabel(obj.YLABELVAR);
        end



        function ann(obj)
            legend(obj.material);
        end

        function loglog(obj)
            loglog(obj.heights , obj.distances)
            xlabel(strcat(obj.XLABEL , obj.LOGLABEL));
            ylabel(strcat(obj.YLABEL , obj.LOGLABEL));
            title(obj.Title);
            legend(obj.material);
        end

        function plotlog(obj)
            semilogy(obj.heights , obj.distances)
            xlabel(strcat(obj.XLABEL , obj.LOGLABEL));
            ylabel(obj.YLABEL);
            title(obj.Title);
            legend(obj.material);
        end

        function ek = kinect(obj , H)
            gg = 10.981 * 10^2;
            m = 0.1;
            ek = (obj.distances.^2 * gg^2 * m) ./ (4*H);
        end
        
        function v = vzero(obj , H)
        
        
        end
        
        function v = vobj(obj , H)
        
        end

        function ek = objkinect(obj , H)
            ek  = Session(obj.heights, kinect(obj) ,obj.material);
            ek.hbars = obj.hbars ;
            ek.rbars = (obj.hbar * obj.distances + obj.hbars .^ 2 )./ (H - obj.hbar) ;
            ek.XLABEL = obj.XLABEL;
            ek.YLABEL = "Kinecket Energy K[J]";
            ek.Title = obj.Title;
            ek.XLIME = [0 , inf];
        end
        
        function plotwith(obj1 , obj2)
            figure();
            plot(obj1);
            hold 'on';
            plot(obj2);
            hold 'off';
        end 

        function log(obj , str)
            %fileID = fopen(strcat('./log/log' , string( obj.id) , '.txt'),'w+');
            fileID = fopen(strcat('./log/log0' ,  '.txt'),'a+');
            fprintf(fileID,'%s\n',str);
            fclose(fileID);
        end
    end
end
