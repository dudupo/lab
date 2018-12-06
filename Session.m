%{
    G1 - metal , rail height is variable.
    G2 - glass , rail height is variable.
    G3 - metal , height of the ball reltaive to the rail is variable.
    G4 - glass , height of the ball reltaive to the rail is variable.
%}

classdef Session
    properties
        heights;
        distances;
        hbars;
        rbars;
        hbar = 0.3;
        rbar = 0.3;
    end
    methods
        function obj = Session(G)
            obj.heights = G.H;
            obj.distances = G.R;
            length( obj.heights )
            obj.hbars = ones( length( obj.heights ),1) * obj.hbar;
            obj.rbars = ones( length( obj.distances ),1) * obj.rbar;
            obj.hbars
        end 
        function plot(obj)
            %plot(obj.heights , obj.distances);
            obj.hbars
            errorbar(obj.heights ,obj.distances,obj.hbars, obj.hbars, obj.rbars,obj.rbars, '.' );
        end
    end 
end


