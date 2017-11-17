%% write video for erode one stone 
clear
clc
polyong=[0.1,0.05;...
    0.3,0.05;...
    0.35,0.2;...
    0.1,0.3;...
    0.05,0.15
    0.1,0.05];

        
    
load matlab_one_stone.mat
create_video = true;
if(create_video)
    close all
    fig1 = figure;
    axis equal
     v = VideoWriter('erode_stone.avi');
     v.Quality = 100;
     v.FrameRate = 5;
     open(v)
end
%% EROSION PROCESS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
it
it=floor(it/8);
it
for i=1:it % Temporal iteration
    i
    to_del=[]; % initialization of to add and to delete pixels
    to_add=[];
    
    for j=1:size(surf_v,1) % We iterate on surface pixels
        
        ind_i=surf_v(j,1);
        ind_j=surf_v(j,2);
        state(ind_i,ind_j)=state(ind_i,ind_j)-damping_values(j)*exposure(j)^pe/durability(ind_i,ind_j); % We compute the new state
        
        if state(ind_i,ind_j)<0 % If the state is less than 0
            
            mask(ind_i,ind_j)=0; % This coordinate of the mask becomes 0
            to_del=[to_del;j]; % This pixel is to be deleted
            to_add=[to_add;actualize_surf(mask,ind_i,ind_j)]; % Some pixels might have to be added
            exposure=update_exposure(exposure,ind_i,ind_j,surf_v,bulle,r,dx); % Exposure must be updated
            An=An-dx^2; % Area is updated
            
        end
        
    end
     
    % The corresponding values in surf_v, exposure, damping_values and
    % vec_angles are deleted.
    surf_v(to_del,:)=[];
    exposure(to_del)=[];
    damping_values(to_del)=[];
    vec_angles(to_del)=[];
    
    % If there is pixels to add
    if isempty(to_add)==0
        
        surf_v=[surf_v;to_add]; % We add them in the surf_v vector
        vec_angles=[vec_angles;atan2(to_add(:,2)-jo,to_add(:,1)-io)]; % we add them in the vec_angles vector
        exposure=add_new_exposure(exposure,to_add,mask,mask_exposure,n,bulle); % The exposure is computated and added
        if isempty(contact_points)==0 % We compute the damping values if the contact_points list is not empty
            
            for k=1:size(to_add,1)
                
                x=(to_add(k,2)-b-0.5)*dx+i_x; % X coordinate
                y=(to_add(k,1)-b-0.5)*dx+i_y; % Y coordinate
                damping_values=[damping_values,get_damping_erosion(x,y,contact_points,aa,bb,seuil_contact)]; % Updating damping values
            
            end
            
        else
            
            damping_values=[damping_values,ones(1,size(to_add,1))]; % If there is no contact point, damping is 1.
        
        end
        
        [surf_v,ind_rm] = unique(surf_v, 'rows') ; % We reorganize the surf_v vector
        exposure=exposure(ind_rm); % Same ordering on exposure
        damping_values=damping_values(ind_rm); % Same ordering on damping_values
        vec_angles=vec_angles(ind_rm); % Same ordering on vec_angles
    
    end
    
    if An/A<seuil_area % If the area goes under a certain ratio of the initial, process of erosion is stopped
        
        break;
        
    end
    if (create_video == true && mod(i,20)==0)
    plot_pixel(fig1, surf_v,dx,i_x,i_y,reordering_method,b)
    figure(fig1);
    hold on
    plot(polyong(:,1),polyong(:,2),'linewidth',2)
    set(fig1.CurrentAxes,'visible','off');
    writeVideo(v, getframe(fig1));
    
    end
end
close(v)