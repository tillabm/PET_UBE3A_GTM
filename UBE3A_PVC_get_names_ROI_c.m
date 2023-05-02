function [names]=UBE3A_PVC_get_names_ROI_c(roigroups)

n = size(roigroups,2);

for k=1:n
    if isempty(roigroups{1,k}) == 1
        names(1,k) = {'cerebral WM'};
    else
        names(1,k) = {roigroups{1,k}.name};
    end
end