function [ resampled_pos ] = resample_polygons( initial_pos,min_vertices,l_edges,span )
% RESAMPLE_POLYGONS resamples the polygons given a target edge length l_edges.
% It computes the mean position of a point around its "span" closest
% neighbors (if span is 0, then it does not average the value).
%
% %%%%%% usage %%%%%%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - initial_pos   : Mx1 Cell of Nx2 matrices containing the x-y coordinates
%                    of the vertices of the polygons.
%  - min_vertices  : minimum number of vertices.
%  - l_edges       : target edge length. The smaller the more vertices.
%  - span          : number of points taken to the right and to the left
%                    during averaging of the position.
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - resampled_pos : The new resampled polygons (Mx1 Cell containing the
%                    resampled polygons).
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if l_edges==0 % If target length is 0, we do not resample the polygons
    
    resampled_pos=initial_pos;
    
else % Else, we resample
    
    resampled_pos=cell(1,size(initial_pos,2));
    
    for i=1:length(initial_pos) % Iteration on all the stones
        
        poly=initial_pos{i};
        perimeter=get_perimeter(poly); % Computation of the perimeter.
        n_vertices=max(min_vertices,round(perimeter/l_edges)); % Computation of the number of edges
        n=size(poly,1);
        
        if n_vertices<n % If the targeteted number of vertices is bigger than the number of vertices of the polygon, we do not resample
            
            poly=[poly(end-span+1:end,:);poly;poly(1:span,:)];
            dn=floor(n/n_vertices);
            ind=1+span;
            new_poly=zeros(n_vertices,2);
            k=1;
            
            while ind<n+1 || k<=n_vertices % Computation of the new vertices
                
                new_poly(k,1)=mean(poly(ind-span:ind+span,1));
                new_poly(k,2)=mean(poly(ind-span:ind+span,2));
                ind=ind+dn;
                k=k+1;
                
            end
            
            new_poly = unique(new_poly, 'rows','stable');
            resampled_pos{i}=new_poly;
            
        else
            
            resampled_pos{i}=poly;
            
        end
        
    end
    
end

end