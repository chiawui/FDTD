%debug
delta_step=1;
nprev=1;

%Initialization
parameters2DTE
pml2dparameters
%parameters2Dtm

for n=1:100
  fdtd_2dTESullivan   %calculate fdtd 
  %fdtd_2dtm
  %plot fdtd result
  %figure(1);

  %imagesc(er(ic+1:ie,:));shading interp;
  %contour(amp);
  %e=er+ez;
  
 %surf(sqrt(er(ic+1:ie,:).^2+ez(ic+1:ie,:).^2));
  surf(er(:,js:je));
  view(-90,90);
  %surf(amp(ic+1:ie,:));
  
  %plot(er_inc);
  %axis([0 45 0 45 -0.02 0.02]);
  timestep=n*dt;
%   title(['Er in the XZ plane at time step = ',num2str(timestep)]);
%   xlabel('z axis');
%   ylabel('r axis');
  %view(145,45);
  
  %plot_comparison_graph;
  
%   SAR = er(ic:ie-npml,jc:je-npml);
%   bioheat_pde
%   
%   plot temp distribution
%   figure(2);
%   surf(u);
%   xlabel('y grid number');
%   ylabel('x grid number');
%   view(0, 90);
  
  % time steps control

  
%   if(n==nmax-10)
%     er_2e2u=er;
%     ez_2e2u=ez;
%   elseif(n==nmax)
%     linearequation
%   end
  
  %cross_section = er(:,jc-15+n);
  pause(0.001);
end  %end of all loops

