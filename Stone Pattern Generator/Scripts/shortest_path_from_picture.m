% SHORTEST_PATH_FROM_PICTURE This script allows the user to compute the shortest path out of a BW picture.
clear variables;
close all;
clc;


%% PARAMETERS DEFINITION
%cd(mfilename('fullpath'))
%% PICTURE PARAMETERS
folder='.\..\..\Italian topologies\'; % Folder in which the picture is
folder_read_save_data = '.\data\';
%file = {{'TypoD.png','TypoDN1.png','TypoDN2.png','TypoDN3.png','TypoDN4_3.png','TypoDN5_5.png'}};
%file = {{'TypoE.png','TypoEO1.png','TypoEO3.png','TypoEO5.png'}}; 
 file = {{'TypoA.png','TypoAN1.png','TypoAN2.png','TypoAN3.png'},... % Problematic files : BN2 DN3 DO4 TYPOE
         {'TypoB.png','TypoBN1.png','TypoBN2.png','TypoBN3.png'},...
         {'TypoC.png','TypoCN1.png','TypoCN2.png','TypoCN3.png'},...
         {'TypoD.png','TypoDN1.png','TypoDN4_3.png','TypoDN5_5.png'},...
         {'TypoE.png','TypoEO1.png','TypoEO3.png','TypoEO5.png'}};
% file = {{'TypoA.png','TypoAN1.png','TypoAN2.png','TypoAN3.png'},...
%         {'TypoB.png','TypoBN1.png','TypoBN2.png','TypoBN3.png'}}
%file = {{'TypoE.png','TypoEO1.png','TypoEO2.png','TypoEO3.png','TypoEO4.png','TypoEO5.png'}};
%file = {{'TypoDN4_3.png','TypoDN5_5.png'},{'TypoE.png','TypoEN4_1.png','TypoEN5_4.png'}};
%file = {{'TypoA.png','TypoAN1.png','TypoAN2.png','TypoAN3.png'}, {'TypoB.png','TypoBN1.png','TypoBN2.png','TypoBN3.png'},{'TypoC.png','TypoCN1.png','TypoCN2.png','TypoCN3.png'},{'TypoD.png','TypoDN1.png','TypoDN2.png','TypoDN3.png'},{'TypoE.png','TypoEN1.png','TypoEN2.png','TypoEN3.png'}};
% file = {{'TypoB.png','TypoBN1.png','TypoBN2.png','TypoBN3.png'}};

% pic_type = 'wb'; % Type of the picture : 'bw' if the stones are darker than the mortar, 'wb' for the opposite
Lx=1.0; % Length of the picture
Ly=1.0; % Height of the picture
resolution=8;

%% RESAMPLING OPTIONS
dl=0.02;% If necessary, put non-zero value to add a mortar layer
min_vertices=5; % Minimum number of vertices by stone
l_edges=0.02; % Length of the resampled edges of the polygons
span=1; % Span of the averaging of the vertices coordinates during resampling

% %% SHORTEST PATH OPTIONS
% alpha=0.3333;
% vlim=0.03;
epsilon=0.0000001; % Approximation constraint
int_lock_file = cell(size(file));
do_resample = true; 
do_skip = true; 
%% CODE
addpath(genpath('..'));
for f = 1:length(file)
    for e = 1:length(file{f})
        disp(sprintf('I am in f %d, e %d', f, e)); 
        file_name = file{f}{e};
        disp(file_name);
        if e == 1
            pic_type = 'wb';
        else
            pic_type = 'bw';
        end  
        
        [polygons]=get_polygons_from_picture(folder,file_name,pic_type,Lx,Ly,dl); % Get the polygons from BW picture
        resampled_stones=resample_polygons(polygons,min_vertices,l_edges,span); % Resampling + Deleting redundant vertices
        % [ resampled_stones ] = put_corners( resampled_stones );
        % [ resampled_stones ] = put_corners( resampled_stones );
        [resampled_stones]=fractalize_polygons(resampled_stones,1,0.01);        
        % resampled_stones = polygons;
        c=create_colors(length(resampled_stones));
        % resampled_stones=sieving(resampled_stones,0.01,c);
        draw_stones(resampled_stones,resolution,Lx,Ly,c);
        %%
        %%
        % Define parameter for shortest path
        alpha_=[0.1,1.0]; % Weight of the travel along the edges
        vlim=0.03; % Width of the forbidden zones on the left and right hand sides (it forbids the algorithm to take straight shortcuts around the wall)
        epsilonSP=0.000001; % Epsilon used while computing shortest path graph.
        point_start_end = {[0.5, 0.0; 0.5, 1.0], [0.2, 0.0; 0.2, 1.0],[0.8, 0.0; 0.8, 1.0]};
        for p_se = 1:length(point_start_end)
            point_start_end{p_se}(:,1) = point_start_end{p_se}(:,1) + dl; 
        end
        %%
        file_name_check = strcat(folder_read_save_data,strtok(file_name,'.'),'.mat');
        if (do_skip) && (exist(file_name_check, 'file'))
            disp(['load existing file', file_name_check]);
            load(file_name_check);
            %alpha_=[0.1,0.3,1.0];
            alpha_=[0.1,1.0];
        else
            [environnement,ref_tab]=make_environnement(resampled_stones,Lx+2*dl,Ly+2*dl); % Computing environnement
            tic;
            disp('Computing visibility graph...');
