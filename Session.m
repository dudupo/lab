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
            plot( fit( obj.heights , obj.distances , "a*(x)^b + c"));
            ann(obj);
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
            title(" distance variance per height cluster");
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
        end

        function plotlog(obj)
            semilogy(obj.heights , obj.distances)
            xlabel(strcat(obj.XLABEL , obj.LOGLABEL));
            ylabel(obj.YLABEL);

        end

        function ek = kinect(obj , H)
            gg = 10.981 * 10^2;
            m = 0.1;
            ek = (obj.distances.^2 * gg^2 * m) ./ (4*H);
        end

        function ek = objkinect(obj , H)
            ek  = Session(obj.heights, kinect(obj) ,obj.material);
            ek.hbars = obj.hbars ;
            ek.rbars = (obj.hbar * obj.distances + obj.hbars .^ 2 )./ (H - obj.hbar) ;
            ek.XLABEL = obj.XLABEL;
            ek.YLABEL = "Kinecket Energy K[J]";
        end
        
        function vx = Vx(obj)
            
        
        end

        function log(obj , str)
            fileID = fopen('log' + obj.id + '.txt','a+');
            fprintf(fileID,'%s\n',str);
            fclose(fileID);
        end
    end
end
