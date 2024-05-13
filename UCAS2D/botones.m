function botones(op)
global bmen_2 bmen_3 bmen_4 bmen_5 bmen_6                                        % Varibales barra de menu
global bher_3 bher_4 bher_5 bher_6 bher_7 bher_8 bher_9 
global bher_10 bher_11 bot_point bot_frame       % Varibales barra de herraminetas
menu = [bmen_2 bmen_3 bmen_4 bmen_5 bmen_6];                                      % Vector Barra de Menu
herr = [bher_3 bher_4 bher_5 bher_6 bher_7 bher_8 ...
    bher_9 bher_10 bher_11 bot_point bot_frame];  % Vector Barra de Herramientas
set(menu,'enable','on');        % Bloquea botones de menu 
set(herr,'enable','on');        % Bloquea botones de herramientas
%% Inicio de Programa
if op == 0                      % Inicio del Programa
    set(menu,'enable','off');   % Bloquea botones de menu 
    set(herr,'enable','off');   % Bloquea botones de herramientas
%% Modo Dibujo
elseif op == 1                          % Dibujo 
    set(bmen_6,'enable','off');         % Bloquea botones de menu 
    set(herr([7 8 9]),'enable','off');  % Bloquea botones de herramientas
%% Analisis Lineal
elseif op == 2                          % Lineal
    set(menu([2 3 4]),'enable','off');  % Bloquea botones de menu 
    set(herr([3 10 11]),'enable','off');% Bloquea botones de herramientas
%% Analisis No-Lineal
elseif op == 3                          % No-Lineal
    set(menu([2 3 4]),'enable','off');  % Bloquea botones de menu 
    set(herr([3 7 8 9 10 11]),'enable','off');% Bloquea botones de herramientas
end  