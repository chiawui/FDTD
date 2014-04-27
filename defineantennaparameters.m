
function defineantennaparameters
%This function is a dialogue which defines the general simulation
%parameters
global height_dimension coax_length_dimension inner_d_dimension outer_d_dimension...
  height coax_length inner_d outer_d coax_eps coax_rho...
  cell_size scalefactor userantennaparams

prompt={'antenna height [mm]','coaxial length - l[mm]',...
  'inner diameter - a[mm]','outer diameter - b[mm]',...
  'dielectric permitivity', 'dielectric density - \rho [kg/m3]'};

name='Antenna Parameters';
numlines=1;
defaultanswer={'15','15','0.5','1.5','2.06', '2200'};
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

height_dimension=str2num(answer{1});
coax_length_dimension=str2num(answer{2});
inner_d_dimension=str2num(answer{3});
outer_d_dimension=str2num(answer{4});
% 
% height=round(height_dimension*scalefactor/cell_size);
% coax_length=round(coax_length_dimension*scalefactor/cell_size);
% inner_d=round(inner_d_dimension*scalefactor/cell_size);
% outer_d=round(outer_d_dimension*scalefactor/cell_size);
coax_eps=str2num(answer{5});
coax_rho=str2num(answer{6});

% if((height+coax_length)>length(y))
%   errordlg('height and coaxial cable length exceed the grid');
%   return;
% else
if(inner_d>=outer_d)
  errordlg('inner diameter is equal or larger than outer diameter. Adjust the num of grid');
  return
end
%plotmesh;
userantennaparams = answer;