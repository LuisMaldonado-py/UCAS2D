function SAP2000()  % Exporta a SAP 2000
global vs_geo vn_coor vn_obj ve_obj ve_conex vm_pro vs_pro vm_eti vs_eti mag_text
try         % Trata de exportar
    [file,path] = uiputfile('Modelo_SAP.xlsx','Exportar Modelo a SAP2000'); % Abre directorio
    filename = fullfile(path,file);                     % Nombre de direccion mas archivo
    copyfile ('Plantilla_SAP2000.xlsx',filename,'f');   % Copia Plantilla existente en carpeta
    nn = size(vn_obj,1); ne = size(ve_obj,1); ns = size(vs_pro,1); nm = size(vm_pro,1); % Numero de nodos, elementos, secciones, materiales
%% Tabla 1 (Tabla de nodos) -----------------------------------------------
    tabla = num2cell(vn_obj(:,2));              % Primeros datos de la tabla
    for i = 1:nn                                % Recorre nodos
        tabla(i,2:3) = {'GLOBAL' 'Cartesian'};  % Texto de tabla
    end
    tabla = [tabla num2cell(vn_coor(:,2)) num2cell(zeros(nn,1)) num2cell(vn_coor(:,3))];    % Tabla final
    xlswrite(filename,tabla,'Joint Coordinates',strcat('A4:F',num2str(nn+3)));              % Exportar tabla a excel
    tex = {mag_text{2} mag_text{2} mag_text{2}};                            % Modificar unidades
    xlswrite(filename,tex,'Joint Coordinates','D3:F3');                     % Unidades a excel
%% Tabla 2 (Tabla de conectividad) ----------------------------------------
    tabla =[]; tabla1 ={};                                  % Inicio de tabla
    for i = 1:ne                                            % Recorre cada elemento
        %% (Tabla de conectividad) 
        ni = ve_conex(i,2); ni = find(vn_obj(:,1) == ni);   % Busca nombre de nodo inicial
        nf = ve_conex(i,3); nf = find(vn_obj(:,1) == nf);   % Busca nombre de nodo final
        tabla(end+1,:) = [vn_obj(ni,2) vn_obj(nf,2)];       % crea tabla de nodos iniciales y finales
        %% (Tabla de elementos)
        bas1 = find(vs_geo(:,1) == ve_conex(i,4));          % Busca seccion de elementos
        if vs_eti{bas1,4} == 1                              % Recorre elemento analizando cada seccion
            bas2 = 'Rectangular';                           % Nombra cada tipo de seccion
        elseif vs_eti{bas1,4} == 2
            bas2 = 'I/Wide Flange';
        else
            bas2 = 'General';
        end
        tabla1 = [tabla1;{i bas2 'N.A.' vs_eti{bas1,2}}];   % Tabla final
    end
    tabla = [(1:1:ne)' tabla];                                  % Crea tabla definitiva
    xlswrite(filename,tabla,'Connectivity - Frame',strcat('A4:C',num2str(ne+3)));       % Exportar tabla a excel   
    xlswrite(filename,tabla1,'Frame Section Assignments',strcat('A4:D',num2str(ne+3))); % Exportar tabla a excel
%% Tabla 3 (Restricciones) ------------------------------------------------
    tabla ={};                                                              % Tabla de inicio
    bas = find(vn_coor(:,4) == 1 | vn_coor(:,5) == 1 | vn_coor(:,6) == 1);  % Analiza cuales tienen restricciones
    if isempty(bas) == 0                                                    % Si existen restricciones
        tabla(:,1) = num2cell(bas);                                         % Transforma a cell
        for i = 1:size(bas,1)                                   % Llena tabla de restricciones
            tabla(i,2:7) = {'No' 'No' 'No' 'No' 'No' 'No'};
            if vn_coor(bas(i),4) == 1
                tabla(i,2) = {'Yes'};
            end
            if vn_coor(bas(i),5) == 1
                tabla(i,4) = {'Yes'};
            end
            if vn_coor(bas(i),6) == 1
                tabla(i,6) = {'Yes'};
            end
        end
        xlswrite(filename,tabla,'Joint Restraint Assignments',strcat('A4:G',num2str(size(bas,1)+3)));   % Exportar tabla a excel
    end
%% Tabla 4 (Tabla de Secciones) -------------------------------------------
    tabla = [{'SEC_Exmod' vm_eti{1,2} 'I/Wide Flange' 20 10 2 1 10 2} cell(1,9)];   % Seccion por defecto
    for i = 1:ns                                                            % recorre lista de secciones
        bas1 = find(vm_pro(:,1) == vs_eti{i,6});                            % Busca materiles de la seccion
        if vs_eti{i,4} == 1                                                 % Saca propiedades de la seccion
            bas2 = ['Rectangular' num2cell(vs_geo(i,[3 2])) cell(1,13)];
        elseif vs_eti{i,4} == 2
            bas2 = ['I/Wide Flange' num2cell([vs_geo(i,2) vs_geo(i,4:5) vs_geo(i,3:5)]) cell(1,9)];
        else
            bas2 = ['General' num2cell(vs_geo(i,2:3)) cell(1,4) num2cell([vs_pro(i,4) 0 vs_pro(i,7:8) 0 vs_pro(i,[5 6 9 10])])];
        end
        tabla = [tabla; vs_eti{i,2} vm_eti{bas1,2} bas2];                   % Anexa tabla
    end
    xlswrite(filename,tabla,'Frame Props 01 - General',strcat('A4:R',num2str(ns+4)));  % Exportar tabla a excel
    tex = {mag_text{2} mag_text{2} mag_text{2} mag_text{2} mag_text{2} mag_text{2} strcat(mag_text{2},'2') strcat(mag_text{2},'4') strcat(mag_text{2},'4') strcat(mag_text{2},'4') strcat(mag_text{2},'4') strcat(mag_text{2},'2') strcat(mag_text{2},'2') strcat(mag_text{2},'3') strcat(mag_text{2},'3')};
    xlswrite(filename,tex,'Frame Props 01 - General','D3:R3');      
%% Tabla 4 (Tabla de Materiales) ------------------------------------------
    tabla = {};tabla1 = {};                                                 % inicio tabla de materiales
    for i = 1:nm                                                            % Recorre materiales
        tabla = [tabla;{vm_eti{i,2} 'Steel' 'Isotropic' 'No'}];             % Anexa texto sap
        tabla1 = [tabla1;vm_eti(i,2) num2cell(vm_pro(i,[2 7 3 8 4 5]))];    % Anexa propiedades
    end
    xlswrite(filename,tabla,'MatProp 01 - General',strcat('A5:D',num2str(nm+4)));              % Exportar tabla a excel
    xlswrite(filename,tabla1,'MatProp 02 - Basic Mech Props',strcat('A5:G',num2str(nm+4)));    % Exportar tabla a excel
    tex = {strcat(mag_text{1},'/',mag_text{2},'3') strcat(mag_text{1},'-s2/',mag_text{2},'4') strcat(mag_text{1},'/',mag_text{2},'2') strcat(mag_text{1},'/',mag_text{2},'2') 'Unitless' strcat('1/',mag_text{3})}; % Unidades
    xlswrite(filename,tex,'MatProp 02 - Basic Mech Props','B3:G3');         % Exportar tabla a excel
    mag = {strcat(mag_text{1},', ',mag_text{2},', ',mag_text{3})};          % Unidades
    xlswrite(filename,mag,'Program Control','H4:H4');                       % Exportar tabla a excel
end