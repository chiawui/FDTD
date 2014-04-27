function fdtd(source, freq, is_time_domain, vis_field, is_calc_impedance)

global scrsz dt nsteps inner_d outer_d height coax_length ...
  forcestopflag cell_size pmlwidth t0
forcestopflag=0;%reset flag
%% Generate mesh
[x,y,gar,gbr,gaz,gbz]=generate_mesh();

ie=length(x)+pmlwidth;
je=length(y)+2*pmlwidth;

ib=ie+1; 
jb=je+1;
dx=cell_size;

is=inner_d;
js=pmlwidth+1;

%% pml parameters

npml=pmlwidth;
ihx=zeros(ie,je);ihy=zeros(ie,je);
gi2 = ones(1,ie);
gi3 = ones(1,ie);
fi1 = zeros(1,ie);
fi2 = ones(1,ie);
fi3 = ones(1,ie);

gj2 = ones(1,je);
gj3 = ones(1,je);
fj1 = zeros(1,je);
fj2 = ones(1,je);
fj3 = ones(1,je);

%Calculate PML
for i = 1:npml+1
    xnum = npml - (i-1);
    xd = npml;
    xxn = xnum/xd;
    xn = 0.33*(xxn^3);
    %gi2(i) = 1.0/(1.0+xn);
    gi2(ie-i+1) = 1.0/(1.0+xn);
    %gi3(i) = (1.0 - xn)/(1.0+xn);
    gi3(ie-i+1) = (1.0 - xn)/(1.0+xn);
    
    xxn = (xnum - 0.5)/xd;
    xb = 0.25*(xxn^3);
    %fi1(i) = xn;
    fi1(ie-i) = xn;
    %fi2(i) = 1.0/(1.0+xn);
    fi2(ie-i) = 1.0/(1.0+xn);
    %fi3(i) = (1.0-xn)/(1.0 + xn);
    fi3(ie-i) = (1.0-xn)/(1.0+xn);
end
for j = 1:npml+1
    xnum = npml - (j-1);
    xd = npml;
    xxn = xnum/xd;
    xn = 0.33*(xxn^3);
    gj2(j) = 1.0/(1.0+xn);
    gj2(je-j+1) = 1.0/(1.0+xn);
    gj3(j) = (1.0 - xn)/(1.0+xn);
    gj3(je-j+1) = (1.0 - xn)/(1.0+xn);
    
    xxn = (xnum - 0.5)/xd;
    xb = 0.25*(xxn^3);
    fj1(j) = xn;
    fj1(je-j) = xn;
    fj2(j) = 1.0/(1.0+xn);
    fj2(je-j) = 1.0/(1.0+xn);
    fj3(j) = (1.0-xn)/(1.0 + xn);
    fj3(je-j) = (1.0-xn)/(1.0+xn);
end

%% fdtd arrays initialization

er=zeros(ie,jb);           %fields in main grid  
ez=zeros(ib,je); 
Hp=zeros(ie,je);

dpr=zeros(ie,je);dpz=zeros(ie,je);
ir=zeros(ie,je);iz=zeros(ie,je);

%Grid in radial direction
r=zeros(ie);
for i=1:ie
  r(i)= i*dx;
end

max_amp=0;%maximum amplitude value 

if(~is_time_domain)
  if(is_calc_impedance)
    %fourier transform results for multiple freqs, use to calc impedance
    num_freq=length(freq);
    arg=2*pi*freq*dt;
    real_in=zeros(1,num_freq);imag_in=zeros(1,num_freq);
    real_refl=zeros(1,num_freq);imag_refl=zeros(1,num_freq);
  else
    %fourier transform results for single freq
    arg=2*pi*freq*dt;
    real_in=0;imag_in=0;
    real_pt_r=ones(ie,jb);imag_pt_r=ones(ie,jb);
    real_pt_z=ones(ib,je);imag_pt_z=ones(ib,je);
  end
end

%% fdtd loop

for n=1:nsteps
  if forcestopflag==1
    break;
  end
%Calculate Hp field
  for i=1:ie
    for j=1:je
      curl_e=(er(i,j+1)-er(i,j)+ez(i,j)-ez(i+1,j));
      Hp(i,j)=gi3(i)*gj3(j)*Hp(i,j)- gi2(i)*gj2(j)*0.5*(curl_e);
    end
  end
  
%Source
pulse=source(n);

for i=inner_d:outer_d
  excitation=pulse/(log(outer_d/inner_d)*(i*dx+dx/2));
  dpr(is+i,js)=dpr(is+i,js)+excitation;
