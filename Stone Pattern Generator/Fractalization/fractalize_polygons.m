function [ fract_pos ] = fractalize_polygons( pos,it,c )
% FRACTALIZE_POLYGONS Function that will add a random shape to polygons.
%
% It divides the line by two and put a middle point that is slightly out of
% the initial line. It does it iteratively (it times) so the final shape is
% noisy. Be aware that the number of vertices grows quickly ! (N vertices =
% N_v_initial * 2^it)
%
% %%%%%% usage %%%%%%
% 
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - pos : Initial shape of the polygons
%  - it  : Number of iterations (if 0, nothing is done)
%  - c   : Constant determining the degree of noise added
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - fract_pos    : The new polygons
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if it~=0 % If it ~= 0, we fractalize the polygons. 
    
    for i=1:size(pos,2) % We iterate on the stones
        
        poly=pos{i};
        
        for j=1:it % We do the required number of iterations
            
            poly=[poly;poly(1,:)]; % Add the first point to the end of the coordinates
            new_poly=poly;
            
            for k=1:size(poly,1)-1 % We iterate on the edges
                
                % Creation of normal vector and median point
                p1=poly(k,:);
                p2=poly(k+1,:);
                d=distanz(p1,p2);
                v=p2-p1;
                n=[-v(2) v(1)];
                n=n/norm(n);
                pm=0.5*(p1+p2);
                % Creation of the random point to add normally
                coef=rand(1,1);
                pn=pm+coef*n*d*c;
                new_poly=[new_poly(1:(2*k-1),:);pn;new_poly(2*k:end,:)]; %Insertion of the new point where it belongs
            
            end
            
            new_poly(end,:)=[]; % Removal of the first point we added at the beginning of the it for loop.
            poly=new_poly;
            
        end
        
        fract_pos{i}=new_poly;
        
    end
    
else % If it==0, we do not fractalize the polygons
    
    fract_pos=pos;
    
end

end

