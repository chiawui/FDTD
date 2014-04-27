function [Enorm, Er, Ez]=calc_fouriertransform(max_amp, real_in, imag_in, real_pt_r,...
  imag_pt_r,real_pt_z, imag_pt_z)

%Calculate fourier amplitude
amp_in=sqrt(real_in^2+imag_in^2);
Er=max_amp/amp_in*sqrt(real_pt_r.^2+imag_pt_r.^2);
Ez=max_amp/amp_in*sqrt(real_pt_z.^2+imag_pt_z.^2);
Enorm=sqrt(Er(:,2:end).^2+Ez(2:end,:).^2);

end