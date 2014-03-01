clear global
global epsilon0 mu0 c max_grid_size height coax_length x y epsilon 
clc

set(0,'defaulttextfontsize',20)
TextInfo.FontSize = get(0,'FactoryUIControlFontSize');
set(0,'defaultaxesfontsize',20)

scrsz = get(0,'ScreenSize');
figure('outerposition',[1 40 scrsz(3) scrsz(4)-40],'color',[0.9,0.9,0.9])
TextInfo.FontSize = 20;

c=299792458;
epsilon0=8.854187817e-12;
mu0=12.566370e-7;

definegeneralparameters;
defineantennaparameters;
plotmesh;

uicontrol('Position',[220 60 200 40],'String','Change Geometry Details',...
    'Callback','definegeneralparameters');
  
uicontrol('Position',[220 20 200 40],'String','Change Antenna Parameters',...
    'Callback','defineantennaparameters');

uicontrol('Style', 'slider','Min',1,'Max',max_grid_size+1,'SliderStep',[1/max_grid_size 1/max_grid_size],'Value',height,...
          'String', 'radius', 'Position', [750 60 200 20],...
          'Callback', {@slider_callback});

uicontrol('Style', 'slider','Min',1,'Max',max_grid_size+1,'SliderStep',[1/max_grid_size 1/max_grid_size],'Value',coax_length,...
          'String', 'coax_length', 'Position', [750 30 200 20],...
          'Callback', {@slider_callback});