end

%Calculate Er field
  for i=1:ie
    for j=2:je
      curl_h=(Hp(i,j)-Hp(i,j-1));
      ihx(i,j)=ihx(i,j)+fi1(i)*curl_h;
      dpr(i,j)=fj3(j-1)*dpr(i,j)-fj2(j-1)*0.5*(curl_h+ihx(i,j));
      er(i,j)=gar(i,j)*(dpr(i,j)-ir(i,j));
      ir(i,j)=ir(i,j)+gbr(i,j)*er(i,j);
    end
  end 
  
  %Fourier transform
  v_er=sum(er(inner_d+1:outer_d,js));
  if(v_er>max_amp)
    max_amp=v_er;
  end

%Calculate Ez field
  for i=2:ie
    r_i_pre = (r(i)-(dx/2))/r(i);
    r_i_next = (r(i)+(dx/2))/r(i);
    for j=1:je
      curl_h=(r_i_next*Hp(i,j))-(r_i_pre*Hp(i-1,j));
      ihy(i,j)=ihy(i,j)+fj1(j)*curl_h;
      dpz(i,j)=fi3(i)*dpz(i,j)+fi2(i)*(0.5)*(curl_h+ihy(i,j));
      ez(i,j)=gaz(i,j)*(dpz(i,j)-iz(i,j));
      iz(i,j)=iz(i,j)+gbz(i,j)*ez(i,j);          
    end
  end
  
  ez(1,js+height+coax_length:je)=ez(1,js+height+coax_length:je)+...
            2.*gaz(1,js+height+coax_length:je).*(Hp(1,js+height+coax_length:je));
  %iz(1,js+height+coax_length:je)=iz(1,js+height+coax_length:je)+gbz(i,j)*ez(1,js+height+coax_length:je);
  
  if(~is_time_domain)
    if(is_calc_impedance)
      %Calculate reflection coeffecient for multiple freq
      if(n<2*t0)%temp hard code
      real_in=real_in+cos(arg*n)*sum(er(inner_d+1:outer_d,js+1));
      imag_in=imag_in+sin(arg*n)*sum(er(inner_d+1:outer_d,js+1));
      else
      real_refl=real_refl+cos(arg*n)*sum(er(inner_d+1:outer_d,js+1));
      imag_refl=imag_refl+sin(arg*n)*sum(er(inner_d+1:outer_d,js+1));
      end
    else
      %Calc Fourier Transform of incident field
      real_in=real_in+cos(arg*n)*sum(er(inner_d+1:outer_d,js));
      imag_in=imag_in+sin(arg*n)*sum(er(inner_d+1:outer_d,js));
      %Calculate Fourier Transform of Er
      real_pt_r=real_pt_r+cos(arg*n)*er;
      imag_pt_r=imag_pt_r+sin(arg*n)*er;
      
      %Calculate Fourier Transform of Ez
      real_pt_z=real_pt_z+cos(arg*n)*ez;
      imag_pt_z=imag_pt_z+sin(arg*n)*ez;
    end
  end
  
  if(is_time_domain)
    %plot simulation
    switch vis_field
      case '1'
        plotmesh(er(1:length(x), pmlwidth+1:length(y)+pmlwidth));
      case '2'
        plotmesh(ez(1:length(x), pmlwidth+1:length(y)+pmlwidth));
      case '3'
        plotmesh(Hp(1:length(x), pmlwidth+1:length(y)+pmlwidth));
    end
    timestep=n*dt;
    title(['Er in the XZ plane at time step = ',num2str(timestep)]);
    xlabel('z axis');
    ylabel('r axis');
    pause(0.0001);
  else
    %update waitbar
    max_value=max(abs(max(er(inner_d+1,:))), abs(min(er(inner_d+1,:))));
    waitbar(6 / max_value);
    if(max_value<6 && n>2*t0)
      if(is_calc_impedance)
        [Z, eta]=calc_impedance(real_in, imag_in, real_refl, imag_refl, freq);
        save('result.mat', 'Z','eta','freq','-append');
      else
        [Enorm,Er,Ez]=calc_fouriertransform(max_amp, real_in, imag_in, real_pt_r, imag_pt_r,...
          real_pt_z, imag_pt_z);
        save('result.mat', 'Enorm','Er','Ez','-append');
      end
      break;
    end
  end%end show visualization loop
  
end%end fdtd loop

end%end function loop
