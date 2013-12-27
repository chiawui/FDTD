
%Calculate Hp field
  for i=ic:ie
    for j=2:je
      if i>ic
        Hp(i,j)=gi3(i-1)*gj3(j-1)*Hp(i,j)+ gi2(i-1)*gj2(j-1)*(ch_r*(ez(i,j)-ez(i-1,j))-ch_z*(er(i,j)-er(i,j-1)));
      else
        Hp(i,j)=gi3(i-1)*gj3(j-1)*Hp(i,j)-gi2(i-1)*gj2(j-1)*ch_z*(er(i,j)-er(i,j-1));
      end  
    end
  end
  
%Calculate Er field
  for i=ic:ie
    for j=2:je
      %if (j>npml || j<(je-npml))
        curl_h=(Hp(i,j)-Hp(i,j-1));
        %dpr(i,j-1)=dpr(i,j-1)-(cer_z*curl_h);
        ihx(i,j-1)=ihx(i,j-1)+curl_h;
        dpr(i,j-1)=fj3(j-1)*dpr(i,j-1)-(fj2(j-1)*cer_z*curl_h)+fi1(i-1)*ihx(i,j-1);
      %end
    end
  end 
  
%Source
%pulse = 1.55*exp(-0.5*(((n-t0)/spread)^2.0));
pulse = sin(2*pi*dt*2450*1e6*n);
%er(ic+2,jc)=pulse/(i*log(b/a)*dr);
for i=1:b
  excitation=pulse/(i*log(b/a)*dr);
  dpr(ic+1+i,jc)=dpr(ic+1+i,jc)+excitation;
end

if i<100
%real_in=real_in+cos(arg(1)*n)*dpr(ic+2,jc);
%imag_in=imag_in-sin(arg(1)*n)*dpr(ic+2,jc);
end

%Calculate Er field
  for i=ic:ie
    for j=2:je
      %if (j>npml && j<(je-npml))
        er(i,j-1)= ga(i,j)*(dpr(i,j-1)-ir(i,j));
        ir(i,j) = ir(i,j)+gb(i,j)*er(i,j-1);
%       elseif (j<=npml || j>=(je-npml))
%         curl_h=(Hp(i,j)-Hp(i,j-1));
%         ihx(i,j-1)=ihx(i,j-1)+curl_h;
%         er(i,j-1)=fj3(j-1)*er(i,j-1)-(fj2(j-1)*cer_z*curl_h)+fi1(i-1)*ihx(i,j-1);
      %end
    end
  end
  if(n==480)
  er_2e2u(1)=er(ic+2,pec_z_max);
  elseif(n==490)
  er_2e2u(2)=er(ic+2,pec_z_max);
  end
  
%Fourier transform of Er
% imag_pt=imag_pt-(sin(arg(1)*n).*er);
% real_pt=real_pt+(cos(arg(1)*n).*er);
imag_pt(ic+5:ie,pec_z_max)=0;
real_pt(ic+5:ie,pec_z_max)=0;
  for i=ic:ie
    for j=1:je
      %for m=1:nfreq
        real_pt(i,j)=real_pt(i,j)+(cos(arg(1)*n)*er(i,j));
        imag_pt(i,j)=imag_pt(i,j)-(sin(arg(1)*n)*er(i,j));
      %end
    end
  end
  

%Calculate Ez field
  for i=ic:ie-1
    r_i_half = r(i)+(dr/2);
    r_i_next = r(i)+dr;
    for j=2:je-1
%       if (j>npml && j<(je-npml))
%         curl_h=(r_i_next*Hp(i+1,j)/r_i_half)-(r(i)*Hp(i,j)/r_i_half);
%         dpz(i,j)=(cer_r)*(curl_h);
%         ez(i,j)=ga(i,j)*(dpz(i,j)-iz(i,j));
%         iz(i,j)=iz(i,j)+gb(i,j)*ez(i,j);
%       elseif (j<=npml || j>=(je-npml))
        curl_h=(r_i_next*Hp(i+1,j)/r_i_half)-(r(i)*Hp(i,j)/r_i_half);
        ihy(i,j)=ihy(i,j)+curl_h;
        dpz(i,j)=fi3(i-1)*ez(i,j)+fi2(i-1)*(cer_r)*(curl_h)+fj1(j-1)*ihy(i,j);
        %ez(i,j)=fi3(i-1)*ez(i,j)+fi2(i-1)*(cer_r)*(curl_h)+fj1(j-1)*ihy(i,j);
        ez(i,j)=ga(i,j)*(dpz(i,j)-iz(i,j));
        iz(i,j)=iz(i,j)+gb(i,j)*ez(i,j);
      %end
    end
  end
 
ez=ez.*ez_bc;
er=er.*er_bc;
Hp= Hp.*er_bc;

amp_in=sqrt((real_in^2)+(imag_in^2));
% %Calculate the amplitude and phase of each frequency
  for i=ic:ie
    for j=1:je
      amp(i,j)=sqrt((real_pt(i,j)^2)+(imag_pt(i,j)^2));
      %amp(i,j)=real_pt(i,j);
    end
  end
  
