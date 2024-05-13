function [xf,yf,ang_sel]=d90(cx1,cx2,cy1,cy2)
if abs(cx1-cx2) > abs(cy1-cy2)                  % Define line horizontal o vertical
	yf=cy1                                      % Linea Horizontal
    xf=cx2
    if cx2>cx1
        ang_sel=0
    else
        ang_sel=180
    end
    
else
    xf=cx1                                      % Linea Vertical
    yf=cy2
    if cy2>cy1
        ang_sel=90
    else
        ang_sel=270
    end
end