function plot_pixel(fig, surf_v,dx,i_x,i_y,reordering_method,b)
if size(surf_v,1)~=0 % If there is still a stone
    
    X_eroded=zeros(size(surf_v,1),1); % Each surface pixel will become a vertex of the polygon
    Y_eroded=zeros(size(surf_v,1),1);
    
    for j=1:size(surf_v,1) % We recompute the x-y coordinates
        
        X_eroded(j,1)=(surf_v(j,2)-b-0.5)*dx+i_x;
        Y_eroded(j,1)=(surf_v(j,1)-b-0.5)*dx+i_y;
    
    end
    
    switch reordering_method
        
        case 'angular'
            x=mean(X_eroded); % ~center of the stone
            y=mean(Y_eroded); % ~center of the stone
            
            % We sort the remaining pixels by angle
            vecs = [X_eroded,Y_eroded]-repmat([x y],size(X_eroded,1),1);
            
            angles=zeros(size(vecs,1),1);
           
            for i=1:size(vecs,1)
             
                angles(i) = atan2(vecs(i,1),vecs(i,2));
            end
            
            [~, index]=sort(angles);
            X_eroded=X_eroded(index); % Sorting according to the angle
            Y_eroded=Y_eroded(index); % Sorting according to the angle
     
        case 'nearest_neighbor'
     
            poly=[X_eroded,Y_eroded];
            poly=reorder_by_distance_polygon(poly);
            
            X_eroded=poly(:,1);
            Y_eroded=poly(:,2);
  
    end
    
else
    
    X_eroded=[];
    Y_eroded=[];
    
end
grey_nb = 0.7;
figure(fig)
hold off
fill(X_eroded,Y_eroded,grey_nb*ones(1,3))
end