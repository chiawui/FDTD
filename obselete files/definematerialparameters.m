function definematerialparameters

global backgroundeps backgroundsigma x y dx pmlwidth c epsilon0...
  height coax_length inner_d outer_d teflon_p gar gaz gbr gbz...
  dt is js ie je ib jb

%Grid parameters
dt=dx/(2*c); %time steps

ie=length(x)+pmlwidth;
je=length(y)+2*pmlwidth;

ib=ie+1; 
jb=je+1; 


%permitivity domain
gar=ones(ie,je);gbr=zeros(ie,je);
gaz=ones(ie,je);gbz=zeros(ie,je);

%***********************************************************************
%     Source
%***********************************************************************

is=1;js=pmlwidth+1;
t0=30.0;spread=10.0;%Gaussian pulse parameter
freq=2.45e9;

nmax=2000;

%*********************************************************************** 
%     Material parameters 
%*********************************************************************** 
 
media=3; 
 
eps=[1.0 teflon_p backgroundeps]; 
sig=[0.0 0.0 backgroundsigma]; 
mur=[1.0 1.0 1.0]; 
sim=[0.0 0.0 0.0]; 

%*********************************************************************** 
%     Updating coefficients 
%*********************************************************************** 
 
for i=1:media 
  ca(i)=1/(eps(i)+(sig(i)*dt/epsilon0));
  cb(i)=sig(i)*dt/epsilon0;
end 
 
%*********************************************************************** 
%     Geometry specification (main grid) 
%*********************************************************************** 
 
%     Initialize entire main grid to free space 
 
gar(1:ie,1:jb)=ca(3);      
gbr(1:ie,1:jb)=cb(3);      
gaz(1:ie,1:jb)=ca(3);      
gbz(1:ie,1:jb)=cb(3);      

%   Set PML material

gar(inner_d+1:outer_d,1:js-1)=ca(1);
gbr(inner_d+1:outer_d,1:js-1)=cb(1);
%gaz(inner_d+1:outer_d,1:js-1)=ca(1);
%gbz(inner_d+1:outer_d+1,js:coax_length+height)=cb(1);

%    Set teflon material

gar(inner_d+1:outer_d,js:js+coax_length+height+1)=ca(2);
gbr(inner_d+1:outer_d,js:js+coax_length+height+1)=cb(2);
gaz(inner_d+1:outer_d+1,js:js+coax_length+height)=ca(2);
gbz(inner_d+1:outer_d+1,js:js+coax_length+height)=cb(2);

%    Set permitivity on tissue

%caer(ic:ie,jc+coax_length+1:je)=ca(3)
%caer(ic:ie,jc+coax_length+1:je)=ca(3)


%***********************************************************************
% Set PEC boundary
%***********************************************************************

%set PEC Boundary Condition
gaz(1:inner_d+1,1:js+height+coax_length)=0;
gaz(inner_d:ie,1:js+coax_length)=0;
gar(outer_d+1:ie,1:js+coax_length+1)=0;
gar(inner_d,1:js+height+coax_length+1)=0;
