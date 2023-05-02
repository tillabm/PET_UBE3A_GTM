function [ECH,stat]=UBE3A_PVC_FindECHs_c_CSF_R_v(c3,suvr,aparc,ind_FS)
% c3(CSF) / c4(bone) / c5(soft tissue) / suvr(pet) 
% aparc(mri freesurfersegmentation) / resol(FWHM)

stat = [];

[sz1, sz2, sz3]=size(aparc);%fname_suvr % to show which PET day  

%% I find boundaries
[boundaries,ind]=UBE3A_PVC_FindECHs_c_boundaries_CSF_R_v(c3,suvr,aparc,ind_FS);

% "ind" as output here shall not be already included in the FreeSurfer ROI!

%% II loop over lenght(boundaries)-1

for i=1:(length(boundaries) - 1)

    rsuvr = reshape(suvr,sz1*sz2*sz3,1);
    rtempmask=zeros(sz1*sz2*sz3,1);
    rtempmask(ind)=ones(length(ind),1);

    ind_hist = find(rtempmask == 1 & boundaries(i) < rsuvr & rsuvr <= boundaries(i+1));

    rmask=zeros(sz1*sz2*sz3,1);
    rmask(ind_hist)=ones(length(ind_hist),1);
    mask=reshape(rmask,sz1,sz2,sz3); % binary mask of possible ECHs

    % finding contiguous clusters >= 50 voxels
    minClust=500;
    delta = 30;
    [ECHclusters,loss_1]=UBE3A_PVC_FindECHs_c_2_findcluster(mask,sz1,sz2,sz3,minClust,delta);

    % fill PET_metric_ROI with values for each ROI (several ROI's per
    % region in histogram possible)
    voxel_values = [];
    voxel_values = unique(ECHclusters);
    ind_i=find(voxel_values>0);
    voxel_values=voxel_values(ind_i); %delete 0

    % going throug all ROI's per interval in ROI-histogram
    for j=1:length(voxel_values)
        ind_j = find(ECHclusters == 30*j);

        average = mean(rsuvr(ind_j));
        stand_dev = std(rsuvr(ind_j));
        number = length(rsuvr(ind_j));
        stat{i,1}.ROI(j,1) = average;
        stat{i,2}.ROI(j,1) = stand_dev;
        stat{i,3}.ROI(j,1) = number;
        stat{i,4} = loss_1;

%         % take out small ROIs (probably blood vessels adjacent to scull on the inside)
%         % with low signal
%         max_pet_value = max(rsuvr(ind),[],'all');
%         if average < (max_pet_value/10) && number < 200
%             ECHclusters(ind_j) = 0;
%         end
    end
    ECH{i}.data = ECHclusters;
end