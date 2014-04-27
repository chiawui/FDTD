%Calculate impedance
function [Z, eta]=calc_impedance(real_in, imag_in, real_refl, imag_refl, freqs)

global mu0 epsilon0 outer_d inner_d c0 coax_length_dimension coax_eps scalefactor;

num_freq=length(freqs);

V_in=(real_in-imag_in*1i);
V_refl=(real_refl-imag_refl*1i);
eta=(V_refl)./(V_in);

Z_ci=sqrt(mu0/(epsilon0*coax_eps))*log(outer_d/inner_d)/(2*pi);

Z=zeros(1,num_freq);
Z_obs=zeros(1,num_freq);
for i=1:num_freq
  Z_obs(i)=Z_ci.*((1+eta(i))/(1-eta(i)));
  omega=2*pi*freqs(i);
  ki=(omega/c0)*sqrt(coax_eps);
  cable_length=-coax_length_dimension*scalefactor;
  Z(i)=Z_ci.*(Z_obs(i)+Z_ci.*tan(ki.*cable_length)*1i)/(Z_ci+Z_obs(i).*tan(ki.*cable_length)*1i);
end
%figure(1);
% Z_comsol_real = importdata('Z_comsol_real.mat');
% Z_comsol_imag = importdata('Z_comsol_imag.mat');
%plot(freqs, real(Z),'-b', freqs, imag(Z),'-g');
% ,....
%   Z_comsol_real(:,1), Z_comsol_real(:,2), '.b',Z_comsol_imag(:,1), Z_comsol_imag(:,2), '.g');

%xlabel('frequency,f');
%ylabel('Z,ohm');