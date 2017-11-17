clear all;
close all;
clc;
addpath(genpath('../../'));

x1=[0,1];
y1=[0,1];
x2=[0,1];
y2=[1,0];
tic;
[x,y]=polyxpoly(x1,y1,x2,y2)

toc