function [ SAR ] = calc_SAR
%calc_SAR short for calculate SAR distribution contributed by Electric
%field

global inner_eps bg_eps bg_sigma bg_mu bg_rho


result=load('result.mat','Enorm');
Enorm=result.Enorm(1:length(x), pmlwidth+1:length(y)+pmlwidth);
SAR=sigma*Enorm^2/rho

end

