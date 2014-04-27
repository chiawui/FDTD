
function [x,y,gar,gbr,gaz,gbz,gcsar]=generate_mesh()
  global bg_eps bg_sigma bg_mu bg_rho scalefactor...
    height_dimension coax_length_dimension inner_d_dimension outer_d_dimension...
    c0 epsilon0 dt...
    x_dimension y_dimension cell_size pmlwidth...
    height coax_length inner_d outer_d coax_eps coax_rho
  
  [x,y]=discretize_grid(x_dimension, y_dimension, cell_size);
  dx=cell_size;
  
  %Grid parameters
  dt=dx/(2*c0); %time steps

  ie=length(x)+pmlwidth;
  je=length(y)+2*pmlwidth;

  ib=ie+1; 
  jb=je+1; 

  %permitivity domain
  gar=ones(ie,je);gbr=zeros(ie,je);
  gaz=ones(ie,je);gbz=zeros(ie,je);
  gcsar=zeros(ie,je);
  
%***********************************************************************
%    Antenna dimension
%***********************************************************************
  height=round(height_dimension*scalefactor/cell_size);
  coax_length=round(coax_length_dimension*scalefactor/cell_size);
  inner_d=round(inner_d_dimension*scalefactor/cell_size);
  outer_d=round(outer_d_dimension*scalefactor/cell_size);

%***********************************************************************
%    Source
%***********************************************************************

  is=1;js=pmlwidth+1;

%*********************************************************************** 
%     Material parameters 
%*********************************************************************** 
 
media=3; 
 
eps=[1.0 coax_eps bg_eps]; 
sig=[0.0 0.0 bg_sigma]; 
mur=[1.0 1.0 bg_mu]; 
sim=[0.0 0.0 0.0]; 
rho=[1.0 coax_rho bg_rho];

%*********************************************************************** 
%     Updating coefficients 
%*********************************************************************** 
 
for i=1:media 
  ca(i)=1/(eps(i)+(sig(i)*dt/epsilon0));
  cb(i)=sig(i)*dt/epsilon0;
  csar(i)=sig(i)/rho(i);
end 
 
%*********************************************************************** 
%     Geometry specification (main grid) 
%*********************************************************************** 
 
%     Initialize entire main grid to background material(biological tissue)
 
gar(1:ie,1:jb)=ca(3);      
gbr(1:ie,1:jb)=cb(3);      
gaz(1:ie,1:jb)=ca(3);      
gbz(1:ie,1:jb)=cb(3);      
gcsar(1:ie,1:jb)=csar(3);

%   Set teflon material for PML at coaxial line feeding point interface 
%   to correctly absorb reflected wave
gar(inner_d+1:outer_d,1:js-1)=ca(2);
gbr(inner_d+1:outer_d,1:js-1)=cb(2);

%    Set teflon material inside coaxial line

gar(inner_d+1:outer_d,js:js+coax_length+height+1)=ca(2);
gbr(inner_d+1:outer_d,js:js+coax_length+height+1)=cb(2);
gaz(inner_d+1:outer_d+1,js:js+coax_length+height)=ca(2);
gbz(inner_d+1:outer_d+1,js:js+coax_length+height)=cb(2);
gcsar(inner_d+1:outer_d,js:js+coax_length+height+1)=csar(2);

%***********************************************************************
% Set PEC boundary
%***********************************************************************

%set PEC Boundary Condition
gaz(1:inner_d+1,1:js+height+coax_length)=0;
gaz(inner_d:ie,1:js+coax_length)=0;
gar(outer_d+1:ie,1:js+coax_length+1)=0;
gar(1:inner_d,1:js+height+coax_length+1)=0;
%capacitive loaded segment
% gar(1:outer_d, js+coax_length+height+2)=0;
% gaz(1:outer_d, js+coax_length+height+3)=0;
% gar(outer_d+1, js+coax_length+height-1:js+coax_length+height+2)=0;
% gaz(outer_d+2, js+coax_length+height-1:js+coax_length+height+3)=0;
end