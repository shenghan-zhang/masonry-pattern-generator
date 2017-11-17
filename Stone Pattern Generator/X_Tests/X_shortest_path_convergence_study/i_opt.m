% This script allow to compute the optimal interlocking in a regular masonry pattern. 
% Here below is a script of the situation. The cost of this path is
% definded by C=sqrt(x^2+e^2)+((L-e)/2-x+H)*alpha.
% and the interlocking is defined by I=(L/2-e/2-x_min+sqrt(e^2+x_min^2)+H)/(H+e)
%                               ||
%                               ||
%                               ||
%_______________________________||      _
%                     -----------'      |    
%                    /                  |
%                   /                   e
%                  /                    |
%  _______________/                     |
%-------------------------------------------------.
%                 |-x-|
clear all;
close all;
clc;

e=0.01;
L=0.14;
H=0.06;

alpha=linspace(0,1,10001);
x=linspace(0,L/2-e/2,20000); % x is the horizontal projection of the diagonal path
figure;
hold on;
for i=1:length(alpha)
    C=alpha(i)*(L/2-e/2-x)+sqrt(e^2+x.^2); % Compute the costs of the different ways
    [C_min,i_min_c]=min(C);
    x_min=x(i_min_c);
%     plot(x,C);
%     plot(x_min,C_min,'ro');
%     text_leg{i}=['alpha = ',num2str(alpha(i))];
    I(i)=(L/2-e/2-x_min+sqrt(e^2+x_min^2)+H)/(H+e);
end
%     legend(text_leg);
    figure;
    plot(alpha,I);
    xlabel('Alpha');
    ylabel('Optimum interlocking');
    