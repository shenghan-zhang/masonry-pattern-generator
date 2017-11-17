function [ posTabOut,stonesNodesOut,stonesPos,row_vec] = divide_in_voronoi_polygons( posTab,stonesNodes,tresholdArea,epsilon,row_vec,Lx_wall,Ly_wall )
% DIVIDE_IN_VORONOI_POLYGONS takes as an input a list of polygons and
% divide those with an area superior to aireSeuil using a voronoi diagram.
%
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - posTab      : 2xN xy coordinates of the nodes
%  - stonesNodes : 1xM cell containing the list of the nodes that each
%                  stone comprises.
%  - tresholdArea: Area above which the polygons will be splitted using a
%                  a voronoi diagram
%  - epsilon     : approximation constant
%  - row_vec     : Mx1 vector containing the row indexes of the stones
%  - Lx_wall     : Width of the wall
%  - Ly_wall     : Height of the wall%
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - posTabOut   : Updtated pos tab
%  - stonesNodesOut : updated indexes of the stones
%  - row_vec     : Updated row_vec
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : january 2017
%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
isValid=0; % While the obtained pattern is not valid

while isValid~=1;
    
    % Variables initialisations
    posTabInit=posTab;
    stonesNodesInit=stonesNodes;
    posTabOld=posTabInit;
    stonesNodesOld=stonesNodesInit;
    dividedStonesCounter=0;
    isConc=zeros(1,length(stonesNodes));
    
    % VORONOI SPLITTING OF THE POLYGONS
    for i=1:length(stonesNodesInit) % We iterate on the stones 
        
        % We compute the polygon, its area and check its convexity 
        polygon=posTab(stonesNodesInit{i},:);
        a=get_area_polygon(polygon);
        isConc(i)=is_concave(stonesNodesInit{i},posTab);
        
        if a>tresholdArea %&& isConc(i)==0 % If the polygon is convex and its area is > than tresholdArea
            
            n=round(a/tresholdArea)+5; % The number of points used for the Voronoi Diagram is defined
            [posTabNew,stonesNodesNew,row_vec]=voronoi_splitting(posTabOld,stonesNodesOld,i-dividedStonesCounter,n,epsilon,row_vec);
            [stonesNodesOld,~] = get_all_nodes( posTabNew,stonesNodesNew,epsilon );
    
            posTabOld=posTabNew;
            dividedStonesCounter=dividedStonesCounter+1;
            
        else % Nothing changes
            
            posTabNew=posTabOld;
            stonesNodesNew=stonesNodesOld;
            
        end
        
        stonesPos=cell(1,numel(stonesNodesNew));
        
        for k=1:numel(stonesNodesNew)
            
            stonesPos{k}=posTabNew(stonesNodesNew{k},:);
            
        end

    end


    
    % CREATION OF OUTPUT VARIABLES
    
    posTabOut=posTabNew;
    to_del=[];
    posTabOut=round(posTabOut./epsilon)*epsilon;
    [stonesNodesOut,stonesPos] = get_all_nodes( posTabOut,stonesNodesNew,epsilon );
    
    for i=1:size(stonesNodesNew,2)% we iterate on the new stones
                
        if size(stonesNodesOut{i},2)>2 % If the stone is not empty
           
            for j=1:i-1 % We just check that a same stone has not been created yet, VoronoiLimit sometimes does it
                
                if isequal(stonesNodesOut{j},stonesNodesOut{i})
                    
                    to_del=[to_del,i];
                    
                end
                
            end
            
        else
            
            to_del=[to_del,i];
            
        end
        
    end
    
    % DELETION OF UNVALID STONES AND FINAL VALIDITY CHECK
    stonesPos(to_del)=[];
    stonesNodesOut(to_del)=[];
    row_vec(to_del)=[];
    isValid=check_validity2(posTabOut,stonesNodesOut,Lx_wall,Ly_wall,epsilon);
    
    if isValid==0;
        
        disp('Failed Vornoiing, redo...');
        
    end
    
end

end

