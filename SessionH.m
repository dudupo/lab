classdef SessionH < Session 
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    methods
        function obj = SessionH(G , material)
            obj@Session(G.H , G.R , material);
            obj.XLABEL = "height relateive to the ground H[cm]";
            obj.YLABEL = "distance r[cm]";
            obj.YLABELVAR = "variance of clusters r[cm]"; 
            obj.XLABELVAR = "cluster distance H[cm]";
        end
        
        function plot(obj)
            plot@Session(obj);
            
            %f = fit(obj.heights , obj.distances , "a*(x)^b +c" , 'StartPoint', [2, 0.5 , 0.01] , ...
            %'Upper', [140 , 0.6 , 0.01] , 'Lower' , [0 , 0.49 , 0.01 ] );
            %plot(f);
            %f 
            xlabel(obj.XLABEL);
            ylabel(obj.YLABEL);
%             hold of
        end
        
        function ek = kinect(obj)
            ek = kinect@Session(obj, obj.heights);
        end
        
        function ek  = objkinect(obj)
            ek = objkinect@Session(obj , obj.heights);
        end
    end
end

