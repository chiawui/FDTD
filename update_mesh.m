function update_mesh(type)
  global pmlwidth cell_size

  [x,y,gar,gbr,gaz,gbz,gcsar]=generate_mesh(); 
  
  switch type
    case 'material'
      plotmesh(gar(1:length(x), pmlwidth+1:length(y)+pmlwidth));
      title('epsilon');
    case 'E_norm'
      result=load('result.mat','Enorm');
      plotmesh(result.Enorm(1:length(x), pmlwidth+1:length(y)+pmlwidth));
      title('Enorm, V/m');
    case 'log10(E_norm)'
      result=load('result.mat','Enorm');
      plotmesh(log10(result.Enorm(1:length(x), pmlwidth+1:length(y)+pmlwidth)));
      title('log10(Enorm), V/m');
    case 'Er'
      result=load('result.mat','Er');
      plotmesh(result.Er(1:length(x), pmlwidth+1:length(y)+pmlwidth));
      title('Er, V/m');
    case 'Ez'
      result=load('result.mat','Ez');
      plotmesh(result.Ez(1:length(x), pmlwidth+1:length(y)+pmlwidth));
      title('Ez, V/m');
    case 'Z'
      result=load('result.mat','Z','eta','freq');
      plot(result.freq, real(result.Z),'-b', result.freq, imag(result.Z),'-g', result.freq, 20*log10(abs(result.eta)),'-r');
      title('Z-input impedance');
    case 'SAR'
      %result=load('result.mat','Enorm');
      %SAR=gcsar(1:length(x), pmlwidth+1:length(y)+pmlwidth).*(result.Enorm(1:length(x), pmlwidth+1:length(y)+pmlwidth).^2.0);
      %plotmesh(log10(SAR));
      result=load('result.mat','T');
      x=0.0:cell_size:0.03;
      y=0.0:cell_size:0.035;
      %surf(y,x,result.T);
      [C,h]=contourf(y,x,result.T-272.15,20);
      set(h,'ShowText','on','TextStep',get(h,'LevelStep')*2)
      view(-90,90);
      axis image;
      title('Temperature');
    end
  

  xlabel('mm');
  ylabel('mm');
end