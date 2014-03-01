function plotmesh

global x y epsilon height coax_length backgroundeps inner_d outer_d teflon_p

%reset with bacground eps
epsilon=ones(length(x),length(y))*backgroundeps;
%set antenna
epsilon(1:(1+inner_d),1:(height+coax_length))=0;
epsilon((outer_d):length(x),1:(coax_length))=0;
epsilon(1+inner_d:outer_d-1,1:(height+coax_length))=1/teflon_p;

%imagesc(x,fliplr(y),epsilon);% flip the y to fit imagesc
surf(y,x,epsilon);
view(-90,90);
xlabel('mm')
ylabel('mm')
grid minor;

axis image;
%axis([0 y(end) 0 x(end)])
title('epsilon')
set(gca,'Units','pixel')
a = get(gcf,'outerposition');
set(gca, 'Position',[a(1)+100 170 a(3)-250 a(4)-320]);

end

        
