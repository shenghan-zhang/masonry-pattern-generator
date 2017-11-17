function [p_,int_lock_] = plot_shortest_path( A,C_,xy,environment,vlim ,point_start_end,file_name,test_conv,wait_for)
% PLOT_SHORTEST_PATH plot the environnement and allows the user to pick a starting and ending point to compute shortest path
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - A      : Adjacency matrix
%  - xy     : Nx2 tab of the x-y coordinates of the vertices
%  - ref_tab: ref_tab is a data structure containing two columns and that
%             allows to know if two nodes are neighbors on a stone or not.
%             The first column contains the number of the stone, the second
%             column contains the id of the current vertex and the last
%             column contains the number of vertices of the current stone.
%  - alpha  : alpha is a multplying factor applied to the distance traveled
%             on the interfaces. If alpha is < 1, the path found will be
%             more "stuck" to the interfaces and if alpha is >1, it will
%             prefer to go through the mortar.
%  - vlim   : Trajects on the edges of the wall are prohibited in an area
%             delimited by x<vlim*Xmax and x>(1-vlim)*Xmax
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - p      : The x-y coordinates of the normal shortest path
%  - p2     : The x-y coordinates of the shortest path with alpha-weight on
%             the travel along the interfaceals.
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : FEBRUARY 2016
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%k=1;
h1=figure;
title('Press space to select Start and Finish point for shortest path');
p_ = cell(1,length(C_));
int_lock_ = cell(1,length(C_));
k=1;
global exitt;
exitt=1;
    %Plot environment
    patch( environment{1}(:,1) , environment{1}(:,2),0.1*ones(size(environment{1},1),1) , ...
        'w','linewidth',1.5);
    maxy=max(environment{1}(:,2)); % Determine max y  coordinate for displaying values
    maxx=max(environment{1}(:,1)); % Determine max x coordinate for displaying forbidden rectangles
    pv1=-0.05*maxy; % Coordinates of the display 1
    pv2=-0.1*maxy; % Coordinates of the display 2
    for i = 2 : size(environment,2) % Plot every stone
        patch( environment{i}(:,1), environment{i}(:,2),0.1*ones(size(environment{i},1),1), ...
            'k' , 'EdgeColor' , [0 0 0] , 'FaceColor' , [0.8 0.8 0.8] , 'linewidth' , 1.5 );
    end
    forbidden_rectangle1=[0,0;0,maxy;vlim,maxy;vlim,0];
    forbidden_rectangle2=[maxx-vlim,0;maxx-vlim,maxy;maxx,maxy;maxx,0];
    patch(forbidden_rectangle1(:,1),forbidden_rectangle1(:,2),0.12*ones(4,1),'k' , 'EdgeColor' , [0 0 0] ,'FaceColor','red','FaceAlpha',.5,'linewidth' , 0.01);
    patch(forbidden_rectangle2(:,1),forbidden_rectangle2(:,2),0.12*ones(4,1),'k' , 'EdgeColor' , [0 0 0] ,'FaceColor','red','FaceAlpha',.5,'linewidth' , 0.01);
    hold on;
    if k==1;
        set(gcf,'position',[200 500 700 600]);
    end
    
    % Button to quit
    btn = uicontrol('Style', 'pushbutton', 'String', 'Close figure and leave to end of algorithm','Callback',{@fun,h1});
    disp('now I passed the button');
 while exitt==1           
    if exitt==0; % If the button has been pressed,  we quit
        disp('exitt=0');
        break;
        
    else % Else we get the shortest path
        if ~exist('point_start_end','var')
            nb_loop = 1;
        else
            nb_loop = length(point_start_end);
            p_ = cell(nb_loop,length(C_));
            int_lock_ = cell(nb_loop,length(C_));
        end
        int_lock = []; int_lock2 = []; 
        for it_p =1:nb_loop
            if ~exist('point_start_end','var')
                [SID,FID]=get_points(xy);
            else
                [SID,FID]=get_points(xy,point_start_end{it_p});
            end
            
            %Clear plot from previous test and reform window with desired properties
            %         clf;            
            hold on;
            k=k+1;
            % Coordinates of starting and ending point
            start_x=xy(SID,1);
            start_y=xy(SID,2);
            finish_x=xy(FID,1);
            finish_y=xy(FID,2);
            %Plot start and finish points.
            figure(h1);
            hold on
            h_p1=plot3( start_x , start_y , 0.3 , ...
                'o' , 'Markersize' , 9 , 'MarkerEdgeColor' , 'y' , 'MarkerFaceColor' , 'k' );
            h_p2=plot3( finish_x , finish_y , 0.3 , ...
                'o' , 'Markersize' , 9 , 'MarkerEdgeColor' , 'y' , 'MarkerFaceColor' , 'k' );
            
            
            %Compute and plot shortest path
            for a = 1:length(C_)
                C = C_(a);
                figure(h1);
                hold on
                [~,path]= dijkstra(A,C_{a},SID,FID);
                if (sum(isnan(path))==0)
                    p=xy(path,:);
                    int_lock= get_interlocking_path(p);
                    str1=strcat('Interlocking path n? : ',num2str(int_lock));
                    h_t1=text(0.3,pv1,str1,'BackgroundColor','white');
                    if a==1
                       cl = 'b';
                    else 
                       cl = 'r--';
                    end
                    h_path1=plot3( p(:,1) , p(:,2) ,0.2*ones(size(p,1),1), ...
                    cl , 'Markersize' , 12 , 'LineWidth' , 3);
                else
                    text(0.3,-0.1,'Failed Dijkstra, repick two points');
                end
                p_{it_p,a} = p;
                int_lock_{it_p,a} = int_lock;
                if (a == length(C_))&&(~exist('wait_for','var'))
                    exitt=0;
                end
            end
        end
        if exist('file_name','var')
            saveas(h1,file_name);
        end
    end
    disp('reach the end');
    if k==2
     btn2 = uicontrol('Style', 'pushbutton', 'String', 'clear previous path','Callback',{@fun2,h_path1,h_path2,h_p1,h_p2,h_t1,h_t2}); 
     btn2.Position(1)=150;
     align([btn btn2],'distribute','bottom');
    end
    if(exist('test_conv','var'))
        if (test_conv)
            return
        end 
    end 
    if exist('wait_for','var')
    disp('press any key to start over ...')
    waitfor(h1);
    end
end
end

function fun(src,event,h1)
disp('exit figure');
global exitt;
exitt = 0;
exitt
close(h1);
end

function fun2(src,event,h1,h2,h3,h4,h5,h6)
delete(h1);
delete(h2);
delete(h3);
delete(h4);
delete(h5);
delete(h6);
end