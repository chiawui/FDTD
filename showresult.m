function showresult( hObj, event )
  val=get(hObj,'Value');
  if val==1
    update_mesh('material');
  elseif val==2
    update_mesh('E_norm');
  elseif val==3
    update_mesh('log10(E_norm)');
  elseif val==4
    update_mesh('Er');
  elseif val==5
    update_mesh('Ez');
  elseif val==6
    update_mesh('Hp');
  elseif val==7
    update_mesh('Z');
  elseif val==8
    update_mesh('SAR');
  end
end

