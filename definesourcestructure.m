function [source,freq,show_vis,vis_field]=definesourcestructure(is_calc_impedance)
%This function is a dialogue and structure definition which defines a
%source structure within the GUI (the function is called by
%clicking - 'New Source Structure') 
global dt nsteps


if(is_calc_impedance)
answer={'3','1e9,5e9,20','0','1','4000'};
prompt={'Source Type - 1 for Sinusoidal source / 2 for Gaussian Source / 3 Differentiated Gaussian',...
    'frequency range - min,max,n frequencies',...
    'show visualization- show=1,show=0','Er=1 Ez=2 Hp=3','maximum number of time steps'};
else
answer={'1','2.45e9','1','1','1000'};
prompt={'Source Type - 1 for Sinusoidal source / 2 for Gaussian Source / 3 Differentiated Gaussian',...
    'frequency',...
    'show visualization- 1 for show/0 no show ','Er=1 Ez=2 Hp=3','maximum number of time steps'};

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

show_vis=str2num(answer{3});
vis_field=answer{4};
nsteps=str2num(answer{5});%number of time steps

if(is_calc_impedance)
  values=str2num(answer{2});
  freq=linspace(values(1),values(2),values(3));
else
  freq=str2num(answer{2});
end
switch answer{1}
    case '1'
        omega=2*pi*dt*freq;
        source=@(t) sin(omega*t);   
    case '2'
      if(size(freq)==1)
        spread=1/(2*pi*freq);        
      else
        spread=1/(2*pi*freq(1));        
      end
        t0=spread*3;
        source=@(t) exp(-0.5*(((t-t0)/spread)^2.0));
     case '3'
      if(size(freq)==1)
        spread=1/(2*pi*freq);        
      else
        %spread=1/(2*pi*freq(1));        
        spread=40;
      end
        t0=spread*3;
        source=@(n) ((n-t0)/spread)*exp(0.5-0.5*(((n-t0)/spread)^2.0));%diff gaussian
end

