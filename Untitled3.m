% Create axes and save handle
clear
hax = axes;
% Plot three lines
%plot(rand(20,4));
%hold on
%plot(1,1)
hold on
%a(1)=scatter(1,1)
%a(2)=scatter(2,2)
%a(3)=scatter(1.5,1.5)

b(1)=line([1 2],[1 2],'LineWidth',1.5,'Color','b','linestyle','--');  % Linea guia actualizar
b(2)=line([3 4],[3 4],'LineWidth',1.5,'Color','b','linestyle','--');  % Linea guia actualizar
b(3)=line([5 6],[5 6],'LineWidth',1.5,'Color','b','linestyle','--');  % Linea guia actualizar
% Define a context menu; it is not attached to anything
hcmenu = uicontextmenu;
% Define callbacks for context menu 
% items that change linestyle
hcb1 = ['set(gco,''LineStyle'',''--'')'];
hcb2 = ['set(gco,''LineStyle'','':'')'];
hcb3 = ['set(gco,''LineStyle'',''-'')'];
% Define the context menu items and install their callbacks
item1 = uimenu(hcmenu,'Label','dashed','Callback',hcb1);
item2 = uimenu(hcmenu,'Label','dotted','Callback',hcb2);
item3 = uimenu(hcmenu,'Label','solid','Callback',hcb3);
% Locate line objects
%hlines = findall(hax,'Type','line');

% Attach the context menu to each line

for line = 1:length(b)
    set(b(line),'ButtonDownFcn','sele(gco)')
    set(b(line),'DisplayName',num2str(line))
    
end

%function sele()
%UCAS2D 
