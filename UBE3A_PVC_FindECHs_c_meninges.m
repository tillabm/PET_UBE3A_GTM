function [ECH,stat]=UBE3A_PVC_FindECHs_c_meninges(~,c4,c5,suvr,aparc,resol,ind_FS)
% c3(CSF) / c4(bone) / c5(soft tissue) / suvr(pet) 
% aparc(mri freesurfersegmentation) / resol(FWHM)

stat = [];

[sz1, sz2, sz3]=size(aparc);%fname_suvr % to show which PET day  

%% I find boundaries
[boundaries,ind]=UBE3A_PVC_FindECHs_c_boundaries_meninges(c4,c5,suvr,aparc,resol,ind_FS);

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
    
    % for ind_1
    rECHclusters = reshape(ECHclusters,sz1*sz2*sz3,1);

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


%         % take out small ROIs with low signal
%         max_pet_value = max(rsuvr(ind),[],'all');
%         if average < max_pet_value/2 && number < 500
%             ECHclusters(ind_j) = 0;
%         end

        %% HOTSPOT DETECTION AND DIVIDING INTO SHELLS TO ENSURE HOMOG. SIGNAL

        % if HOTSPOT, then divide into 3 shells
%         if variance > 13
%             % min and max of specific ROI with a too high Variance
%             low = min(rsuvr(ind_j));
%             high = max(rsuvr(ind_j));
% 
%             interval = (high - low)/3;
%             
%             % SHELL 1
%             ind_1 = find(rtempmask == 1 & boundaries(i) < rsuvr & rsuvr <= boundaries(i+1) ...
%                          & rsuvr <= (low+interval) & rECHclusters == 30*j);
% 
%             rmask=zeros(sz1*sz2*sz3,1);
%             rmask(ind_1)=ones(length(ind_1),1);
%             mask=reshape(rmask,sz1,sz2,sz3);
% 
%             minClust = 10; %number/20;
%             delta = 1;
%             [ECHclusters_H,loss_1H]=UBE3A_PVC_FindECHs_c_2_findcluster(mask,sz1,sz2,sz3,minClust,delta);
% 
%             % overwrite ECHclusters
%             ind_H = find(ECHclusters_H > 0);
%             ECHclusters(ind_H) = ECHclusters_H(ind_H) + (30*j);
% 
%             average = mean(rsuvr(ind_H));
%             variance = var(rsuvr(ind_H));
%             number = length(rsuvr(ind_H));
%             stat_hotspot{i,1}.ROI(j,1) = average;
%             stat_hotspot{i,2}.ROI(j,1) = variance;
%             stat_hotspot{i,3}.ROI(j,1) = number;
%             stat_hotspot{i,4}.ROI(j,1) = loss_1H;
% 
%             % SHELL 2
%             ind_2 = find(rtempmask == 1 & boundaries(i) < rsuvr & rsuvr <= boundaries(i+1) ...
%              & rsuvr > (low+interval) & rsuvr <= (low+2*interval) & rECHclusters == 30*j);
% 
%             rmask=zeros(sz1*sz2*sz3,1);
%             rmask(ind_2)=ones(length(ind_2),1);
%             mask=reshape(rmask,sz1,sz2,sz3);
% 
%             minClust = 10; %number/20;
%             delta = 1;
%             [ECHclusters_H,loss_2H]=UBE3A_PVC_FindECHs_c_2_findcluster(mask,sz1,sz2,sz3,minClust,delta);
% 
%             % overwrite ECHclusters
%             ind_H = find(ECHclusters_H > 0);
%             ECHclusters(ind_H) = ECHclusters_H(ind_H) + (30*j+10);
% 
%             average = mean(rsuvr(ind_H));
%             variance = var(rsuvr(ind_H));
%             number = length(rsuvr(ind_H));
%             stat_hotspot{i,1}.ROI(j,2) = average;
%             stat_hotspot{i,2}.ROI(j,2) = variance;
%             stat_hotspot{i,3}.ROI(j,2) = number;
%             stat_hotspot{i,4}.ROI(j,2) = loss_2H;
% 
%             % SHELL 3
%             ind_3 = find(rtempmask == 1 & boundaries(i) < rsuvr & rsuvr <= boundaries(i+1) ...
%              & rsuvr > (low+2*interval) & rsuvr <= (low+3*interval) & rECHclusters == 30*j);
% 
%             rmask=zeros(sz1*sz2*sz3,1);
%             rmask(ind_3)=ones(length(ind_3),1);
%             mask=reshape(rmask,sz1,sz2,sz3);
% 
%             minClust = 10; %number/20;
%             delta = 1;
%             [ECHclusters_H,loss_3H]=UBE3A_PVC_FindECHs_c_2_findcluster(mask,sz1,sz2,sz3,minClust,delta);
% 
%             % overwrite ECHclusters
%             ind_H = find(ECHclusters_H > 0);
%             ECHclusters(ind_H) = ECHclusters_H(ind_H) + (30*j+20);
% 
%             average = mean(rsuvr(ind_H));
%             variance = var(rsuvr(ind_H));
%             number = length(rsuvr(ind_H));
%             stat_hotspot{i,1}.ROI(j,3) = average;
%             stat_hotspot{i,2}.ROI(j,3) = variance;
%             stat_hotspot{i,3}.ROI(j,3) = number;
%             stat_hotspot{i,4}.ROI(j,3) = loss_3H;
% 
% 
%             % delete the voxels which are not in one of the three shells
%             if all(ismember(30*j, ECHclusters)) % check if all values in B are in A
%                 idx = ismember(ECHclusters, 30*j); % create a logical index of values to replace
%                 ECHclusters(idx) = 0; % replace those values with 0
%             end
%             
%         end

    end
    
    %% run without correction (30.1.23 - 17:30)
    % Variance Correction if Variance if one ROI per Histogram-Region is
    % too big (e.g. Variance > 2) stellt sich heraus nicht hilfreich weil
    % ROI's mit extremer Varianz werden dadurch nicht korrigiert --> neuer
    % Ansatz HOTSPOT-DETECTION (siehe Zeile 57 ff.)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % if there is a 100 % loss of voxel, therefore no ROI - then we don't
    % need to correct variance because there is no variance- (19.1.23 -
    % 21:58)