%             [A,C_,xy]=compute_visibility_graph_from_vis_polygon(environnement,epsilon,alpha_,vlim,ref_tab,Lx); % Computing visibility graph
            [A,C,xy]=compute_visibility_graph_from_vis_polygon(environnement,epsilon,1,vlim,ref_tab,Lx);
            [A,Calpha,xy]=compute_visibility_graph_from_vis_polygon(environnement,epsilon,alpha_(1),vlim,ref_tab,Lx);
            C_=[Calpha,C];
            vg_time=toc;
            disp(['Visibility graph computed in ',num2str(vg_time),' seconds, now getting shortest paths...']);
            save(strtok(file_name,'.'),'A','xy','ref_tab','environnement','vlim');
        end
        file_name_check_path = strcat(strtok(file_name,'.'),'_path.mat');
        if (do_skip) && (exist(file_name_check_path, 'file'))
            load(file_name_check_path);
        else
            [p_,int_]=plot_shortest_path(A,C_,xy,environnement,vlim,point_start_end,file_name);
            save(strcat(folder_read_save_data,strtok(file_name,'.'),'_path'),'p_','int_');
        end
        int_lock_file{f,e}=int_;
        % [p,p2]=plot_shortest_path(A,xy,ref_tab,environnement,alpha,vlim); % Getting shortest paths with user
    end
end

%%
inter_locking_table = zeros(length(file),length(file{1})*length(alpha_));
cal_method = 'avg';%['avg', 'mid', 'side'];
for f = 1:length(file)
    for e = 1:length(file{f})
        for a = 1:length(alpha_)
                int_ = 0;
            if strcmp(cal_method,'avg')
            for it = 1:length(point_start_end)
                int_ = int_ + int_lock_file{f,e}{it,a};
            end 
                int_ = int_/length(point_start_end);
            elseif strcmp(cal_method,'mid')
                int_ = int_lock_file{f,e}{1,a};
            end
                inter_locking_table(f,a+(e-1)*length(alpha_))=int_;
        end
    end
end
%%
% plot the figure for analysis 
x_coord = 1:length(file);
skip = [];%[2,3]+1; %[1,4]+1; %[3,4]+1;
shape_ = ['o','^','s'];
color_ = ['r','b'];
for a = 1:length(alpha_)
    h1=figure;
    hold on
    for f = 1:length(file)
        for e = 1:length(file{f})
            flag =0;
            for i = 1:length(skip)
                if (e==skip(i))
                flag =1;    
                end
            end
            if (flag==1)
                continue
            end
            if e == 1
                spc_ = strcat(color_(1),shape_(a));
            else
                spc_ = strcat(color_(2),shape_(a));
            end
               plot(f,inter_locking_table(f,a+(e-1)*length(alpha_)), spc_); 
        end
    end
    legend('reference','generated','Location','northwest')
    if a == 1
    txt1 = '\alpha = 0.1';%sprintf('alpha%0.2g',alpha_(a));
    elseif a == 2 
    txt1 = '\alpha = 1.0';
    end 

    xlabel('topology type');
    xticks([1 2 3 4 5])
    xticklabels({'A','B','C','D','E'})
    ylabel('interlocking parameter'); 
    %title(sprintf('alpha %0.1g',alpha_(a)))
    set(gca,'fontsize',14)
    box on 
    xlim([0.5 0.5+length(file)])
    xticks(1:length(file))
    h1.PaperUnits = 'centimeters';
%     if a==1
%        ylim([1.3 2.1])  
%     elseif a==2
%        ylim([1.05 1.8])  
%     end 
    ylim([1.05 2.1])
    x1 = xlim;
    y1 = ylim;
    text(x1(1)+0.8*(x1(2)-x1(1)),y1(1)+0.1*(y1(2)-y1(1)),txt1,'fontsize',14);
%     h1.PaperPosition = [0 0 7.5 4.635];
%     print(sprintf('%s_alpha0_%0.2g',cal_method,alpha_(a)*10),'-dmeta','-r0')
end 
%% END OF PROCESS
disp('End of process');

