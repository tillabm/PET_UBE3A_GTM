function [boundaries,ind]=UBE3A_PVC_FindECHs_c_boundaries_CSF_R_v(c3,suvr,aparc,ind_FS)

%% Thresholds
CSF_threshold = 0.5;    % is probably 0.5 because it is more likely to find it and we want to include it.

%% I possible ECHs

[sz1, sz2, sz3]=size(aparc);%fname_suvr % to show which PET day
raparc=reshape(aparc,sz1*sz2*sz3,1);

% right lateral ventricle (43,44) and right choroid plexus (63)
ind_v = (raparc == 43) |  (raparc == 44) | (raparc == 63);
aparc_v = zeros(sz1,sz2,sz3);
aparc_v(ind_v) = 1;
raparc_v = reshape(aparc_v,sz1*sz2*sz3,1);

rc3=reshape(c3,sz1*sz2*sz3,1);

ind = find(rc3 >= CSF_threshold & raparc_v == 1); % will be output = ind

%remove indices already used for FreeSurfer_ROI
ind(ismember(ind,ind_FS)) = [];

%% Histogram

rsuvr=reshape(suvr,sz1*sz2*sz3,1);      %PET
% define PET_Threshold
max_pet_value = max(rsuvr(ind),[],'all');
PET_Threshold = 0 * max_pet_value;

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
title('CSF R V (PET signal)');
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