clear all;
clc;
close all;
addpath(genpath('../../'));

Pos_tab=[0,0;0,1;1,1;1,0;];
stones_nodes={[1,2,3,4]};
row_vec=[1];
divide_stone(Pos_tab,stones_nodes,1,row_vec,1);
