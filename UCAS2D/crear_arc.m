% Funcion para analizar cierre de modelo
if isempty(ve_conex) == 0                                       % Si existe elementos
    answer = questdlg('¿Guardar Modelo Actual?', ...         % Cuadro de dialogo
	'UCAS2D','Sí','No','Cancelar','Sí');
    if isempty(answer)              % Opcion de X 
        answer = 'Cancelar'; 
    end   
    switch answer                   % Analisis de respuesta
        case 'Cancelar'
            op_abrir = 0;           % Opcion cancelar
        case 'Sí'
            op_abrir = 1;           % Opcion si desea guardar datos existentes
        case 'No'
            op_abrir = 2;           % Opcion no desea guardar datos existentes
    end
else
    op_abrir = 2;                   % Opcion no desea guardar datos existentes
end