function simulate_bioheat
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

answer={'0.56', '3540', '36.7+274.15', '1057', '3639', '0.0036', '1060','80'};
prompt={'Thermal conductivity,k (W/m*K)', 'Heat Capacity,Cp (J/kg*K)',...
  'Body Core Temperature(K)', 'Blood density(kg/m3)', 'Blood specific heat(J/kg*k)',...
  'Blood perfusion rate (W/m3)', 'tissue \rho','duration,t(s)'};

name='Bioheat';
numlines=1;
defaultanswer=answer;
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
options.fonsize=20;
answer=inputdlg(prompt,name,numlines,defaultanswer,options);
if isempty(answer)
    return
end
k=str2num(answer{1});
Cp=str2num(answer{2});
Tb=str2num(answer{3});
rhob=str2num(answer{4});
Cb=str2num(answer{5});
wb=str2num(answer{6});

rho=str2num(answer{7});
tf=str2num(answer{8});

tissue_prop=struct('k',k, 'Cp', Cp, 'rho', rho, 'tf', tf);
blood_prop=struct('Tb', Tb, 'rhob', rhob, 'Cb', Cb, 'wb', wb);

T=bioheat(tissue_prop, blood_prop);
save('result.mat', 'T','-append');

update_mesh('SAR');
colorbar;
end

