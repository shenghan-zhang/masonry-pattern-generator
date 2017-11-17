clear ;
close all;
clc;
addpath(genpath('../../'));
p1=[0,0];
p2=[0,1];
p3=[1,1];
a=getAngleVectors(p1,p2,p3);
if a~=pi/2
    disp('test 1 failed');
end

p1=[0,0];
p2=[1,0];
p3=[2,0];
a=getAngleVectors(p1,p2,p3);
if a~=pi
    disp('test 2 failed');
end

p1=[0,0];
p2=[0,1];
p3=[-1,1];
a=getAngleVectors(p1,p2,p3);
if a~=3*pi/2
    disp('test 3 failed');
end

p1=[0,0];
p2=[1,0];
p3=[1,1];
a=getAngleVectors(p1,p2,p3);
if a~=3*pi/2
    disp('test 4 failed');
end

p1=[0,0];
p2=[1,1];
p3=[2,2];
a=getAngleVectors(p1,p2,p3);
if a~=pi
    disp('test 5 failed');
end

p1=[0,0];
p2=[0,1];
p3=[-1,2];
a=getAngleVectors(p1,p2,p3);
if a~=5*pi/4
    disp('test 6 failed');
end