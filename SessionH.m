classdef SessionH < Session 
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        XLABEL = "heigt relateive to the ground";
        YLABEL = "distance";
    end
    
    methods
        function obj = SessionH(G)
            obj@Session(G);
        end
        
        function plot(obj)
            plot@Session(obj);
            xlabel(obj.XLABEL);
            ylabel(obj.YLABEL);
        end
    end
end

