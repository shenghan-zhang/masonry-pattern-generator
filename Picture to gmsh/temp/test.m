close all 
clc
poly_coods1 = [0 0 
               0.25 0
               0.5 0 
               0.5 0.25
               0.5 0.5
               0.25 0.5
               0 0.5
               0 0.25];
           
[x1, y1] = poly2cw(poly_coods1(:,1),poly_coods1(:,2));

poly_coods2 = [0 0
               1.0 0
               1.0 1.0
               0 1.0];
[x2, y2] = poly2cw(poly_coods2(:,1),poly_coods2(:,2));

poly_coord3 = [0.25 0.25
               0.75 0.25
               0.75 0.75
               0.25 0.75];
[x3, y3] = poly2cw(poly_coord3(:,1),poly_coord3(:,2));

poly_coord4 = [0.9 0.5
               1.0 0.5
               1.0 0.6
               0.9 0.6];
[x4, y4] = poly2cw(poly_coord4(:,1),poly_coord4(:,2));


poly_coord5 = [0. 0.9
               0. 0.8
               0.2 1.0
               0.1 1.0];
[x5, y5] = poly2cw(poly_coord5(:,1),poly_coord5(:,2));


[xd, yd] = polybool('subtraction', x2, y2, x1, y1);
[xd, yd] = polybool('subtraction', xd, yd, x4, y4);
figure
patch(xd, yd, 1, 'FaceColor', 'r')

figure
plot(xd, yd,'o')
[xd, yd] = polybool('subtraction', xd, yd, x5, y5);
coord_xd = [xd, yd];





[xd2, yd2] = polybool('subtraction', x2, y2, x3, y3);



patch(xd2, yd2, 1, 'FaceColor', 'b')

