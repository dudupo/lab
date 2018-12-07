
classdef Sessionsmallh < Session
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        XLABEL = "height relateive to the trace h[cm]";
        YLABEL = "Kinecket Energy K[J]";
        YLABELVAR = "variance of clusters r[cm]"; 
        XLABELVAR = "cluster distance h[cm]";
    end
    
    methods
        function obj = Sessionsmallh(G , material)
            obj@Session(G, material);
        end
        function plot(obj)
            %plot@Session(obj);
            gg = 10.981 * 10^2;
            m = 0.1;
            H = 10;
            ek = obj.distances.^2 * gg^2 * m / (4*H);
            errorbar(obj.heights, ek, obj.hbars , obj.hbars , obj.rbars.^2 , obj.rbars.^2 , '.');
            legend("Ek");
            f = fit(obj.heights ,ek , "b*(x)^a + d*x +c");
            f
%             hold on;
            plot(f);
            xlabel(obj.XLABEL);
            ylabel(obj.YLABEL);
%             hold of;
        end
       
        
        function var(obj)
            var@Session(obj);
            xlabel(obj.XLABELVAR);
            ylabel(obj.YLABELVAR);
        end
    end
end

