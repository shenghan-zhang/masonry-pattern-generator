clear all;
close all;
clc;

addpath(genpath('..'));

n=50;
corr.n_random_field=n;
corr.name = 'exp';
corr.c0 = [10,10];
corr.sigma = 50;
trunc=40;
mean_var=0.08;
sigma_final=15;
m=n;
n=n;
xq = linspace(0,1,m);
yq = linspace(0,1,n);
[Xq,Yq] = meshgrid(xq,yq);
xx = linspace(0,1,corr.n_random_field);
yy = linspace(0,1,corr.n_random_field);
[X,Y] = meshgrid(xx,yy);
mesh = [X(:) Y(:)];

[ variability,KL] = randomfield( corr,mesh,'trunc', trunc,'mean',mean_var );
variability=reshape(variability,corr.n_random_field,corr.n_random_field);
varbis=variability/corr.sigma*sigma_final;
varbis=(varbis+1)*mean_var;
surf(Xq,Yq,varbis);
title(['Sigma = ', num2str(corr.sigma),',   L_{c0} = ', num2str(corr.c0),',   trunc = ',num2str(trunc),',     sigma_{final} = ', num2str(sigma_final)]);