%     if loss_1 < 100
% 
%         variance = PET_metric_ROI{i,2}.ROI;
%         variance = max(variance);
%         if variance > 2
%             [thresh, metric] = multithresh(rsuvr(ind_hist),1);
%             ind_u = find(rtempmask == 1 & boundaries(i) < rsuvr & rsuvr <= thresh);
%             ind_a = find(rtempmask == 1 & thresh < rsuvr & rsuvr <= boundaries(i+1));
%             variance_u = var(rsuvr(ind_u));
%             variance_a = var(rsuvr(ind_a));
%     
%             % make sure new two regions in histogram do have contiguous
%             % ROI's (define them!)
%             %% under
%             rmask=zeros(sz1*sz2*sz3,1);
%             rmask(ind_u)=ones(length(ind_u),1);
%             mask=reshape(rmask,sz1,sz2,sz3); % binary mask of possible ECHs
%     
%             % finding contiguous clusters >= 100 voxels
%             delta = 1;
%             minClust = 100;
%             [ECHclusters_u,loss_2]=UBE3A_PVC_FindECHs_c_2_findcluster(mask,sz1,sz2,sz3,minClust,delta);
%     
%             voxel_values_u = unique(ECHclusters_u);
%             ind_u=find(voxel_values_u>0);
%             voxel_values_u=voxel_values_u(ind_u);
%     
%             % change ROI index in ECHclusters_u
%             for k=1:length(voxel_values_u)
%                 index_u = find(ECHclusters_u == k);
%                 ECHclusters_u(index_u) = 100 + k;
%             end
%     
%             %% above
%             rmask=zeros(sz1*sz2*sz3,1);
%             rmask(ind_a)=ones(length(ind_a),1);
%             mask=reshape(rmask,sz1,sz2,sz3); % binary mask of possible ECHs
%     
%             % finding contiguous clusters >= 100 voxels
%             delta = 1;
%             minClust = 100;
%             [ECHclusters_a,loss_3]=UBE3A_PVC_FindECHs_c_2_findcluster(mask,sz1,sz2,sz3,minClust,delta);
%     
%             voxel_values_a = unique(ECHclusters_a);
%             ind_a=find(voxel_values_a>0);
%             voxel_values_a=voxel_values_a(ind_a);
%             
%             % change ROI index in ECHclusters_a
%             for k=1:length(voxel_values_a)
%                 index_a = find(ECHclusters_a == k);
%                 ECHclusters_a(index_a) = 100 + length(ind_u) + k; % linked to row 92
%             end
%     
%             % define new ECHclusters (corrected)
%             ECHclusters = ECHclusters_u + ECHclusters_a;
%     
%             % check again for variance in new ROI
%             voxel_values = [];
%             voxel_values = unique(ECHclusters);
%             ind_i=find(voxel_values>0);
%             voxel_values=voxel_values(ind_i); %delete 0
%         
%             for j=1:length(voxel_values)
%                 ind_j = find(ECHclusters == 100 + j);
%                 average = mean(rsuvr(ind_j));
%                 variance = var(rsuvr(ind_j));
%                 number = length(rsuvr(ind_j));
%                 PET_metric_ROI{i,5}.ROI(j,1) = average;
%                 PET_metric_ROI{i,6}.ROI(j,1) = variance;
%                 PET_metric_ROI{i,7}.ROI(j,1) = number;
%             end
%             PET_metric_ROI{i,8} = [loss_2, loss_3];
%         end
% 
%         ECH{i}.data = ECHclusters;
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     else
%         ECH{i}.data = ECHclusters; % here ECHclusters is empty with zero's (0)
%     end

    ECH{i}.data = ECHclusters;
end