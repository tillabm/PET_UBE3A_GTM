function [newaparc_2,roigroups_2]=UBE3A_PVC_change_ROI_from_FreeSurfer_c(roigroups,newaparc,connect,threshold)

% define (pre-allocation)
numrois = unique(newaparc);
numrois = numrois(2:end); % remove 0
out = zeros(length(numrois), 1);
newaparc_2 = zeros(size(newaparc));

ii = 1;

for i=1:length(numrois)
    % 3d-connectivity: 6
    info = bwconncomp(newaparc == numrois(i,1),connect);
    out(i) = info.NumObjects;
    if out(i) > 1 % if there are more than 1 subregions
        for j=1:info.NumObjects % look at every subregion
            if length(info.PixelIdxList{j}) > threshold % only keep the subregions with a threshold (number of voxels)
                newaparc_2(info.PixelIdxList{j}) = ii; % assign new
                roigroups_2{1,ii}.name = roigroups{1,numrois(i,1)}.name;
                roigroups_2{1,ii}.ind = ii;
                ii = ii + 1;
            else
                newaparc_2(info.PixelIdxList{j}) = 0;
            end
        end
    else
        if length(info.PixelIdxList{1}) > threshold
            newaparc_2(info.PixelIdxList{1}) = ii;
            roigroups_2{1,ii}.name = roigroups{1,numrois(i,1)}.name;
            roigroups_2{1,ii}.ind = ii;
            ii = ii + 1;
        else
            newaparc_2(info.PixelIdxList{1}) = 0;
        end
    end
    clear info
end