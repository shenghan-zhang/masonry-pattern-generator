function [ eroded_pos,del_stones ] = erode_stones( pos_tab_shaken,contact_points,row_vec,file_params)
% ERODE_STONES  function that erodes all the stones
%
% It goes through all the stones and erode them sequentially. It takes into
% account that small bricks can disappear if eroded too much.
%
% %%%%%% usage %%%%%%
% %% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - pos_tab_shaken : A M cells arrray containing the nodes of the stones
%  - contact_points : Px3 matrix containing the coordinates of the contact
%                     points in the two first columns, and the lengths of
%                     the edges concerned in the third column.
%  - row_vec        : a Mx1 vector containing the indices of the rows of
%                     the stones.
%
% %% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - eroded_pos     : A M-k cells array containing the nodes of the eroded
%                     stones (k have been completely erased)
%  - del_stones     : An kx1 array containing the Id of the deleted stones.
%
% %% AUTEUR : Martin HOFMANN
% %% DATE   : November 2015
% See also ERODE_POLYGON
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
del_stones=[];
stonesNumber=length(pos_tab_shaken);
eroded_pos=cell(1,stonesNumber);
A=zeros(1,stonesNumber);
pe=zeros(1,stonesNumber);
dl=zeros(1,stonesNumber);
dlVarType=cell(1,stonesNumber);
AThreshold=zeros(1,stonesNumber);
mean_durability=zeros(1,stonesNumber);
r=zeros(1,stonesNumber);
corr=cell(1,stonesNumber);
seuil_area=zeros(1,stonesNumber);
a=zeros(1,stonesNumber);
b=zeros(1,stonesNumber);
seuil_contact=zeros(1,stonesNumber);
reordering_method=cell(1,stonesNumber);
factor=zeros(1,stonesNumber);
n_pixels=zeros(1,stonesNumber);
hbar = parfor_progressbar_v1(stonesNumber,['Computing erosion of ',num2str(stonesNumber),' stones']);  %create the progress bar
parfor i=1:stonesNumber % Iteration on all the stones
    % Display number of stone being eroded
    %     counter(i)=sum(~cellfun('isempty',eroded_pos))
    %     str{i}=['Eroding stone ', num2str(i),'/',num2str(length(pos_tab_shaken))];
    %     disp(sprintf([str,'\n']));
    %     eff=repmat('\b',1,length(str)+2);
    % Initialization
    poly=pos_tab_shaken{i};
    c_points=contact_points{i};
    xm=mean(poly(:,1));
    ym=mean(poly(:,2));
    A(i)=get_area_polygon(poly);
    
    [pe(i), dl(i),n_pixels(i),dlVarType{i},dlRandRange(i),AThreshold(i),mean_durability(i), r(i), corr{i},seuil_area(i),a(i),b(i),seuil_contact(i),reordering_method{i}]=get_params_erosion([xm,ym],row_vec(i,1),A(i),file_params);
    
    switch dlVarType{i}
        
        case 'constant'
            
        case 'rand'
            
            dl(i)=randi([100-dlRandRange(i),100+dlRandRange(i)])*dl(i)/100;
            
        case 'AProportional'
            
            A(i)=get_area_polygon(poly);
            factor(i)=(1-A(i)/AThreshold(i))*0.2+1;
            dl(i)=dl(i)*factor(i);
            
    end
    
    
    
    % Erosion
    if get_area_polygon(poly)>0.0001 % If the area is greater than 1 cm^2 (else we delete the stone directly)
        
        [x,y]=erode_polygon(poly(:,1),poly(:,2),dl(i),n_pixels(i),mean_durability(i),pe(i),r(i),corr{i},seuil_area(i),c_points,a(i),b(i),seuil_contact(i),reordering_method{i});
        new_pol=[x,y];
        
    else
        
        new_pol=[];
        
    end
    
    % Adding to the new eroded stones array of cells.
    if isempty(new_pol)==0
        
        eroded_pos{1,i}=new_pol;
    else
        
        del_stones=[del_stones,i];
        
    end
    
    hbar.iterate(1);
    
end
close(hbar);   %close progress bar
eroded_pos(del_stones)=[];

