function [boundaries,ind]=UBE3A_PVC_FindECHs_c_boundaries_meninges(c4,c5,suvr,aparc,resol,ind_FS)

%% Thresholds
minc45=0.2;             % is propably 0.2 because it is less likely to find it and we want to include it.

%% I possible ECHs

[sz1, sz2, sz3]=size(aparc);%fname_suvr % to show which PET day
raparc=reshape(aparc,sz1*sz2*sz3,1);

% create brainmask as voxels > 0 in aparc+aseg freesurfer segmentation
ind=find(raparc>0);
rbrainmask=zeros(sz1*sz2*sz3,1);
rbrainmask(ind)=ones(length(ind),1);
brainmask=reshape(rbrainmask,sz1,sz2,sz3);

sbrainmask=zeros(sz1,sz2,sz3);
spm_smooth(brainmask,sbrainmask,resol); % =sbrainmask; smoothed freesurfer segmentation

rc4=reshape(c4,sz1*sz2*sz3,1);
rc5=reshape(c5,sz1*sz2*sz3,1);
rsbrainmask=reshape(sbrainmask,sz1*sz2*sz3,1);      % with ventricles (CSF)

ind = find((rc5 >= minc45 | rc4 >= minc45) & rsbrainmask > 0); % will be output = ind

%remove indices already used for FreeSurfer_ROI and CSF_ROI
ind(ismember(ind,ind_FS)) = [];

%% Histogram

rsuvr=reshape(suvr,sz1*sz2*sz3,1);      %PET
% define PET_Threshold
max_pet_value = max(rsuvr(ind),[],'all');
PET_Threshold = 0.05 * max_pet_value;

rsuvr_temp = rsuvr(ind);
figure(1);
h1 = histogram(rsuvr_temp);
numbins = h1.NumBins;
close(1); % close h1 (histogram)
ind_2 = find(rsuvr_temp >= PET_Threshold); % remove 1% in order to get rid of too small signal
% just for checking
min(rsuvr_temp(ind_2));
figure(1);
h2 = histogram(rsuvr_temp(ind_2),numbins); % use the number of bins (h1.NumBins) from histogram without threshold (h1)
title('meninges location (PET signal)');
hold on;


%% divide histogram
% start
xline(PET_Threshold,LineWidth=1,Color='b',LabelHorizontalAlignment='left',LabelVerticalAlignment='middle',LabelOrientation='horizontal',Label='Start'); % start

% end
xline(max_pet_value,LineWidth=1,Color='b',LabelHorizontalAlignment='right',LabelVerticalAlignment='middle',LabelOrientation='horizontal',Label='End'); % end

hold off;

% define boundaries
boundaries(1) = PET_Threshold;
boundaries(2) = max_pet_value;
