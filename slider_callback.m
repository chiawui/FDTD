function slider_callback(hObj,event,ax) %#ok<INUSL>
global height coax_length
    name = get(hObj,'String');
%     if(strcmp(name,'radius'))
%       height = get(hObj,'Value');
%     elseif(strcmp(name,'coax_length'))
%       coax_length=get(hObj,'Value');
%     end
    plotmesh
end
