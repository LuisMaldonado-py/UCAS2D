function desel()
global nod_sel ele_sel
if isempty(nod_sel) == 0
    for i = 1:size(nod_sel,1)
        delete(nod_sel(i,2));
    end
    nod_sel = [];
end
if isempty(ele_sel) == 0
    for i = 1:size(ele_sel,1)
        delete(ele_sel(i,2));
    end
    ele_sel = [];
end