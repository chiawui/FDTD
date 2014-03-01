
function definegeneralparameters
%This function is a dialogue which defines the general simulation
%parameters
global height coax_length inner_d outer_d teflon_p dx userantennaparams y

prompt={'antenna height [mm]','coaxial length - l[mm]','inner diameter - a[mm]','outer diameter - b[mm]', 'teflon permitivity'};

name='Antenna Parameters';
numlines=1;
defaultanswer={'15','15','0.5','1.5','2.1'};
if ~isempty(userantennaparams)
  defaultanswer = userantennaparams;
end
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
options.fonsize=20;
answer=inputdlg(prompt,name,numlines,defaultanswer,options);
if isempty(answer)
    return
end

height=round(str2num(answer{1})/dx);
coax_length=round(str2num(answer{2})/dx);
inner_d=round(str2num(answer{3})/dx);
outer_d=round(str2num(answer{4})/dx);
teflon_p=str2num(answer{5});

if((height+coax_length)>length(y))
  errordlg('height and coaxial cable length exceed the grid');
  return;
elseif(inner_d>=outer_d)
  errordlg('inner diameter is equal or larger than outer diameter. Adjust the num of grid');
  return
end

userantennaparams = answer;