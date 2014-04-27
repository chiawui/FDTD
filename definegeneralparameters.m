
function definegeneralparameters
%This function is a dialogue which defines the general simulation
%parameters
global x_dimension y_dimension cell_size ...
  bg_eps bg_sigma bg_mu bg_rho...
  pmlwidth usergeneralparameters...
  scalefactor

scalefactor=1e-3;%unit in mm

prompt={'Smallest element size','\epsilon - Background',...
  '\sigma - Background','\mu - Background','\rho - Background [kg/m3]'...
  'Size x-Dimension [mm]','Size y-Dimension [mm]',...
  'Number of Perfectly Matched Layers'};

name='Simulation Parameters';
numlines=1;
defaultanswer={'5e-4','1','1.69','1','1079','30','50','8'};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
options.fonsize=20;
answer=inputdlg(prompt,name,numlines,defaultanswer,options);

if isempty(answer)
    return
end

cell_size=str2num(answer{1});
bg_eps=str2num(answer{2});
bg_sigma=str2num(answer{3});
bg_mu=str2num(answer{4});
bg_rho=str2num(answer{5});

x_dimension=str2num(answer{6})*scalefactor;
y_dimension=str2num(answer{7})*scalefactor;

pmlwidth=str2num(answer{8});

usergeneralparameters=answer;