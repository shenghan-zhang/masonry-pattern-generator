function [pe, dl,n_pixels,dlVarType,dlRandRange,AThreshold,mean_durability, r, corr,seuil_area,a,b,seuil_contact,reordering_method] = get_params_erosion(pos,ind_row,A,file_params)
% GET_PARAMS_EROSION will return the parameters of the erosion process, if needed according to the position of the stone.
%
% %%%%%% usage %%%%%%
%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - pos     : postion of the stone
%  - row_ind : index of the row
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - pe  : the volumetric part of the equation is risen to the power
%          pe (the more elevated, the more roundness will appear, if 0
%          the edges will stay straight)
%  - dl       : aimed erosion on straight lines
%  - mean_durability : The mean aimed durability (! Should not be below
%               0.02, if not the algorithm does not give good results.
%  - r        : the radius of the bubble
%  - seuil_area : if the ratio between the area of the eroded polygon and
%               the area of the original polygon goes under this value,
%               erosion will stop.
%  - a        : length of the zone where the damping function is 0
%               around the contact point.
%  - b        : length of the zone till which the damping function
%               grows linearly till 1.
%  - seuil_contact: limit on the edge length, if the edge is <
%               seuil_contact, there is no contact point on this edge.
%  - reordering_method : 'angular' for angular reordering and
%               'nearest_neighbor' for nearest_neighbor reordering of the nodes after
%               the erosion process
%  - corr.    : struct containing info concerning the random field used to
%               generate the durability function.
%        name : 'gauss' for gaussian, 'exp' for exponential or 'turb' for
%               turbulent
%        c0   : The scaling parameters for the correlation function. c0 may
%               be a scalar for isotropic correlation or a vector for
%               anisotropic correlation. In the anisotropic case, the
%               vector must have d elements, where d is the dimesion of a
%               mesh point.
%        c1   : The second scaling parameters for the 'turbulent'
%               correlation function. Not used with 'gauss' or 'exp'.
%
%        sigma: The variance scaling parameter. May be a scalar or a vector
%               the size of the mesh.
%
%        C     :The correlation matrix between the unknown elements of the
%               field. If the precomputed correlation matrix fits into
%               memory, this is the best option.
%
%        A     :The correlation matrix between data points.
%
%        B     :The correlation matrix between data points and unknowns.
%               The code expects this to be structured so that rows
%               correspond to mesh points and columns correspond to data
%               points.
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=pos(1);
y=pos(2);
%%
in_dedicated_function = 'erosion';
eval(file_params);%parameters_stone_masonry;
%% PARAMETERS DEFINTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
opt = option; % Choose between 'uniform' and 'by_pos'
switch opt
    case 'uniform'
        pe = pe_; % is used in the erosion process (erode_polygon.m  l170 :  state(ind_i,ind_j)=state(ind_i,ind_j)-damping_values(j)*exposure(j)^pe/durability(ind_i,ind_j);
        dl = len_erosion;
        n_pixels = n_pixels_;
        dlVarType = dlVarType_; % 'constant' 'rand', 'AProportional'
        dlRandRange = dlRandRange_;
        AThreshold = AThreshold_;
        mean_durability = mean_durability_;
        r = r_;
        corr.n_random_field = corr_n_random_field;
        corr.name = corr_name;
        corr.c0 = corr_c0;
        corr.sigma = corr_sigma;
        seuil_area = seuil_area_;
        a = a_;
        b = b_;
        seuil_contact = seuil_contact_;
        reordering_method = reordering_method_; % 'angular' or 'nearest_neighbor'
        
    case 'by_area'
        
        if A>thres_area_2
            pe = pe_(1);
            dl=len_erosion(1);
            corr.c0 = corr_c0(1);
            corr.sigma = corr_sigma(1);
        else
            pe = pe_(2);
            dl=len_erosion(2);
            corr.c0 = corr_c0(2);
            corr.sigma = corr_sigma(2);
            
        end
        
        dlVarType = dlVarType_; % 'constant' 'rand', 'AProportional'
        dlRandRange = dlRandRange_;
        AThreshold = AThreshold_;
        mean_durability = mean_durability_;
        n_pixels = n_pixels_;
        r = r_;
        corr.n_random_field = corr_n_random_field;
        corr.name = corr_name;
        seuil_area = seuil_area_;
        a = a_;
        b = b_;
        seuil_contact = seuil_contact_;
        reordering_method = reordering_method_;
    case 'by_row'
        
        % CONSTANT PARAMETERS
        n_pixels=140;
        mean_durability=0.08;
        r=0.02;
        dlVarType='constant'; % 'constant' 'rand', 'ATreshold', 'AProportional'
        dlRandRange=20;
        AThreshold=[0.05,0.01,0.02,1,2];
        corr.n_random_field=30;
        corr.name = 'gauss';
        corr.c0 = 0.0001;
        corr.sigma = 0.5;
        seuil_area=0.5;
        a=0.1;
        b=0.25;
        seuil_contact=0.45;
        reordering_method='angular';
        
        % PROPERTIES ASSIGNMENT BY ROW
        pes(1,[1,2,6,10,14,15])=0.5;
        pes(1,[3,4,5,7,8,9,11,12,13])=0.5;
        dls(1,[1,2,6,10,14,15])=0.002;
        dls(1,[3,4,5,7,8,9,11,12,13])=0.005;
        pe=pes(1,ind_row);
        dl=dls(1,ind_row);
        
    case 'by_pos'
        
        % CONSTANT PARAMETERS
        mean_durability=0.08;
        r=0.02;
        n_pixels=140;
        dlVarType='constant';
        dlRandRange=20;
        AThreshold=[0.05,0.01,0.02,1,2];
        corr.n_random_field=30;
        corr.name = 'gauss';
        corr.c0 = 0.0001;
        corr.sigma = 0.5;
        seuil_area=0.5;
        a=0.1;
        b=0.25;
        seuil_contact=0.45;
        reordering_method='angular'; % 'angular' or 'nearest_neighbor'
        
        % ZONES DEFINITION
        aa=2*0.0625;
        bb=aa+2*0.03125;
        cc=bb+aa;
        dd=cc+bb-aa;
        ee=dd+aa;
        ff=ee+bb-aa;
        gg=ff+aa;
        hh=gg+bb-aa;
        
        % ASSIGNEMENT OF PROPERTIES BY ZONE
        if (y>=0 && y<aa) || (y>=bb && y<cc) || (y>=dd && y<ee) || (y>=ff && y<gg) || y>=hh
            pe=5;
            dl=0.002;
        elseif (y>=aa && y<bb) || (y>=cc && y<dd) || (y>=ee && y<ff) || (y>=gg && y<hh)
            pe=0;
            dl=0.003;
        elseif (y>=bb && y<cc) ||  (y>=ff && y<gg)
            pe=10;
            dl=0.001;
        end
    case 'testBattery'
        load('parametersErosionTestBattery3.mat');
        pe=p(counter);
        dl=0.009;
        n_pixels=140;
        dlVarType='constant';
        dlRandRange=20;
        AThreshold=[0.05,0.01,0.02,1,2];
        mean_durability=0.1;
        r=0.02;
        corr.n_random_field=50;
        corr.name = 'gauss';
        corr.c0 = Cl(counter);
        corr.sigma = sigmas(counter);
        seuil_area=0.5;
        a=0.1;
        b=0.25;
        seuil_contact=0.45;
        reordering_method='angular'; % 'angular' or 'nearest_neighbor'
end
end