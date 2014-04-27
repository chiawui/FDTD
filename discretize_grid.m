function [x,y]=discretize_grid(x_dimension, y_dimension, cell_size)

  dx=cell_size;  %all axis use the element size, for different cell size in 
                 %another dimension, use scaling 
  x=0:dx:(x_dimension);
  y=0:dx:(y_dimension);
  
end