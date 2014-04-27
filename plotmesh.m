% plotmesh responsible of setting a formatted way to represent mesh
% field 1=Er, 2=Ez, 3=Hp, 4=permittivity
function plotmesh(field)

global x_dimension y_dimension cell_size

[x,y]=discretize_grid(x_dimension, y_dimension, cell_size);

%surf(y,x,field(1:length(x), pmlwidth+1:length(y)+pmlwidth));
surf(y,x,field);
view(-90,90);
grid minor;

xlabel('z axis');
ylabel('r axis');

axis image;
%colorbar;very slow
%axis([0 y(end) 0 x(end)])
set(gca,'Units','pixel')
a = get(gcf,'outerposition');
set(gca, 'Position',[a(1)+100 170 a(3)-250 a(4)-320]);

end

        
