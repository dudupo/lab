classdef SessionH < Session 
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        XLABEL = "height relateive to the ground H[cm]";
        YLABEL = "distance r[cm]";
        YLABELVAR = "variance of clusters r[cm]"; 
        XLABELVAR = "cluster distance H[cm]";
    end
    
    methods
        function obj = SessionH(G , material)
            obj@Session(G , material);
        end
        
        function plot(obj)
            plot@Session(obj);
            f = fit(obj.heights , obj.distances , "a*(x)^b +c" , 'StartPoint', [2, 0.5 , 0.01] , ...
            'Upper', [140 , 0.6 , 0.01] , 'Lower' , [0 , 0.5 , 0.01 ] );
            plot(f);
            f 
            xlabel(obj.XLABEL);
            ylabel(obj.YLABEL);
%             hold of
        end
        function var(obj)
            var@Session(obj);
            xlabel(obj.XLABELVAR);
            ylabel(obj.YLABELVAR);
        end
    end
end

