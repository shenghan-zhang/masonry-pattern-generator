clear;
close all;
clc;
addpath(genpath('../../'));


pos=[0,1;...
    1,1;...
    1,0;...
    0,0;...
    1,1.5;...
    2,1.5;...
    2,0];
stonesNodes={[1,2,3,4],[5,6,7,3,2]};

xstart=0;
xend=1.5;
ystart=1;
yend=2;
xNextBricks=[0,1];
yBricks=[1,1.5];
epsilon=0.001;

[ pos, stonesNodes ] = addPentagonalBrick( xstart,xend,ystart,yend,xNextBricks,yBricks,pos,stonesNodes,epsilon )
% clear;
% close all;
% 
% pos=[0,1.5;...
%     1,1.5;...
%     1,0;...
%     0,0;...
%     1,1;...
%     2,1;...
%     2,0];
% stonesNodes={[1,2,5,3,4],[5,6,7,3]}
% 
% xstart=0;
% xend=1.5;
% ystart=1.5;
% yend=2;
% xNextBricks=[0,1];
% yBricks=[1.5,1];
% epsilon=0.001;
% 
% [ pos, stonesNodes ] = addPentagonalBricks( xstart,xend,ystart,yend,xNextBricks,yBricks,pos,stonesNodes,epsilon )
