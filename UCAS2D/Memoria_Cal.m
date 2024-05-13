%% -------------- Programa para Crear memoria de calculo ---------------
global vn_coor ve_conex vn_obj mat_res vn_fx vn_fy vn_fg op_play op_nolin
global vn_cop axe_dibujo op_eln op_rel op_non op_ffp vn_coor_o Ef U1g P1g
global p GDL op_meto
nn = size(vn_coor,1); ne = size(ve_conex,1);  % Creacion de tabla final/# nodos/# elementos
col_t = 'white';
%% Directorio
try                                     % Abre directorio y guarda archivos
     [file,path] = uiputfile('Memoria.pdf','Generar Memoria');
     filename = fullfile(path,file);
%% Crear Reporte
    import mlreportgen.report.*;        % Importar paquete de reportes
    import mlreportgen.dom.*;
    rpt = Report(filename);         % Crea reporte en disco
    %rpt = Report('Simple.pdf');         % Crea reporte en disco
    open(rpt)
if op_play == 1
%% Titulo    
    pag_i = TitlePage;
    pag_i.Title = Text('MEMORIA DE CALCULO ANALISIS ESTRUCTURAL');
    set(pag_i.Title,'bold',1,'FontSize','30pt','color','navy','FontFamilyName','Times New Roman');
    pag_i.Subtitle = Text('Analisis Lineal - UCAS2D');
    set(pag_i.Subtitle,'bold',1,'italic',1,'FontSize','20pt','color','navy','FontFamilyName','Times New Roman');
    pag_i.Author = Text('Carlos Mauricio Calderón Bernal   -   Luis Alfonso Morocho Guaman');
    set(pag_i.Author,'bold',1,'italic',1,'FontSize','12pt','FontFamilyName','Times New Roman');
    add(rpt,pag_i);
%% Datos Ingresados
    p1 = Paragraph('1. DATOS INGRESADOS');
    p1.Style = {OuterMargin('','','30pt','12pt')};
    set(p1,'Bold',1,'Color','navy','FontSize','14pt');
    add(rpt,p1);
