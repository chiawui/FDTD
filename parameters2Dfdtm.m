%Fundamental constants
c0=3e8;
u0=4*pi*1.0e-7;
epsz=8.85419e-12;
er_ptfe =2.1;
sigma=0;

%Grid parameters
%fdtd grid
ie=60;je=140;

dr=0.0005;     %cell size, pg8 in D.Sullivan suggest 10 point per wavelength
dz=0.0005;
dt=dr/(2*c0); %time steps

ch_r=dt/(u0*dr);ch_z=dt/(u0*dz);
cer_r=dt/(epsz*dr);cer_z=dt/(epsz*dz);

%Source 
t0=30.0;spread=10.0;%Gaussian pulse parameter
ic=8;jc=15;%point of source
nsteps=2000;%number of time steps

%Field arrays
ez=zeros(ie,je);er=zeros(ie,je);Hp=zeros(ie,je);

%Grid in radial direction
r=zeros(1, ie);
for i=ic:ie
  r(i)= abs(i-ic)*dr;
end

pml2dparameters;

%monopole dimension in m(radius)
%permitivity teflon=2.05
%RG402/u % a=0.000456m;0.456mm % b=0.00149;1.49mm
%RG405/u % a=0.000255;% b=0.000838;
inner_d=0.0005;a=inner_d/dr;
outer_d=0.0015;b=outer_d/dr;
height=0.015;h=height/dr;

%permitivity domain 
ga=ones(ie,je);gb=zeros(ie,je);
dpr=zeros(ie,je);dpz=zeros(ie,je);
ir=zeros(ie,je);iz=zeros(ie,je);

%Set PEC boundary
er_bc=ones(ie,je);ez_bc=ones(ie,je);
pec_r_min=ic+b+1; pec_r_max=ic+1;
pec_z_min=1; pec_z_max=41;

for i=1:ie
  for j=pec_z_min:pec_z_max
    if(i>pec_r_min || i<pec_r_max)
      er_bc(i,j)= 0;
      ez_bc(i,j)= 0;
    else
      er_bc(i,j)=1;
      ez_bc(i,j)=0; %set to TEM mode inside coaxial line
      ga(i,j)=1/(er_ptfe+(sigma*dt/epsz));
      gb(i,j)=sigma*dt/epsz;
    end
  end
end

%set pec on antenna
for i=ic:ic+1
  for j=1:pec_z_max+h
    er_bc(i,j)=0;
    ez_bc(i,j)=0;
    ga(i,j)=1.0;
    gb(i,j)=0;
  end
end

% set symetrical plane
% for i=1:ic-2
%   for j=1:je
%     er_bc(i,j)=1;
%     %ez_bc(i,j)=0;
%   end
% end

%er_flipped=zeros(ic,je);
%Incident buffer
% er_inc=zeros(1,je);
% Hp_inc=zeros(1,je);
% er_inc_low_m1=0;
% er_inc_low_m2=0;

%fourier transform parameter
nfreq=1;
freq=zeros(1,nfreq);
freq(1)=2.45e9;
real_pt=zeros( ie, je);
imag_pt=zeros( ie, je);
real_in=0;
imag_in=0;
amp_in=0;
amp_const=1/(2*log(b/a)*dr);
er_2e2u=zeros(1,2);

amp=zeros(ie,je);
er_test=zeros(1, nsteps);
for n=1:nfreq
  arg(n)=2*pi*freq(n)*dt;
end

%bioheat grid
global nx ny
nx = ie-npml-ic+1;
ny = je-npml-jc+1;
% Initial condition (bioheat)
u0=ones(nx,ny);
