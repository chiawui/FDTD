clear

%***********************************************************************
%     Fundamental constants
%**********************************************************************
c0=3e8;
u0=4*pi*1.0e-7;
epsz=8.85419e-12;

%***********************************************************************
%     Grid Parameters
%***********************************************************************

dt=dx/(2*c0); %time steps

width=0.03;  %in r direction
height=0.06; %in z direction

ie=(width/dr);
je=(height/dr);

ib=ie+1; 
jb=je+1; 

er=zeros(ie,jb);           %fields in main grid  
ez=zeros(ib,je); 
Hp=zeros(ie,je);

%Grid in radial direction
r=zeros(ie);
for i=1:ie
  r(i)= i*dr;
end

%permitivity domain
gar=ones(ie,je);gbr=zeros(ie,je);
gaz=ones(ie,je);gbz=zeros(ie,je);
dpr=zeros(ie,je);dpz=zeros(ie,je);
ir=zeros(ie,je);iz=zeros(ie,je);

%***********************************************************************
%     Source
%***********************************************************************

is=1;js=21;
t0=30.0;spread=10.0;%Gaussian pulse parameter
freq=2.45e9;
nsteps=2000;%number of time steps
nmax=2000;

%***********************************************************************
%     monopole dimension in m(radius)
%     permitivity teflon=2.05
%     RG402/u % a=0.000456m;0.456mm % b=0.00149;1.49mm
%     RG405/u % a=0.000255;% b=0.000838;
%***********************************************************************

inner_d=0.0005;a=inner_d/dr;
outer_d=0.0015;b=outer_d/dr;
height=0.015;h=height/dr;
cable_length=0.015;l=cable_length/dr;

%*********************************************************************** 
%     Material parameters 
%*********************************************************************** 
 
media=3; 
 
eps=[1.0 2.1 43]; 
sig=[0.0 0.0 1.69]; 
mur=[1.0 1.0 1.0]; 
sim=[0.0 0.0 0.0]; 

%*********************************************************************** 
%     Updating coefficients 
%*********************************************************************** 
 
for i=1:media 
  ca(i)=1/(eps(i)+(sig(i)*dt/epsz));
  cb(i)=sig(i)*dt/epsz;
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

gar(a+1:b,1:js-1)=ca(1);
gbr(a+1:b,1:js-1)=cb(1);
%gaz(a+1:b,1:js-1)=ca(1);
%gbz(a+1:b+1,js:l+h)=cb(1);

%    Set teflon material

gar(a+1:b,js:js+l+h+1)=ca(2);
gbr(a+1:b,js:js+l+h+1)=cb(2);
gaz(a+1:b+1,js:js+l+h)=ca(2);
gbz(a+1:b+1,js:js+l+h)=cb(2);

%    Set permitivity on tissue

%caer(ic:ie,jc+l+1:je)=ca(3)
%caer(ic:ie,jc+l+1:je)=ca(3)


%***********************************************************************
% Set PEC boundary
%***********************************************************************

%set PEC Boundary Condition
gaz(1:a+1,1:js+h+l)=0;
gaz(a:ie,1:js+l)=0;
gar(b+1:ie,1:js+l+1)=0;
gar(a,1:js+h+l+1)=0;
