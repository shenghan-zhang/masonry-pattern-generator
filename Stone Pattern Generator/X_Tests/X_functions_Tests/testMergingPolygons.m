clear;
close all;
clc;
addpath(genpath('../../'));
posTab=[0,0;...
    0,1;...
    1,1;...
    1,0;...
    1,1.2;...
    2,1.2;...
    2,0;...
    0,3;...
    1,3;
    2,3];
colors=create_colors(5);
row_vec=[1;1;1;1];
Lx_wall=2;
Ly_wall=3;
epsilon=0.00001;
limitAngleMerging=1.6*pi;
mergingRate=100;
ratioMerging=1.2;

stonesNodes={[1,2,3,4],[4,3,5,6,7],[2,8,9,3],[5,9,10,6]};

for i=1:size(stonesNodes,2)
    stones_pos{i}=posTab(stonesNodes{i},:);
end
draw_stones(stones_pos,2,2,3,colors,'LineWidth',0.5);


[posTabOut,stonesNodesOut ] = mergePolygons( posTab,stonesNodes,row_vec,Lx_wall,Ly_wall,epsilon,limitAngleMerging,mergingRate,ratioMerging );
for i=1:size(stonesNodesOut,2)
    stones_pos{i}=posTab(stonesNodesOut{i},:);
end
draw_stones(stones_pos,2,2,3,colors,'LineWidth',0.5);

