% File: pde_1.m
% From Chapter 13 - 'Simultaneous, Nonlinear, Two-Dimensional Partial
%                    Differential Equations in Cylindrical Coordinates',
%                    of the book:
% William E Schiesser and Graham W Griffiths (2009).
% A Compendium of Partial Differential Equation Models
% - Method of Lines Analysis with Matlab,
% Cambridge University Press (ISBN-13: 9780521519861).
  function yt=pde_bioheat(t,y)
%
% Global area
  global     nr nz cell_size height outer_d   ...
             Ta k rho Cp...
             Tb wb rhob Cb...
             SAR ncall  

  b=outer_d;h=height;

% create a list of radius length at each element
  dr=cell_size;
  for i=1:nr
    r(i)=(i-1)*dr;
  end
  drs=dr^2;  
  
% 1D to 2D matrices
  for i=1:nr
    for j=1:nz
      ij=(i-1)*nz+j;
      Ta(i,j)=y(ij);
    end
  end
%
% Step through the grid points in r and z
  for i=1:nr
  for j=1:nz  
%
%   (1/r)*car, (1/r)*Tkr
    if((i==1 && j>h)||(i==b+1 &&j<h+1))
      Tar(i,j)=2.0*(Ta(i+1,j)-Ta(i,j))/drs;
    elseif(i==1 && j<h+1)
      Tar(i,j)=0.0;
    elseif(i==nr)
      Tar(i,j)=0.0;
    else
      Tar(i,j)=(1.0/r(i))*(Ta(i+1,j)-Ta(i-1,j))/(2.0*dr);
    end      
%
%   Tarr
    if((i==1 && j>h)||(i==b+1 &&j<h+1))
      Tarr(i,j)=2.0*(Ta(i+1,j)-Ta(i,j))/drs;
    elseif(i==1 && j<h+1)
      Tarr(i,j)=0.0;
    elseif(i==nr)
      Tarr(i,j)=2.0*(Ta(i-1,j)-Ta(i,j))/drs;
    else
      Tarr(i,j)=(Ta(i+1,j)-2.0*Ta(i,j)+Ta(i-1,j))/drs;
    end
%
%   Tazz
    if((j==1 && i>b) ||(j==h+1 &&i<b+1))
      Tazz(i,j)=2.0*(Ta(i,j+1)-Ta(i,j))/drs;
    elseif(j==1&& i<b+1)
      Tazz(i,j)=0.0;
    elseif(j==nz)
      Tazz(i,j)=2.0*(Ta(i,j-1)-Ta(i,j))/drs;
    else
      Tazz(i,j)=(Ta(i,j+1)-2.0*Ta(i,j)+Ta(i,j-1))/drs;
    end 
%
%   PDEs
    if((i>b&&j<h+1) || (j>h))
     Tat(i,j)=(1/Cp/rho)*(k*((Tarr(i,j)+Tar(i,j))+Tazz(i,j))-...
       ( ((wb*Cb)/(Cp*rhob))*(Ta(i,j)-Tb))+rho*SAR(i,j));
    else
      Tat(i,j)=0.0;
    end
  end
  end
%
% 2D to 1D matrices
  for i=1:nr
  for j=1:nz
    ij=(i-1)*nz+j;
    yt(ij)=Tat(i,j);
  end
  end 
%
% Transpose and count
  yt=yt';
  ncall=ncall+1;