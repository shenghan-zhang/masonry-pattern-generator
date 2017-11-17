## Masonry pattern generator

### About the program

This repository contains the Matlab file for generating different masonry topologies, analysing the line of minimum trace from picture, and generating finite element mesh from (already segmented) pictures. 

* To generate new patterns, start with the file **.\Picture to gmsh\pic_to_mesh.m** where you can also find the input for generating the 5 topologies defined in the Italian code. 

* To obtain the shortest path form picture, start with the file **.\Stone Pattern Generator\Scripts\shortest_path_from_picture.m**

* To obtain a GMSH geo file from pictures, start with the file **.\Picture to gmsh\pic_to_mesh.m**

Some documentation can be found in folder **.\Documentation**. Further information can be found in our paper. Please consider citing it if you found it to be useful. 

>_Shenghan Zhang, Martin Hofmann, Katrin Beyer. A 2D typology generator for historical masonry elements. Construction and Building Materials. (submitted)_

### About licence

The program is freely available under the LGPL licence: 
  
Copyright (©) 2017 EPFL (Ecole Polytechnique Fédérale de Lausanne) Laboratory (EESD - Earthquake Engineering and Structural Dynamics Laboratory) 
  
The program is free: you can redistribute it and/or  modify it under the terms  of the  GNU Lesser  General Public  License as  published by  the Free Software Foundation, either version 3 of the License, or (at your option) any later version. 
  
We share the program  in the  hope that it  will be useful, but  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A  PARTICULAR PURPOSE. See the [GNU Lesser General Public License](http://www.gnu.org/licenses/) for more details. 