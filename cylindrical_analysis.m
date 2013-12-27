%debug
delta_step=1;
nprev=1;

%Initialization
parameters2Dfdtm
%parameters2Dtm

for n=1:nsteps
  fdfd_2dtm   %calculate fdtd 
  %fdtd_2dtm
  %plot fdtd result
  figure(1);

  %imagesc(er(ic+1:ie,:));shading interp;
  %contour(amp);
  %e=er+ez;
  
 surf(er(ic+1:ie,:));
  %surf(er);
  
  %surf(amp(ic+1:ie,:));
  
  %plot(er_inc);
  %axis([0 45 0 45 -0.02 0.02]);
  timestep=n*dt;
  title(['Er in the XZ plane at time step = ',num2str(timestep)]);
  xlabel('z axis');
  ylabel('r axis');
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
  if isequal((n-nprev),delta_step)
    nprev=n;
    res = input('');
    if isempty(res)
      delta_step=1;
    else
      delta_step=res;
    end
  end
  
  %cross_section = er(:,jc-15+n);
  pause(0.001);
end  %end of all loops

