function cal_stone_size
% MAIN_CAL_STONE_SIZE This function calculates: (1) the distribution of stones;
% (2) The block area ratio. 
% SEE shortest_path_from_picture.m
% 09 Nov, 2019  
% Shenghan Zhang <shenghan.zhang@epfl.ch>

clear variables;
clc;
% addpath(genpath('Y:\06_File_Transfer\For_Shenghan\Pattern_analysis_for_Shenghan\'))
addpath(genpath('..\Tools\'))
addpath('..\Cal_Visibility')
addpath(genpath('..'));
%% PARAMETERS DEFINITION
opt_input = 'paper'; % choose between 'example' or 'paper'
opt_figure = 2;
if (strcmp(opt_input,'paper'))
    folder='..\..\Italian topologies\'; % Folder in which the picture is
    %file = {{'TypoA.png'},{'TypoD.png'}};
    %file = {{'TypoA.png','TypoAN1.png','TypoAN2.png','TypoAN3.png'}, {'TypoB.png','TypoBN1.png','TypoBN2.png','TypoBN3.png'},{'TypoC.png','TypoCN1.png','TypoCN2.png','TypoCN3.png'},{'TypoD.png','TypoDN1.png','TypoDN2.png','TypoDN3.png'},{'TypoE.png','TypoEN1.png','TypoEN2.png','TypoEN3.png'}};
    % file = {{'TypoA.png','TypoAN1.png','TypoAN2.png','TypoAN3.png'},...
    %         {'TypoB.png','TypoBN1.png','TypoBN2.png','TypoBN3.png'},...
    %         {'TypoC.png','TypoCN1.png','TypoCN2.png','TypoCN3.png'},...
    %         {'TypoD.png','TypoDN1.png','TypoDN4_3.png','TypoDN5_5.png'},...
    %         {'TypoE.png','TypoEM1.png','TypoEM3.png','TypoEM5.png'}};
    file = {{'TypoAN1.png','TypoAN2.png','TypoAN3.png'},...
            {'TypoBN1.png','TypoBN2.png','TypoBN3.png'},...
            {'TypoCN1.png','TypoCN2.png','TypoCN3.png'},...
            {'TypoDN1.png','TypoDN4_3.png','TypoDN5_5.png'},...
            {'TypoEO1.png','TypoEO3.png','TypoEO5.png'}};
elseif (strcmp(opt_input,'example'))
    % folder='.\';
    folder='';
    file = {{'MySavedPlot1.png'}};
end
stone_size_file = cell(length(file),3);
stone_size_ratio_tot = zeros(length(file),3);
stone_size_ratio_indvd = zeros(length(file),3);
pic_type = 'bw'; % Type of the picture : 'bw' if the stones are darker than the mortar, 'wb' for the opposite
first_pic_diff= false; % If true, the pic_type is overiden. 
Lx=1.0; % Length of the picture
Ly=1.0; % Height of the picture

% RESAMPLING OPTIONS
dl=0.02;% If necessary, put non-zero value to add a mortar layer
min_vertices=5; % Minimum number of vertices by stone
l_edges=0.01; % Length of the resampled edges of the polygons
span=1; % Span of the averaging of the vertices coordinates during resampling
do_resample = true;

%% CALCULATING THE STONE SIZE DISTRIBUTION 
addpath(genpath('..'));
for f = 1:length(file)
    for e = 1:length(file{f})
        file_name = file{f}{e};
        disp(file_name);
        if first_pic_diff
            if e == 1
                pic_type = 'wb';
            else
                pic_type = 'bw';
            end
        end
        [polygons]=get_polygons_from_picture(folder,file_name,pic_type,Lx,Ly,dl); % Get the polygons from BW picture
        polygons = resizePolygon(polygons,dl);
        if do_resample
            resampled_stones=resample_polygons(polygons,min_vertices,l_edges,span); % Resampling + Deleting redundant vertices
        end 
        fig1 = figure;
        %          plot( [0,1.04,1.04,0, 0] , [0,0,1.04,1.04, 0], 'k','linewidth',1.5);
        hold on
        for s = 1:length(resampled_stones)
            r_stone = resampled_stones{s};
            if opt_figure == 1
                plot(r_stone(:,1),r_stone(:,2))
            elseif opt_figure == 2
                % patch( r_stone(:,1), r_stone(:,2),[0.8 0.8 0.8]);
                patch( r_stone(:,1), r_stone(:,2), 0.1*ones(length(r_stone(:,1)),1), ...
                    'k' , 'EdgeColor' , [0 0 0] , 'FaceColor' , [0.8 0.8 0.8] , 'linewidth' , 1.5);
                %  patch( r_stone(:,1), r_stone(:,2),0.1*ones(size(r_stone,1),1),'k' , 'EdgeColor' , [0 0 0] , 'FaceColor' , [0.8 0.8 0.8] , 'linewidth' , 1.5 );
                % fill( r_stone(:,1), r_stone(:,2),0.1*ones(size(r_stone,1),1), [0.8 0.8 0.8]);
            end
        end
        tol = 1e-2;
        are_equ = @(a,b)(abs(a-b)<tol);
        area = [];
        area_bb = [];
        count_boun = zeros(4,1);
        min_max = zeros(4,length(polygons));
        for i = 1:length(polygons)
            coord_i = polygons{i};
            min_max(:,i) = [min(coord_i(:,1)),max(coord_i(:,1)),min(coord_i(:,2)),max(coord_i(:,2))];
        end
        min_x = min(min_max(1,:));
        max_x = max(min_max(2,:));
        min_y = min(min_max(3,:));
        max_y = max(min_max(4,:));
        for i = 1:length(polygons)
            coord_i = polygons{i};
            if ~(are_equ(max(coord_i(:,1)),max_x)||...
                    are_equ(max(coord_i(:,2)),max_y)||...
                    are_equ(min(coord_i(:,1)),min_x)||...
                    are_equ(min(coord_i(:,2)),min_y))
                area_i = polyarea(coord_i(:,1),coord_i(:,2));
                bb = fcn_minBoundingBox([coord_i(:,1), coord_i(:,2)]');
                area_bb_i = polyarea(bb(1,[1:4 1]), bb(2,[1:4 1]));
                if opt_figure == 1
                    plot(bb(1,[1:4 1]), bb(2,[1:4 1]),'b-');
                elseif opt_figure == 2
                    plot(bb(1,[1:4 1]), bb(2,[1:4 1]),'r', 'linewidth' , 0.5);
                    
                end
                area = [area area_i]; % getting the sum of the areas of the stone 
                area_bb = [area_bb area_bb_i]; % getting the sum of the areas of the bounding box
                %                 min_max(:,i) = [min(coord_i(:,1)),max(coord_i(:,1)),min(coord_i(:,2)),max(coord_i(:,2))];
            end
            %              print(fig,'bonding_box','-dpdf')
            if are_equ(max(coord_i(:,1)),max_x)
                count_boun(1) = count_boun(1)+1;
            end
            if are_equ(max(coord_i(:,2)),max_y)
                count_boun(2) = count_boun(2)+1;
            end
            if are_equ(min(coord_i(:,1)),min_x)
                count_boun(3) = count_boun(3)+1;
            end
            if are_equ(min(coord_i(:,2)),min_y)
                count_boun(4) = count_boun(4)+1;
            end
        end
        %             set(gca,'children',flipud(get(gca,'children')))
        axis equal;
        set(fig1.CurrentAxes,'visible','off');
        axis([0.019 1.025 0.019 1.025])
        paperunits='centimeters';
        filewidth=5.;%cm
        fileheight=5.;%cm
        filetype='pdf';
        res=300;%resolution
        scale = 1.0;
        size=[filewidth fileheight]*scale;
        set(gcf,'paperunits',paperunits,'paperposition',[0 0 size]);
        set(gcf, 'PaperSize', size);
        print(gcf,'filename','-dpdf','-r0')
        %             saveas(gcf,'bonding_box2',filetype)
        count_boun;
        stone_size_file{f,e}=area;
        stone_size_ratio_tot(f,e) = sum(area)/sum(area_bb);
        stone_size_ratio_indvd(f,e) = sum(area./area_bb)/length(area);
    end
end
%% PLOTTING THE FIGURE ONLY IF WE HAVE THE PAPER OPTION
%
if (strcmp(opt_input,'paper'))
    figure
    % This figure plot the block area ratio v.s. stone typology 
    hold on
    for f = 1:length(file)
        for e = 1:length(stone_size_ratio_tot(f,:))
            plot(f,stone_size_ratio_tot(f,e),'s')
        end
    end
    xticks([1 2 3 4 5])
    xticklabels({'A','B','C','D','E'})
    xlabel('stone typology')
    ylabel('sum(stone\_area) / sum(bounding\_box\_area)')
    % ylabel('sum(stone\_area / bounding\_box\_area)/nb\_stones')
    %%
    stone_std_file_ = cell(length(file),1);
    opt_seperate_samples = true;
    stone_size_file_= cell(length(file),1);
    area_tot_ = [];
    for f = 1:length(file)
        area_=[];
        for e = 1:length(file{f})
            if e==1
                area = stone_size_file{f,e};
                stone_std_file_{f} = area;
            else
                area = stone_size_file{f,e};
                area_ = [area_, area];
            end
        end
        area_tot_ = [area_tot_, area_];
        stone_size_file_{f} = area_;
    end
    typology = {'A','B','C','D','E'};
    
    %%
    %
    
    h = figure;
    % This figure plots, for each typolgy, the CDF of stone size
    % distributoin. 
    % Note that we assume that the first picture in each subarry is the
    % reference typology 
    set(gca,'fontsize',14)
    hold on
    for f = 1:length(file)
        [s1,c1] = sort_stones(stone_std_file_{f});
        [s2,c2] = sort_stones(stone_size_file_{f});
        subplot(2,3,f)
        line1 = plot(s1,c1,'--','linewidth',2);
        hold on
        if opt_seperate_samples
            for e = 1:length(file{f})-1
                [s2,c2] = sort_stones(stone_size_file{f,e+1});
                line2 = plot(s2,c2,'r');
            end
        else
            line2 = plot(s2,c2);
        end
        %     xlabel('stone size')
        %     ylabel('CDF')
        xlim([0 0.08])
        str = sprintf('Typology %s',typology{f});
        title(str);
    end
    hL = legend([line1,line2],{'reference','generated'});
    newPosition = [0.7 0.2 0.2 0.2];
    newUnits = 'normalized';
    set(hL,'Position', newPosition,'Units', newUnits);
    h1 = subplot(2,3,1);
    h4 = subplot(2,3,4);
    
    p1 = get(h1,'position');
    p2 = get(h4,'position');
    height = p1(2)+p1(4)-p2(2);
    h3 = axes('position',[p2(1) p2(2) p2(3) height],'visible','off');
    hy_label=ylabel('CDF','visible','on');
    h6 = subplot(2,3,6);
    p3 = get(h6,'position');
    width = p3(1)+p3(3)-p2(1);
    h4 = axes('position',[p2(1) p2(2) width p2(4)],'visible','off');
    hx_label=xlabel('stone size (m^2)','visible','on');
    delete(h6)
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
end
end

function [size, cdf] = sort_stones(data)
area_ = data;
area_s = sort(area_);
size = area_s;
tot_stone = length(data);
cdf = (1:length(data))/length(data);
end
