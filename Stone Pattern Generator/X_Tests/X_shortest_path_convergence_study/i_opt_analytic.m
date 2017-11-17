clear;
close all;
clc;
% See shortest path justification powerpoint for explanation about the
% formula used here (I derived the cost to find optimal x and with this
% optimal x computed the interlocking). 
alpha=linspace(0,1,10000);

L=0.14;
H=0.06;
e=0.01;

I=(H+sqrt((alpha.^2*e^2)./(1-alpha.^2)+e^2)+(L-e)/2-sqrt((alpha.^2*e^2)./(1-alpha.^2)))./(H+e);
plot(alpha,I);
xlabel('alpha');
ylabel('Theoretical Interlocking');
