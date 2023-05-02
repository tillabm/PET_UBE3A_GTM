function [artificial,artificial_smooth]=UBE3A_PVC_artificial_c(newaparc_2,roigroups_2,suvr,variable,resol)

[sz1, sz2, sz3]=size(suvr);
artificial = zeros(sz1,sz2,sz3);

numrois = size(roigroups_2,2);


for i=1:numrois
    index = newaparc_2 == i;
    artificial(index) = roigroups_2{1,i}.(variable);
end

% for i=1:numrois
%     if i <= 57 && mod(i, 2) == 1
%         index = newaparc_2 == i;
%         artificial(index) = 0.25*roigroups_2{1,i}.(variable);
%     else
%         index = newaparc_2 == i;
%         artificial(index) = roigroups_2{1,i}.(variable);
%     end
% end

artificial_smooth=zeros(sz1,sz2,sz3);
spm_smooth(artificial,artificial_smooth,resol);