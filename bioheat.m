function  T=bioheat( tissue_prop, blood_prop )
% bioheat short for bioheat will solve the Pennes' bioheat
% equation using SAR distribution as heat source to predict temperatur
% distribution

global nr nz coax_length pmlwidth...
  k Cp rho tf...
  Tb rhob Cb wb...
  SAR ncall 

k=tissue_prop.k;
Cp=tissue_prop.Cp;
rho=tissue_prop.rho;
tf=tissue_prop.tf;
Tb=blood_prop.Tb;
rhob=blood_prop.rhob;
Cb=blood_prop.Cb;
wb=blood_prop.wb;

[x,y,gar,gbr,gaz,gbz,gcsar]=generate_mesh(); 

  result=load('result.mat','Enorm');
  SAR=gcsar(1:length(x), pmlwidth+coax_length+1:length(y)+pmlwidth).*(result.Enorm(1:length(x), pmlwidth+coax_length+1:length(y)+pmlwidth).^2.0);

% Independent variable for ODE integration
  %tf=80.0;
  nout=10;
  tout=linspace(0.0,tf,nout)'; 
  ncall=0;
  
  nr=length(x);
  nz=length(y)-coax_length;
% Initial condition
  Ta=(310.85)*ones(nr, nz);
  
  for i=1:nr
    for j=1:nz
      Ta(i,j)=310.85;
      y0((i-1)*nz+j)=Ta(i,j);
    end
  end
  
  % ODE integration 
  reltol=1.0e-08; abstol=1.0e-08;
  options=odeset('RelTol',reltol,'AbsTol',abstol);%,'Stats','on');
  mf=1;
  if(mf==1)[t,y]=ode45(@pde_bioheat,tout,y0,options);end 
  
  %   1D to 2D matrices
  for it=1:nout
    for i=1:nr
      for j=1:nz  
        Ta(it,i,j)=y(it,(i-1)*nz+j);
      end
    end
  end
  %T=squeeze(Ta(nout, :,:));
  T=zeros(nr,nz);
  for i=1:nr
    for j=1:nz  
      T(i,j)=Ta(nout,i,j);
    end
  end

end