%% --------- Nodos ------------
    p1 = Paragraph('1.1. Tabla de Nodos');
    p1.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p1,'Color','navy','FontSize','12pt');
    add(rpt,p1);
    %----------- CALCULO -------------
    tab = [(1:1:nn)' vn_coor_o];   % Creacion de tabla de nodos
    tab = num2cell(tab);tab =[{'Nodo' 'Coordenada X' 'Coordenada Y'} ; tab];
    t1 = Table(tab);
    set(t1,'BackgroundColor',col_t,'Border','solid',...
        'ColSep','solid','RowSep','solid','Width','50%',...
        'TableEntriesHAlign','center'); % ,'Halign','center'
    add(rpt,t1);
    %% --------- Elementos ------------
    p2 = Paragraph('1.2. Tabla de Conectividad');
    p2.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p2,'Color','navy','FontSize','12pt');
    add(rpt,p2);
    %----------- CALCULO -------------
    tab =[];
    for i = 1:ne                        % anliza cada elemento
        ni = ve_conex(i,2); ni = find(vn_obj(:,1) == ni);   % Busca nombre de nodo inicial
        nf = ve_conex(i,3); nf = find(vn_obj(:,1) == nf);   % Busca nombre de nodo final
        tab(end+1,:) = [vn_obj(ni,2) vn_obj(nf,2)];         % crea tabla de nodos iniciales y finales
    end
    tab = [(1:1:ne)' tab];                                  % Crea tabla definitiva
    tab = num2cell(tab);tab =[{'Elemento' 'Nodo Inicial' 'Nodo Final'} ; tab];
    t1 = Table(tab);
    set(t1,'BackgroundColor',col_t,'Border','solid',...
        'ColSep','solid','RowSep','solid','Width','50%',...
        'TableEntriesHAlign','center');
    add(rpt,t1);
    %% --------- MATERIAL ------------
    pn = Paragraph('1.3. Propiedades del Material');
    pn.Style = {OuterMargin('12pt','','20pt','20pt')};
    set(pn,'Color','navy','FontSize','12pt','WhiteSpace','pre-wrap');
    add(rpt,pn);
    %----------- CALCULO -------------
    tab = mat_res{14};
    mate = string(tab(:,2:end));
        for j = 1:numel(mate)
        mate(j) = sprintf('%.3f',mate(j));
        end
    tab =[{'Material' 'E' 'v' 'C. Temp.' 'E. Fluencia'}; [tab(:,1) mate(:,1:2) tab(:,4) mate(:,4)]];
    t1 = Table(tab);
    set(t1,'BackgroundColor',col_t,'Border','solid',...
        'ColSep','solid','RowSep','solid','TableEntriesHAlign','center','Width','100%');
    add(rpt,t1);
    %% --------- Seccion ------------
    p1 = Paragraph('1.4. Propiedades de la Seccion');
    p1.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p1,'Color','navy','FontSize','12pt');
    add(rpt,p1);
    %----------- CALCULO -------------
    tab = mat_res{15};
    mate = string(tab(:,3:end));
        for j = 1:numel(mate)
        mate(j) = sprintf('%.2f',mate(j));
        end
    tab =[{'Seccion' 'Tipo' 'H' 'B' 'A. Tran.' 'A. Corte' 'I' 'Z'}; [tab(:,1) tab(:,2) mate]];
    t1 = Table(tab);
    set(t1,'BackgroundColor',col_t,'Border','solid',...
        'ColSep','solid','RowSep','solid','Width','100%',...
        'TableEntriesHAlign','center'); % ,'Halign','center'
    add(rpt,t1);
    %% --------- Vectores de Fuerzas y Desplazamientos ------------
    p1 = Paragraph('1.5. Vector de Fuerzas y Desplazamiento');
    p1.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p1,'Color','navy','FontSize','12pt');
    add(rpt,p1);
    %----------- CALCULO -------------
    tab = {'GDL' 'U' 'F' 'S/P'};
    for i = 1:nn
        tab(end+1:end+3,1) = {(i*3)-2 (i*3)-1 i*3};
        basu = {}; basf = {}; basp = {};
        for j = 0:2
            if vn_coor(i,4+j) == 1
                basu(end+1) = {vn_coor(i,7+j)};
                basf(end+1) = {strcat('R',num2str(((i-1)*3)+(j+1)))};
                basp(end+1) = {'S'};
            else
                basu(end+1) = {strcat('u',num2str(((i-1)*3)+(j+1)))};
                basp(end+1) = {'P'};
                if j == 0
                    basf(end+1) = {vn_fx(i,2)};
                elseif j == 1
                    basf(end+1) = {vn_fy(i,2)};
                else
                    basf(end+1) = {vn_fg(i,2)};
                end
            end
        end
        tab(end-2:end,2:4) = [basu' basf' basp'];
    end
    t1 = Table(tab);
    set(t1,'BackgroundColor',col_t,'Border','solid',...
        'ColSep','solid','RowSep','solid','Width','50%',...
        'TableEntriesHAlign','center'); % ,'Halign','center'
    add(rpt,t1);
    p1 = Paragraph('S: GDL que se conoce el desplazamiento.');
    p1.Style = {OuterMargin('20pt','','12pt','5pt')};
    set(p1,'italic',1,'FontSize','10pt');
    add(rpt,p1);
    p1 = Paragraph('P: GDL que se desconoce el desplazamiento.');
    p1.Style = {OuterMargin('20pt','','','12pt')};
    set(p1,'italic',1,'FontSize','10pt');
    add(rpt,p1);
%% Calculos
    p1 = Paragraph('2. CALCULOS');
    p1.Style = {OuterMargin('','','30pt','12pt')};
    set(p1,'Bold',1,'Color','navy','FontSize','14pt');
    add(rpt,p1);
%% --------- Matrices Elementales Locales ------------
    p1 = Paragraph('2.1. Matrices Elementales Locales');
    p1.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p1,'Color','navy','FontSize','12pt');
    add(rpt,p1);
    %----------- CALCULO -------------
    bas1 = mat_res{7};
    for i = 1:ne
        tab = {};
        mate = string(bas1{i});
        for j = 1:numel(mate)
        mate(j) = sprintf('%.2f',mate(j));
        end
        ni = ve_conex(i,2); ni = find(vn_obj(:,1) == ni); ni = vn_obj(ni,2);    % Busca nombre de nodo inicial
        nf = ve_conex(i,3); nf = find(vn_obj(:,1) == nf); nf = vn_obj(nf,2);    % Busca nombre de nodo final
        C = {strcat('u',num2str(((ni-1)*3)+1)) strcat('u',num2str(((ni-1)*3)+2)) strcat('u',num2str(((ni-1)*3)+3)) strcat('u',num2str(((ni-1)*3)+1)) strcat('u',num2str(((ni-1)*3)+2)) strcat('u',num2str(((ni-1)*3)+3))};
        F = [{''} C];
        tab = [C;mate]; tab = [F' tab];
        % ---- TEXt ------
        p1 = Paragraph(strcat('Elemento (',num2str(i),')'));
        p1.Style = {OuterMargin('20pt','','12pt','')};
        set(p1,'bold',1,'Color','navy','FontSize','10pt','HAlign','center');
        add(rpt,p1);
        %----------- CALCULO -------------
        t1 = Table(tab);
        set(t1,'BackgroundColor',col_t,'Border','solid',...
            'ColSep','solid','RowSep','solid','Width','100%',...
            'TableEntriesHAlign','center'); % ,'Halign','center'
        add(rpt,t1);
    end
    %% --------- Matrices Elementales Globales ------------    
    p1 = Paragraph('2.2. Matrices Elementales Globales');
    p1.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p1,'Color','navy','FontSize','12pt');
    add(rpt,p1);
    %------ Ecuacion ------
    eq = Equation('[k_L] = [B]^T  [k_G]  [B]');
    eq.FontSize = 10; 
    eq.Color = 'k';
    add(rpt,eq);
    %----------- CALCULO -------------
    bas1 = mat_res{8};
    for i = 1:ne
        tab = {};
        mate = string(bas1{i});
        for j = 1:numel(mate)
        mate(j) = sprintf('%.2f',mate(j));
        end
        ni = ve_conex(i,2); ni = find(vn_obj(:,1) == ni); ni = vn_obj(ni,2);    % Busca nombre de nodo inicial
        nf = ve_conex(i,3); nf = find(vn_obj(:,1) == nf); nf = vn_obj(nf,2);    % Busca nombre de nodo final
        C = {strcat('u',num2str(((ni-1)*3)+1)) strcat('u',num2str(((ni-1)*3)+2)) strcat('u',num2str(((ni-1)*3)+3)) strcat('u',num2str(((ni-1)*3)+1)) strcat('u',num2str(((ni-1)*3)+2)) strcat('u',num2str(((ni-1)*3)+3))};
        F = [{''} C];
        tab = [C;mate]; tab = [F' tab];
        % ---- TEXt ------
        p1 = Paragraph(strcat('Elemento (',num2str(i),')'));
        p1.Style = {OuterMargin('20pt','','12pt','')};
        set(p1,'bold',1,'Color','navy','FontSize','10pt','HAlign','center');
        add(rpt,p1);
        %----------- CALCULO -------------
        t1 = Table(tab);
        set(t1,'BackgroundColor',col_t,'Border','solid',...
            'ColSep','solid','RowSep','solid','Width','100%',...
            'TableEntriesHAlign','center'); % ,'Halign','center'
        add(rpt,t1);
    end
    %% --------- Fuerzas de Empotramiento Globales ------------
    p1 = Paragraph('2.3. Fuerzas de Empotramiento Globales');
    p1.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p1,'Color','navy','FontSize','12pt');
    add(rpt,p1);
    %----------- CALCULO -------------
    tab = mat_res{16};
    if isempty(tab) == 0
        bas1 = {'Elem' 'A(Ni)' 'V(Ni)' 'M(Ni)' 'A(Nf)' 'V(Nf)' 'M(Nf)'};
        for i = 1:ne
            mate = string(tab{i})';
            for j = 1:numel(mate)
                mate(j) = sprintf('%.2f',mate(j));
            end
            bas1=[bas1;[{i} mate]];
        end
        t1 = Table(bas1);
        set(t1,'BackgroundColor',col_t,'Border','solid',...
            'ColSep','solid','RowSep','solid','Width','50%',...
            'TableEntriesHAlign','center','Width','100%'); % ,'Halign','center'
        add(rpt,t1);
    else
        p1 = Paragraph('No existen cargas en elementos, por ende, no existe Fuerzas de Empotramiento.');
        p1.Style = {OuterMargin('12pt','','12pt','12pt')};
        set(p1,'Color','navy','FontSize','10pt','Italic',1,'Bold',1);
        add(rpt,p1);
    end
    %% --------- Fuerzas Equivalentes ------------
    p1 = Paragraph('2.4. Fuerzas de Equivalentes');
    p1.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p1,'Color','navy','FontSize','12pt');
    add(rpt,p1);
    %----------- CALCULO -------------
    tab = mat_res{17};
    if isequal(tab,zeros(1,size(tab,1))) == 0
        bas1 = {'Nodo' 'Fx' 'Fy' 'Mz'};
        for i = 0:nn-1
            mate = string(tab((i*3)+1:(i*3)+3)');
            for j = 1:numel(mate)
                mate(j) = sprintf('%.2f',mate(j));
            end
            bas1=[bas1;[{i+1} mate]];
        end
        t1 = Table(bas1);
        set(t1,'BackgroundColor',col_t,'Border','solid',...
            'ColSep','solid','RowSep','solid','Width','50%',...
            'TableEntriesHAlign','center','Width','100%'); % ,'Halign','center'
        add(rpt,t1);
    else
        p1 = Paragraph('No existen cargas en elementos, por ende, no existe Fuerzas Equivalentes.');
        p1.Style = {OuterMargin('12pt','','12pt','12pt')};
        set(p1,'Color','navy','FontSize','10pt','Italic',1,'Bold',1);
        add(rpt,p1);
    end
    %% Exportar Matrices a excel
    a = 0; con = 1;     % Variables de contadores
    while a == 0
        if exist(strcat(path,"Anexo_",num2str(con),'.xlsx')) == 0
            filename_t = strcat(path,"Anexo_",num2str(con),'.xlsx')
            a = 1;
        else
            con = con + 1;
        end
    end
    % Matriz K
    tabk = num2cell(mat_res{9});
    bas1 = {};
    for i = 1:nn
        bas1(end+1:end+3) = {strcat('u',num2str((i*3)-2)) strcat('u',num2str((i*3)-1)) strcat('u',num2str(i*3))};
    end   
    tabk = [[{''} bas1];[bas1' tabk]];
    % Matriz Kpp
    tabkpp = num2cell(mat_res{10});
    bas3 = mat_res{3};
    bas1 = {};
    for i = 1:size(bas3,1)
        bas1(end+1,1) = {strcat('u',num2str(bas3(i)))};
    end
    tabkpp = [[{''} bas1'];[bas1 tabkpp]];
    % Matriz Kps
    tabkps = num2cell(mat_res{11});
    bas3 = mat_res{2}; bas4 = mat_res{3};
    bas1 = {}; bas2 = {};
    n = max(size(bas3,1),size(bas4,1));
    for i = 1:n
        if i < size(bas3,1)+1   % GDL S
            bas1(end+1) = {strcat('u',num2str(bas3(i)))};
        end
        if i < size(bas4,1)+1   % GDL P
            bas2(end+1) = {strcat('u',num2str(bas4(i)))};
        end
    end
    tabkps = [[{''} bas1];[bas2' tabkps]];
    % Matriz Ksp
    tabksp = num2cell(mat_res{12});
        bas3 = mat_res{2}; bas4 = mat_res{3};
        bas1 = {}; bas2 = {};
        n = max(size(bas3,1),size(bas4,1));
        for i = 1:n
            if i < size(bas3,1)+1   % GDL S
                bas1(end+1) = {strcat('u',num2str(bas3(i)))};
            end
            if i < size(bas4,1)+1   % GDL P
                bas2(end+1) = {strcat('u',num2str(bas4(i)))};
            end
        end
    tabksp = [[{''} bas2];[bas1' tabksp]];
    % Matriz Kss
    tabkss = num2cell(mat_res{13});
    bas3 = mat_res{2};
    bas1 = {};
    for i = 1:size(bas3,1)
        bas1(end+1) = {strcat('U',num2str(bas3(i)))};
    end
    tabkss = [[{''} bas1];[bas1' tabkss]];
    xlswrite(filename_t,tabk,'K');
    xlswrite(filename_t,tabkpp,'Kpp');
    xlswrite(filename_t,tabkps,'Kps');
    xlswrite(filename_t,tabksp,'Ksp');
    xlswrite(filename_t,tabkss,'Kss');
    %% Texto de matrices globales
    p1 = Paragraph('2.5. Matrices Globales (K,Kpp,Kps,Ksp y Kpp)');
    p1.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p1,'Color','navy','FontSize','12pt');
    add(rpt,p1);
    p1 = Paragraph(strcat('Debido a las dimensiones de las matrices, se exportaron a un Archivo Excel "Anexo_',num2str(con),'" en la direccion:'));
    p1.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p1,'Color','navy','FontSize','10pt','Italic',1);
    add(rpt,p1);
    p1 = Paragraph(filename_t);
    p1.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p1,'Color','navy','FontSize','10pt','Italic',1,'Bold',1);
    add(rpt,p1);
    tabksp = num2cell(mat_res{12});
    tab = num2cell(mat_res{16});
    %% --------- Desplazamientos Desconocidos ------------
    p1 = Paragraph('2.6. Desplazamientos Desconocidos (Up)');
    p1.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p1,'Color','navy','FontSize','12pt');
    add(rpt,p1);
    %----- Ecuacion 
    eq = Equation('{up} = [K_{pp}]^{-1} (F_p - [K_{ps}] u_s)');
    eq.FontSize = 10; 
    eq.Color = 'k';
    add(rpt,eq);
    %----------- CALCULO -------------
    mate = string(mat_res{19});
    bas1 = {'GDL' 'Up'};
    for j = 1:numel(mate)
    	mate(j) = sprintf('%.3f',mate(j));
    end
    bas1 = [bas1;[mat_res{3} mate]];
    t1 = Table(bas1);
    set(t1,'BackgroundColor',col_t,'Border','solid',...
          'ColSep','solid','RowSep','solid',...
          'TableEntriesHAlign','center','Width','30%'); % ,'Halign','center'
    add(rpt,t1);
    %% --------- Fuerzas Desconocidos ------------
    p1 = Paragraph('2.7. Fuerzas Desconocidas (Fs)');
    p1.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p1,'Color','navy','FontSize','12pt');
    add(rpt,p1);
    %----- Ecuacion 
    eq = Equation('{F_s} = [K_{sp}] u_p + [K_{ss}] u_s'); 
    eq.FontSize = 12; 
    eq.Color = 'k';
    add(rpt,eq);
    %----------- CALCULO -------------
    mate = string(mat_res{20});
    bas1 = {'GDL' 'Fs'};
    for j = 1:numel(mate)
    	mate(j) = sprintf('%.3f',mate(j));
    end
    bas1 = [bas1;[mat_res{2} mate]];
    t1 = Table(bas1);
    set(t1,'BackgroundColor',col_t,'Border','solid',...
          'ColSep','solid','RowSep','solid',...
          'TableEntriesHAlign','center','Width','30%'); % ,'Halign','center'
    add(rpt,t1);
    %% --------- Resultado de Fuerzas y Desplazamineto ------------
    p1 = Paragraph('2.8. Desplazamientos y Fuerzas Nodales Resultantes');
    p1.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p1,'Color','navy','FontSize','12pt');
    add(rpt,p1);
    %----------- CALCULO -------------
    bas2 = mat_res{1};
    bas3 = mat_res{18};
    bas1 = {'Nodo' 'Ux' 'Uy' 'Uz' 'Fx' 'Fy' 'Mz'};
    for i = 0:nn-1
        mate = string([bas2((i*3)+1:(i*3)+3)' bas3((i*3)+1:(i*3)+3)']);
        for j = 1:numel(mate)
            mate(j) = sprintf('%.2f',mate(j));
        end
        bas1=[bas1;[{i+1} mate]];
    end
    t1 = Table(bas1);
    set(t1,'BackgroundColor',col_t,'Border','solid',...
          'ColSep','solid','RowSep','solid','Width','100%',...
          'TableEntriesHAlign','center'); % ,'Halign','center'
    add(rpt,t1);
    %% --------- Fuerzas elementales Locales ------------
    p1 = Paragraph('2.9. Fuerzas Elementales Locales');
    p1.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p1,'Color','navy','FontSize','12pt');
    add(rpt,p1);
    %----------- CALCULO -------------
    tab = [];
    tab_1 =  mat_res{5};    % Extrae fuerzas elementales locales
    for i = 1:ne            % Recorre los n elementos
        tab(end+1,:) = [i tab_1{i}'];   % Clasifica elementos
    end
    t1 = Table(bas1);
    set(t1,'BackgroundColor',col_t,'Border','solid',...
          'ColSep','solid','RowSep','solid',...
          'TableEntriesHAlign','center','Width','100%'); % ,'Halign','center'
    add(rpt,t1);
    %% --------- Fuerzas elementales Globales ------------
    p1 = Paragraph('2.10. Fuerzas Elementales Globales');
    p1.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p1,'Color','navy','FontSize','12pt');
    add(rpt,p1);
    %----------- CALCULO -------------
    tab = [];
    tab_1 =  mat_res{6};    % Extrae fuerzas elementales locales
    for i = 1:ne            % Recorre los n elementos
        tab(end+1,:) = [i tab_1{i}'];   % Clasifica elementos
    end
    t1 = Table(bas1);
    set(t1,'BackgroundColor',col_t,'Border','solid',...
          'ColSep','solid','RowSep','solid',...
          'TableEntriesHAlign','center','Width','100%'); % ,'Halign','center'
    add(rpt,t1);%% Cerrar Documento
%% Analisis No-Lineal
elseif op_play == 2     % Analisis No-Lineal 
%% Analisis No-Lineal de Armaduras    
    if op_nolin == 1
%% Titulo    
    pag_i = TitlePage;
    pag_i.Title = Text('MEMORIA DE CALCULO ANALISIS ESTRUCTURAL');
    set(pag_i.Title,'bold',1,'FontSize','30pt','color','navy','FontFamilyName','Times New Roman');
    pag_i.Subtitle = Text('Analisis No-Lineal - UCAS2D');
    set(pag_i.Subtitle,'bold',1,'italic',1,'FontSize','20pt','color','navy','FontFamilyName','Times New Roman');
    pag_i.Author = Text('Carlos Mauricio Calderón Bernal   -   Luis Alfonso Morocho Guaman');
    set(pag_i.Author,'bold',1,'italic',1,'FontSize','12pt','FontFamilyName','Times New Roman');
    add(rpt,pag_i);
%% Datos Ingresados
    p1 = Paragraph('1. DATOS INGRESADOS');
    p1.Style = {OuterMargin('','','30pt','12pt')};
    set(p1,'Bold',1,'Color','navy','FontSize','14pt');
    add(rpt,p1);
%% --------- Nodos ------------
    p1 = Paragraph('1.1. Tabla de Nodos');
    p1.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p1,'Color','navy','FontSize','12pt');
    add(rpt,p1);
    %----------- CALCULO -------------
    tab = [(1:1:nn)' vn_cop(:,1:2)];   % Creacion de tabla de nodos
    tab = num2cell(tab);tab =[{'Nodo' 'Coordenada X' 'Coordenada Y'} ; tab];
    t1 = Table(tab);
    set(t1,'BackgroundColor',col_t,'Border','solid',...
        'ColSep','solid','RowSep','solid','Width','50%',...
        'TableEntriesHAlign','center'); % ,'Halign','center'
    add(rpt,t1);
    %% --------- Elementos ------------
    p2 = Paragraph('1.2. Tabla de Conectividad');
    p2.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p2,'Color','navy','FontSize','12pt');
    add(rpt,p2);
    %----------- CALCULO -------------
    tab =[];
    for i = 1:ne                        % anliza cada elemento
        ni = ve_conex(i,2); ni = find(vn_obj(:,1) == ni);   % Busca nombre de nodo inicial
        nf = ve_conex(i,3); nf = find(vn_obj(:,1) == nf);   % Busca nombre de nodo final
        tab(end+1,:) = [vn_obj(ni,2) vn_obj(nf,2)];         % crea tabla de nodos iniciales y finales
    end
    tab = [(1:1:ne)' tab];                                  % Crea tabla definitiva
    tab = num2cell(tab);tab =[{'Elemento' 'Nodo Inicial' 'Nodo Final'} ; tab];
    t1 = Table(tab);
    set(t1,'BackgroundColor',col_t,'Border','solid',...
        'ColSep','solid','RowSep','solid','Width','50%',...
        'TableEntriesHAlign','center');
    add(rpt,t1);
    %% --------- MATERIAL ------------
    pn = Paragraph('1.3. Propiedades del Material');
    pn.Style = {OuterMargin('12pt','','20pt','20pt')};
    set(pn,'Color','navy','FontSize','12pt','WhiteSpace','pre-wrap');
    add(rpt,pn);
    %----------- CALCULO -------------
    tab = mat_res{1};
    mate = string(tab(:,2:end));
        for j = 1:numel(mate)
        mate(j) = sprintf('%.3f',mate(j));
        end
    tab =[{'Material' 'E' 'v' 'C. Temp.' 'E. Fluencia'}; [tab(:,1) mate(:,1:2) tab(:,4) mate(:,4)]];
    t1 = Table(tab);
    set(t1,'BackgroundColor',col_t,'Border','solid',...
        'ColSep','solid','RowSep','solid','TableEntriesHAlign','center','Width','100%');
    add(rpt,t1);
    %% --------- Seccion ------------
    p1 = Paragraph('1.4. Propiedades de la Seccion');
    p1.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p1,'Color','navy','FontSize','12pt');
    add(rpt,p1);
    %----------- CALCULO -------------
    tab = mat_res{2};
    mate = string(tab(:,3:end));
        for j = 1:numel(mate)
        mate(j) = sprintf('%.2f',mate(j));
        end
    tab =[{'Seccion' 'Tipo' 'H' 'B' 'A. Tran.' 'A. Corte' 'I' 'Z'}; [tab(:,1) tab(:,2) mate]];
    t1 = Table(tab);
    set(t1,'BackgroundColor',col_t,'Border','solid',...
        'ColSep','solid','RowSep','solid','Width','100%',...
        'TableEntriesHAlign','center'); % ,'Halign','center'
    add(rpt,t1);
%% Resultados
    p1 = Paragraph('2. RESULTADOS');
    p1.Style = {OuterMargin('','','30pt','12pt')};
    set(p1,'Bold',1,'Color','navy','FontSize','14pt');
    add(rpt,p1);
%% Pushover Nodo de control
    p1 = Paragraph('2.1. Pushover en Nodo de Control'); %Paragraph(strcat('2.1. Pushover en Nodo de Control / GDL ',string((mat_res{7}*3)-2)));
    p1.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p1,'Color','navy','FontSize','12pt');
    add(rpt,p1);
    %----------- CALCULO -------------
     if op_meto == 1
         bas1 = [{'Iteracion' 'U' 'P'};num2cell([(0:1:size(mat_res{4},2)-1)' mat_res{4}' mat_res{5}'])];
         t1 = Table(bas1);
         set(t1,'BackgroundColor',col_t,'Border','solid',...
               'ColSep','solid','RowSep','solid','Width','100%',...
               'TableEntriesHAlign','center'); % ,'Halign','center'
         add(rpt,t1);
     else %----------- CALCULO -------------
         bas1 = [{'Iteracion' 'U' 'P'};{(0:length(Ef))' string(round(U1g,4)') string(round(P1g,4)')}];
         if size(U1g,2) <= 100
            t1 = Table(bas1);
             set(t1,'BackgroundColor',col_t,'Border','solid',...
                   'ColSep','solid','RowSep','solid','Width','100%',...
                   'TableEntriesHAlign','center'); % ,'Halign','center'
             add(rpt,t1);
         else
         %% Exportar Matrices a excel
            a = 0; con = 1;     % Variables de contadores
            while a == 0
                if exist(strcat(path,"Anexo_",num2str(con),'.xlsx')) == 0
                    filename_t = strcat(path,"Anexo_",num2str(con),'.xlsx')
                    a = 1;
                else
                    con = con + 1;
                end
            end
            %bas1 = {(0:length(Ef))' string(round(U1g,4)') string(round(P1g,4)')};
            xlswrite(filename_t,{'Iteracion' 'U' 'P'},'NC');  
            xlswrite(filename_t,(0:length(Ef))','NC','A2'); 
            xlswrite(filename_t,[string(round(U1g,4)') string(round(P1g,4)')],'NC','B2'); 
            p1 = Paragraph(strcat('Debido al numero de iteraciones los datos se exportaron a un Archivo Excel "Anexo_',num2str(con),'" en la direccion:'));
            p1.Style = {OuterMargin('12pt','','12pt','12pt')};
            set(p1,'Color','navy','FontSize','10pt','Italic',1);
            add(rpt,p1);
            p1 = Paragraph(filename_t);
            p1.Style = {OuterMargin('12pt','','12pt','12pt')};
            set(p1,'Color','navy','FontSize','10pt','Italic',1,'Bold',1);
            add(rpt,p1);
         end
     end
% %% Pushover en Nodos
%     p1 = Paragraph(strcat('2.2. Pushover en Nodos'));
%     p1.Style = {OuterMargin('12pt','','12pt','12pt')};
%     set(p1,'Color','navy','FontSize','12pt');
%     add(rpt,p1);
%     %% Exportar tabla a excel
%     a = 0; con = 1;     % Variables de contadores
%     while a == 0
%         if exist(strcat(path,"Anexo_",num2str(con),'.xlsx')) == 0
%             filename_t = strcat(path,"Anexo_",num2str(con),'.xlsx')
%             a = 1;
%         else
%             con = con + 1;
%         end
%     end
%     %----------- CALCULO -------------
%     %--------------------
%     p1 = Paragraph(strcat('Debido a las dimensiones de la tabla, se exportaron a un Archivo Excel "Anexo_',num2str(con),'" en la direccion:'));
%     p1.Style = {OuterMargin('12pt','','12pt','12pt')};
%     set(p1,'Color','navy','FontSize','10pt','Italic',1);
%     add(rpt,p1);
%     %---------------------
%     p1 = Paragraph(filename_t);
%     p1.Style = {OuterMargin('12pt','','12pt','12pt')};
%     set(p1,'Color','navy','FontSize','10pt','Italic',1,'Bold',1);
%     add(rpt,p1);
%     %--------------------
%     gdl3 = [3:3:nn*3]'; gdl = [1:1:3*nn]';        % Elimina nodos de momentos
%     ut = mat_res{3};ut(gdl3,:) =[]; gdl(gdl3,:) =[];
%     tgdl = strcat('u',string(gdl)); tgdl((mat_res{7}*2)-1) = 'Control';
%     bas1 = [cellstr(tgdl) num2cell(ut)];
%     ttab = ['GDL' strcat('Iteracion_',string(1:1:size(ut,2)))];
%     bas1 = [ttab ; bas1];
%     %% Excel
%     xlswrite(filename_t,bas1,'Fluencia');    
%% Orden de Fluencia
    p1 = Paragraph(strcat('2.2. Orden de Fluencia de Elementos'));
    p1.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p1,'Color','navy','FontSize','12pt');
    add(rpt,p1);
    %----------- CALCULO -------------
    if op_meto == 1
        flu = mat_res{6}'; flui = {};
        for i = 1:size(flu,1)
            if isempty(flu{i}) == 1
                break
            elseif size(flu{i},2) > 1
                flui(i) = cellstr(num2str(flu{i}));
            else
                flui(i) = cellstr(string(flu{i}));
            end
        end
        tab = [{'Iteracion' 'Elementos'}; cellstr(string((1:1:size(flui,2))')) flui'];     % lista de elementos que fluyen
    else
        Rotulas = mat_res{3};
        c = []; elem = {};
        for i = 1:size(Rotulas,2)
            c(end+1) = Rotulas{i}(1);
            elem(end+1) = {char(strjoin(string(Rotulas{i}(1,2:end)), {' - '}))};
        end
        tab = [{'Desplazamiento' 'Elementos'}; {c' elem'}];     % lista de rotulas que fluyen
    end
    %-------------------------------
    t1 = Table(tab);
    set(t1,'BackgroundColor',col_t,'Border','solid',...
          'ColSep','solid','RowSep','solid','Width','50%',...
          'TableEntriesHAlign','center'); % ,'Halign','center'
    add(rpt,t1);
%% Analisis No-Lineal de Porticos       
    else
%% Titulo    
    pag_i = TitlePage;
    pag_i.Title = Text('MEMORIA DE CALCULO ANALISIS ESTRUCTURAL');
    set(pag_i.Title,'bold',1,'FontSize','30pt','color','navy','FontFamilyName','Times New Roman');
    pag_i.Subtitle = Text('Analisis No-Lineal - UCAS2D');
    set(pag_i.Subtitle,'bold',1,'italic',1,'FontSize','20pt','color','navy','FontFamilyName','Times New Roman');
    pag_i.Author = Text('Carlos Mauricio Calderón Bernal   -   Luis Alfonso Morocho Guaman');
    set(pag_i.Author,'bold',1,'italic',1,'FontSize','12pt','FontFamilyName','Times New Roman');
    add(rpt,pag_i);
%% Datos Ingresados
    p1 = Paragraph('1. DATOS INGRESADOS');
    p1.Style = {OuterMargin('','','30pt','12pt')};
    set(p1,'Bold',1,'Color','navy','FontSize','14pt');
    add(rpt,p1);
%% --------- Nodos ------------
    p1 = Paragraph('1.1. Tabla de Nodos');
    p1.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p1,'Color','navy','FontSize','12pt');
    add(rpt,p1);
    %----------- CALCULO -------------
    tab = [(1:1:nn)' vn_coor_o(:,1:2)];   % Creacion de tabla de nodos
    tab = num2cell(tab);tab =[{'Nodo' 'Coordenada X' 'Coordenada Y'} ; tab];
    t1 = Table(tab);
    set(t1,'BackgroundColor',col_t,'Border','solid',...
        'ColSep','solid','RowSep','solid','Width','50%',...
        'TableEntriesHAlign','center'); % ,'Halign','center'
    add(rpt,t1);
    %% --------- Elementos ------------
    p2 = Paragraph('1.2. Tabla de Conectividad');
    p2.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p2,'Color','navy','FontSize','12pt');
    add(rpt,p2);
    %----------- CALCULO -------------
    tab =[];
    for i = 1:ne                        % anliza cada elemento
        ni = ve_conex(i,2); ni = find(vn_obj(:,1) == ni);   % Busca nombre de nodo inicial
        nf = ve_conex(i,3); nf = find(vn_obj(:,1) == nf);   % Busca nombre de nodo final
        tab(end+1,:) = [vn_obj(ni,2) vn_obj(nf,2)];         % crea tabla de nodos iniciales y finales
    end
    tab = [(1:1:ne)' tab];                                  % Crea tabla definitiva
    tab = num2cell(tab);tab =[{'Elemento' 'Nodo Inicial' 'Nodo Final'} ; tab];
    t1 = Table(tab);
    set(t1,'BackgroundColor',col_t,'Border','solid',...
        'ColSep','solid','RowSep','solid','Width','50%',...
        'TableEntriesHAlign','center');
    add(rpt,t1);
    %% --------- MATERIAL ------------
    pn = Paragraph('1.3. Propiedades del Material');
    pn.Style = {OuterMargin('12pt','','20pt','20pt')};
    set(pn,'Color','navy','FontSize','12pt','WhiteSpace','pre-wrap');
    add(rpt,pn);
    %----------- CALCULO -------------
    tab = mat_res{1};
    mate = string(tab(:,2:end));
        for j = 1:numel(mate)
        mate(j) = sprintf('%.3f',mate(j));
        end
    tab =[{'Material' 'E' 'v' 'C. Temp.' 'E. Fluencia'}; [tab(:,1) mate(:,1:2) tab(:,4) mate(:,4)]];
    t1 = Table(tab);
    set(t1,'BackgroundColor',col_t,'Border','solid',...
        'ColSep','solid','RowSep','solid','TableEntriesHAlign','center','Width','100%');
    add(rpt,t1);
    %% --------- Seccion ------------
    p1 = Paragraph('1.4. Propiedades de la Seccion');
    p1.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p1,'Color','navy','FontSize','12pt');
    add(rpt,p1);
    %----------- CALCULO -------------
    tab = mat_res{2};
    mate = string(tab(:,3:end));
        for j = 1:numel(mate)
        mate(j) = sprintf('%.2f',mate(j));
        end
    tab =[{'Seccion' 'Tipo' 'H' 'B' 'A. Tran.' 'A. Corte' 'I' 'Z'}; [tab(:,1) tab(:,2) mate]];
    t1 = Table(tab);
    set(t1,'BackgroundColor',col_t,'Border','solid',...
        'ColSep','solid','RowSep','solid','Width','100%',...
        'TableEntriesHAlign','center'); % ,'Halign','center'
    add(rpt,t1);
%% Resultados
    p1 = Paragraph('2. RESULTADOS');
    p1.Style = {OuterMargin('','','30pt','12pt')};
    set(p1,'Bold',1,'Color','navy','FontSize','14pt');
    add(rpt,p1);
        
%% Pushover Nodo de control
    p1 = Paragraph('2.1. Pushover en Nodo de Control');
    %p1 = Paragraph(strcat('2.1. Pushover en Nodo de Control / GDL ',string(p(GDL))));
    p1.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p1,'Color','navy','FontSize','12pt');
    add(rpt,p1);
    %----------- CALCULO -------------
%     bas1 = [{'Iteracion' 'U' 'P'};{(0:length(Ef))' string(round(U1g,4)') string(round(P1g,4)')}]
%     t1 = Table(bas1);
%     set(t1,'BackgroundColor',col_t,'Border','solid',...
%           'ColSep','solid','RowSep','solid','Width','100%',...
%           'TableEntriesHAlign','center'); % ,'Halign','center'
%     add(rpt,t1);
    
    
    
    
    %----------- CALCULO -------------
     if op_meto == 1
        bas1 = [{'Iteracion' 'U' 'P'};{(0:length(Ef))' string(round(U1g,4)') string(round(P1g,4)')}]
        t1 = Table(bas1);
        set(t1,'BackgroundColor',col_t,'Border','solid',...
              'ColSep','solid','RowSep','solid','Width','100%',...
              'TableEntriesHAlign','center'); % ,'Halign','center'
        add(rpt,t1);
     else %----------- CALCULO -------------
         bas1 = [{'Iteracion' 'U' 'P'};{(0:length(Ef))' string(round(U1g,4)') string(round(P1g,4)')}];
         if size(U1g,2) <= 100
            t1 = Table(bas1);
             set(t1,'BackgroundColor',col_t,'Border','solid',...
                   'ColSep','solid','RowSep','solid','Width','100%',...
                   'TableEntriesHAlign','center'); % ,'Halign','center'
             add(rpt,t1);
         else
         %% Exportar Matrices a excel
            a = 0; con = 1;     % Variables de contadores
            while a == 0
                if exist(strcat(path,"Anexo_",num2str(con),'.xlsx')) == 0
                    filename_t = strcat(path,"Anexo_",num2str(con),'.xlsx')
                    a = 1;
                else
                    con = con + 1;
                end
            end
            %bas1 = {(0:length(Ef))' string(round(U1g,4)') string(round(P1g,4)')};
            xlswrite(filename_t,{'Iteracion' 'U' 'P'},'NC');  
            xlswrite(filename_t,(0:length(Ef))','NC','A2'); 
            xlswrite(filename_t,[string(round(U1g,4)') string(round(P1g,4)')],'NC','B2'); 
            p1 = Paragraph(strcat('Debido al numero de iteraciones los datos se exportaron a un Archivo Excel "Anexo_',num2str(con),'" en la direccion:'));
            p1.Style = {OuterMargin('12pt','','12pt','12pt')};
            set(p1,'Color','navy','FontSize','10pt','Italic',1);
            add(rpt,p1);
            p1 = Paragraph(filename_t);
            p1.Style = {OuterMargin('12pt','','12pt','12pt')};
            set(p1,'Color','navy','FontSize','10pt','Italic',1,'Bold',1);
            add(rpt,p1);
         end
     end
    
    
    
    
    
    
    
    
    
    
    
    
    
%% Orden de Fluencia
    p1 = Paragraph(strcat('2.2. Orden de Fluencia de Elementos'));
    p1.Style = {OuterMargin('12pt','','12pt','12pt')};
    set(p1,'Color','navy','FontSize','12pt');
    add(rpt,p1);
    %----------- CALCULO -------------
    if op_meto == 1
        c=[]; elem=[]; val = {'Iteración' 'Rótulas'};
        for i=1:length(Ef)
            c=[c i]; elem=[elem Ef{i}];
            if length(Ef{i})==2
                c=[c i];
            end
        end
    else
        Rotulas = mat_res{3};
        c = []; elem = {};  val = {'Desplazamiento' 'Rótulas'};
        for i = 1:size(Rotulas,2)
            c(end+1) = Rotulas{i}(1);
            elem(end+1) = {char(strjoin(string(Rotulas{i}(1,2:end)), {' - '}))};
        end
    end
    %------------------------
    tab = [val; {c' elem'}];     % lista de rotulas que fluyen
    t1 = Table(tab);
    set(t1,'BackgroundColor',col_t,'Border','solid',...
          'ColSep','solid','RowSep','solid','Width','50%',...
          'TableEntriesHAlign','center'); % ,'Halign','center'
    add(rpt,t1);
    end
end
    close(rpt);
    rptview(rpt);
end