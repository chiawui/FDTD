function Startsimulation(type)%1=time domain, 2=freq domain, 3=calc impedance
is_time_domain=true;
is_calc_impedance=false;
switch type
  case 1
    is_time_domain=true;
    is_calc_impedance=false;
  case 2
    is_time_domain=false;
    is_calc_impedance=false;
  case 3
    is_calc_impedance=true;
    is_time_domain=false;
end

global dt nsteps forcestopflag x_dimension y_dimension cell_size t0

if(is_calc_impedance)
answer={'3','5e8,5e9,20','2.5017e-11','1','4000'};
prompt={'Source Type - Sinusoidal source is unavailable / 2 for Gaussian Source / 3 Differentiated Gaussian',...
    'frequency range - min,max,n frequencies','characteristic time for Gaussian Pulse',...
    'Voltage','maximum number of time steps'};
elseif(~is_time_domain)
answer={'3','915e6','2.5017e-11','1','4000'};
prompt={'Source Type - Sinusoidal source is unavailable / 2 for Gaussian Source / 3 Differentiated Gaussian',...
    'frequency','characteristic time for Gaussian Pulse',...
    'Voltage','maximum number of time steps'};
else
%time domain show visualization  
answer={'1','2.45e9','2.5017e-11','1','1000','1'};
prompt={'Source Type - 1 for Sinusoidal source / 2 for Gaussian Source / 3 Differentiated Gaussian',...
    'frequency','characteristic time for Gaussian Pulse',...
    'Voltage','maximum number of time steps','Er=1 Ez=2 Hp=3'};
end

name='Source';
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

characteristic_time=str2num(answer{3});
voltage=str2num(answer{4});
nsteps=str2num(answer{5});%number of time steps

vis_field='1';
if(is_calc_impedance)
  values=str2num(answer{2});
  freq=linspace(values(1),values(2),values(3));
elseif(~is_time_domain)
  freq=str2num(answer{2});
else
  freq=str2num(answer{2});
  vis_field=answer{6};
end
switch answer{1}
    case '1'%Sine wave
        omega=2*pi*dt*freq;
        source=@(t) voltage*sin(omega*t);   
    case '2'%Gaussian pulse
        spread=characteristic_time/dt;
        t0=spread*3;
        source=@(t) voltage*exp(-0.5*(((t-t0)/spread)^2.0));
     case '3'%Diff Gaussian Pulse
        spread=characteristic_time/dt;
        t0=spread*3;
        source=@(n) voltage*((n-t0)/spread)*exp(0.5-0.5*(((n-t0)/spread)^2.0));%diff gaussian
end


%% ui code
if(is_time_domain)
  scrsz = get(0,'ScreenSize');
  figure('outerposition',[1 40 scrsz(3) scrsz(4)-40],'color',[1 1 1]);
  forcestopflag=0;
  uicontrol('Position',[400 20 100 40],'String','Finish',...
      'Callback',@forcestop);

else %show progress bar only
  h_waitbar = waitbar(0,'Please wait...');%,'CreateCancelBtn','forcestop');
end

%calculate fdtd 
fdtd(source, freq, is_time_domain, vis_field, is_calc_impedance);   

%% visualise the result
if(~is_time_domain)
  close(h_waitbar);
  scrsz = get(0,'ScreenSize');
  %figure('outerposition',[1 40 scrsz(3) scrsz(4)-40],'color',[1 1 1]);
  %plotmesh(res);
  if(is_calc_impedance)
    %result=load('result.mat','Z');
    %plot(freq, real(result.Z),'-b', freq, imag(result.Z),'-g');
    update_mesh('Z');
  else
    update_mesh('E_norm');
    
  end
  %calc_impedance(real_in, imag_in, real_refl, imag_refl, freq);
end

end %end function loop

function forcestop(hObj,event)
global forcestopflag
forcestopflag=1;
end