%{
 * @file   main_crop_inside_pic.m
 *
 * @author Shenghan Zhang <shenghan.zhang@epfl.ch>
 *
 * @date creation: Mon Dec 03 2018
 * 
 * @brief 
 *  This file crops a certain number of picture with specified size from 
 *  the original large picture.  
 *
 * @section LICENSE
 *
 * Copyright (©) 2013-2018 EPFL (Ecole Polytechnique Fédérale de Lausanne) 
 * Laboratory (EESD - Earthquake Engineering and Structural Dynamics Laboratory)
 * More information can be found on our website <https://eesd.epfl.ch/>.
 *
 * This file is distributed under the GNU Lesser General Public License.
 * The detailed information can be found in <http://www.gnu.org/licenses/>.
 *
 %}

folder='..\Saved_Pictures_temp_martin\A\';
name='A_1_copy.png';
output_name_first = 'cut_A_1_'; 
% note that for matlab image, the origin point starts at the up left
% corner, the first dimension indicates the horizontal direction (from left 
% to right) and the second dimension indicates the vertical direction (from
% top to bottom) 
full_image = imread(strcat(folder,name));  
cut_image_to_full_image_ratio = 0.5;  
edge_ratio = 1 - cut_image_to_full_image_ratio; 
nb_length_full_image = size(full_image,1); 
nb_height_full_image = size(full_image,2);
nb_length_cut_image = floor(nb_length_full_image*cut_image_to_full_image_ratio); 
nb_height_cut_image = floor(nb_height_full_image*cut_image_to_full_image_ratio);
start_nb_length = floor(nb_length_full_image*edge_ratio/2); 
start_nb_height = floor(nb_height_full_image*edge_ratio/2); 
nb_cut_samples = 10; 
noises = (rand(nb_cut_samples,1)-0.5)*2; % generate noise in (-1,1)
% noises = -1:(2/(noises-1)):1; 
for index_cut_pic = 1:nb_cut_samples
    index_noise_length_in_pixels = floor(noises(index_cut_pic)*start_nb_length); 
    index_noise_height_in_pixels = floor(noises(index_cut_pic)*start_nb_height); 
    index_start_nb_length = start_nb_length + index_noise_length_in_pixels; 
    index_start_nb_height = start_nb_height + index_noise_height_in_pixels;
    cut_image = full_image(index_start_nb_length:(index_start_nb_length + nb_length_cut_image),...
                           index_start_nb_height:(index_start_nb_height + nb_height_cut_image),:);
    imwrite(cut_image,strcat(folder,sprintf('%s%d',output_name_first,index_cut_pic),'.png'),'png');
%     figure
%     image(cut_image)
end

