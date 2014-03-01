
function definegeneralparameters
%This function is a dialogue which defines the general simulation
%parameters
global x y dx max_grid_size backgroundeps backgroundmu epsilon mu ZS  epsilon0 mu0 alphadat pmlwidth usergeneralparameters...
  height coax_length

height = 3;
coax_length = 3;

prompt={'maximum number of Gridpoints in one Dimension','\epsilon - Background','\mu - Background','Size x-Dimension [mm]','Size y-Dimension [mm]','Number of timesteps','Number of Perfectly Matched Layers'};

name='Simulation Parameters';
numlines=1;
defaultanswer={'100','1','1','30','50','300000','10'};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
options.fonsize=20;
answer=inputdlg(prompt,name,numlines,defaultanswer,options);
if isempty(answer)
    return
end
pmlwidth=str2num(answer{7});
max_grid_size=str2num(answer{1});
if str2num(answer{4})>str2num(answer{5})
    x=linspace(0,str2num(answer{4}),max_grid_size);
    dx=x(2)-x(1);
    y=[0:dx:str2num(answer{5})];
else
    y=linspace(0,str2num(answer{5}),max_grid_size);
    dx=y(2)-y(1);
    x=[0:dx:str2num(answer{4})];
end

backgroundeps=str2num(answer{2});
backgroundmu=mu0*str2num(answer{3});
epsilon=backgroundeps*ones(length(x), length(y));
mu=backgroundmu*ones(length(x), length(y));
ZS=str2num(answer{6});

alphadat=ones(length(x), length(y));
usergeneralparameters=answer;