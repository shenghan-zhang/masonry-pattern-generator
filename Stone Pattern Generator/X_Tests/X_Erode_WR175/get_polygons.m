%% Script that takes an image as an input and allows the user to pick the polygons on the image. 


clear all;
% close all;
clc;
h=figure;
I = imread('WR175_1_shaken_pattern.png');
dx=1/size(I,2);
dy=1.2/size(I,1);
nadd=round(0.02/dy);

I=[zeros(nadd,size(I,2),3);I;zeros(nadd,size(I,2),3)];
I=[zeros(size(I,1),nadd,3),I,zeros(size(I,1),nadd,3)];
imshow(I);
hold on;


plot([-0.02,-0.02,1.02,1.02,-0.02],[-0.02,1.22,1.22,-0.02,-0.02]);
isOver=0;
k=1;
xc=linspace(-0.02,1.02,size(I,2));
yc=linspace(-0.02,1.22,size(I,1));
while isOver==0
h = impoly(gca);
pos=getPosition(h);
x=pos(:,1);
y=pos(:,2);
k=k+1;
polygons{k}=[x,y];
fill(x,y,'r');
hold on;
end

figure, imshow(I)
figure, imshow(BW)
