
function definegeneralparameters
%This function is a dialogue which defines the general simulation
%parameters
global x y dx backgroundeps backgroundmu epsilon mu ZS  epsilon0 mu0 alphadat pmlwidth usergeneralparameters...

prompt={'maximum number of Gridpoints in one Dimension','\epsilon - Background','\mu - Background','Size x-Dimension [\mum]','Size y-Dimension [\mum]','Number of timesteps','Number of Perfectly Matched Layers'};

name='Simulation Parameters';
numlines=1;
defaultanswer=usergeneralparameters;
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
options.fonsize=20;
answer=inputdlg(prompt,name,numlines,defaultanswer,options);
if isempty(answer)
    return
end
pmlwidth=str2num(answer{7});

x=linspace(0,str2num(answer{4}),str2num(answer{1}));
dx=x(2)-x(1);
y=[0:dx:str2num(answer{5})];

backgroundeps=str2num(answer{2});
backgroundmu=mu0*str2num(answer{3});
epsilon=backgroundeps*ones(length(x), length(y));
mu=backgroundmu*ones(length(x), length(y));
ZS=str2num(answer{6});

alphadat=ones(length(x), length(y));
usergeneralparameters=answer;