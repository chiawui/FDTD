clear global
global epsilon0 mu0 c0 
clc

set(0,'defaulttextfontsize',20)
TextInfo.FontSize = get(0,'FactoryUIControlFontSize');
set(0,'defaultaxesfontsize',20)

scrsz = get(0,'ScreenSize');
figure('outerposition',[1 40 scrsz(3) scrsz(4)-40],'color',[0.9,0.9,0.9])
TextInfo.FontSize = 20;

c0=299792458;
epsilon0=8.854187817e-12;
mu0=12.566370e-7;

definegeneralparameters;
defineantennaparameters;
update_mesh('material');

%[left bottom width height]
uicontrol('Position',[220 60 200 40],'String','Change Geometry Details',...
    'Callback','definegeneralparameters');
  
uicontrol('Position',[220 20 200 40],'String','Change Antenna Parameters',...
    'Callback','defineantennaparameters');

uicontrol('Position',[420 60 200 40],'String','Bioheat Simulation',...
    'Callback','simulate_bioheat');

uicontrol('Position',[420 20 200 40],'String','Time Domain Simulation',...
    'Callback','Startsimulation(1)');

uicontrol('Position',[620 60 200 40],'String','Frequency Domain Simulation',...
  'Callback','Startsimulation(2)');

uicontrol('Position',[620 20 200 40],'String','Calculate Impedance',...
    'Callback','Startsimulation(3)');
  
uicontrol('Style', 'text', 'Position',[920 40 35 40],'String','Result');
  
uicontrol('Style', 'popupmenu', 'Position',[920 20 80 40],'String',...
    'material|E_norm|log10(Enorm)|Er|Ez|Hp|Z|SAR',...
    'Callback',@showresult);
  
uicontrol('Position',[1120 20 100 40],'String','Update mesh',...
    'Callback','update_mesh(''material'')');

% uicontrol('Style', 'slider','Min',1,'Max',max_grid_size+1,'SliderStep',[1/max_grid_size 1/max_grid_size],'Value',height,...
%           'String', 'radius', 'Position', [750 60 200 20],...
%           'Callback', {@slider_callback});
% 
% uicontrol('Style', 'slider','Min',1,'Max',max_grid_size+1,'SliderStep',[1/max_grid_size 1/max_grid_size],'Value',coax_length,...
%           'String', 'coax_length', 'Position', [750 30 200 20],...
%           'Callback', {@slider_callback});
