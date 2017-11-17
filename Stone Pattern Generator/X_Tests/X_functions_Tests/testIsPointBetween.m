clear;
close all;
clc;
addpath(genpath('../../'));


p1=[0,0];
p2=[0.5,0.5];
p3=[1,1];
p4=[0.5,0];
p5=[0,0.5];
p6=[1,0];
p7=[0,1];
p8=[2,2];

epsilon=0.01;
p9=p2+epsilon/1.7;
if isPointBetween(p1,p2,p3,epsilon);
    disp('Test 1 failed');
end

if ~isPointBetween(p2,p1,p3,epsilon);
    disp('Test 2 failed');
end

if ~isPointBetween(p4,p1,p6,epsilon);
    disp('Test 3 failed');
end
if ~isPointBetween(p4,p6,p1,epsilon);
    disp('Test 4 failed');
end
if ~isPointBetween(p5,p1,p7,epsilon);
    disp('Test 5 failed');
end
if isPointBetween(p1,p5,p7,epsilon);
    disp('Test 6 failed');
end
if isPointBetween(p8,p1,p2,epsilon);
    disp('Test 7 failed');
end
if ~isPointBetween(p9,p1,p3,epsilon);
    disp('Test 8  failed');
end