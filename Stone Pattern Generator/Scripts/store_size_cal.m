%%
% this file is used to generate stone size CDF for the micro structural generator paper 
% Shenghan Zhang, 29.06.2017

function main
% SHORTEST_PATH_FROM_PICTURE This script allows the user to compute the shortest path out of a BW picture.
clear variables;
clc;


%% PARAMETERS DEFINITION

%% PICTURE PARAMETERS
folder='..\..\Italian topologies\'; % Folder in which the picture is
%file = {{'TypoA.png'},{'TypoD.png'}};
%file = {{'TypoA.png','TypoAN1.png','TypoAN2.png','TypoAN3.png'}, {'TypoB.png','TypoBN1.png','TypoBN2.png','TypoBN3.png'},{'TypoC.png','TypoCN1.png','TypoCN2.png','TypoCN3.png'},{'TypoD.png','TypoDN1.png','TypoDN2.png','TypoDN3.png'},{'TypoE.png','TypoEN1.png','TypoEN2.png','TypoEN3.png'}};
file = {{'TypoA.png','TypoAN1.png','TypoAN2.png','TypoAN3.png'},...
        {'TypoB.png','TypoBN1.png','TypoBN2.png','TypoBN3.png'},...
        {'TypoC.png','TypoCN1.png','TypoCN2.png','TypoCN3.png'},...
        {'TypoD.png','TypoDN1.png','TypoDN4_3.png','TypoDN5_5.png'},...
        {'TypoE.png','TypoEM1.png','TypoEM3.png','TypoEM5.png'}};
% file = {{'TypoB.png','TypoBN1.png','TypoBN2.png','TypoBN3.png'}};
stone_size_file = cell(length(file),4);
pic_type = 'wb'; % Type of the picture : 'bw' if the stones are darker than the mortar, 'wb' for the opposite
Lx=1.0; % Length of the picture
Ly=1.0; % Height of the picture
resolution=8;

%% RESAMPLING OPTIONS
dl=0.02;% If necessary, put non-zero value to add a mortar layer
min_vertices=5; % Minimum number of vertices by stone
l_edges=0.01; % Length of the resampled edges of the polygons
span=1; % Span of the averaging of the vertices coordinates during resampling

% %% SHORTEST PATH OPTIONS
% alpha=0.3333;
% vlim=0.03;
epsilon=0.0000001; % Approximation constraint

do_resample = true; 
do_skip = true; 
%% CODE
addpath(genpath('..'));
for f = 1:length(file)
    for e = 1:length(file{f})
        file_name = file{f}{e};
        disp(file_name);
        if e == 1
            pic_type = 'wb';
        else
            pic_type = 'bw';
        end  
        
        [polygons]=get_polygons_from_picture(folder,file_name,pic_type,Lx,Ly,dl); % Get the polygons from BW picture
        resampled_stones=resample_polygons(polygons,min_vertices,l_edges,span); % Resampling + Deleting redundant vertices
        tol = 1e-2;
        are_equ = @(a,b)(abs(a-b)<tol);
        area = [];
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
                area = [area area_i];
%                 min_max(:,i) = [min(coord_i(:,1)),max(coord_i(:,1)),min(coord_i(:,2)),max(coord_i(:,2))];
            end
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
        count_boun
        stone_size_file{f,e}=area;
    end
end
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

h = figure;
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
% for f = 1:length(file)
%     area_ = stone_size_file_{f};
%     area_s = sort(area_);
%     n = 9;
%     range_max = max(area_s);
%     range_min = 0;
%     incre = (range_max-range_min)/n;
%     interval = range_min:incre:range_max;
%     x_loc = (range_min+incre/2):incre:(range_max-incre/2);
%     count_W1 = zeros(n,1);
%     k = 1;
%     pre_count_W1 = 0;
%     threshold = interval(2);
%     for i = 1:length(area_s)
%         if area_s(i)>threshold
%             count_W1(k) = i-1-pre_count_W1;
%             pre_count_W1 = sum(count_W1(1:k));
%             k = k+1;
%             threshold = interval(k+1);
%             if (k==n)
%                 break
%             end
%         end
%     end
%     count_W1(k) = length(area_s)-1-pre_count_W1;
%     count_W1=count_W1/sum(count_W1)/incre;
%     figure
%     hold on
%     bar(x_loc,count_W1)
%     
% end
% disp('Here I am, reaching the end');
% 
% end
function [size, cdf] = sort_stones(data)
    area_ = data;
    area_s = sort(area_);
    size = area_s; 
    tot_stone = length(data); 
    cdf = (1:length(data))/length(data); 
end 
