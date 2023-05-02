function [boundaries,ind]=UBE3A_PVC_FindECHs_c_boundaries_CSF_not_v(c3,suvr,aparc,resol,ind_FS)

%% Thresholds
CSF_threshold = 0.5;    % is probably 0.5 because it is more likely to find it and we want to include it.

%% I possible ECHs

[sz1, sz2, sz3]=size(aparc);%fname_suvr % to show which PET day
raparc=reshape(aparc,sz1*sz2*sz3,1);

% not ventricular system

ind_v = ((raparc == 4) |  (raparc == 5) | (raparc == 14) |  (raparc == 15)| (raparc == 43) |  (raparc == 44) | (raparc == 31) | (raparc == 63));
aparc_v = zeros(sz1,sz2,sz3);
aparc_v(ind_v) = 1;
raparc_v = reshape(aparc_v,sz1*sz2*sz3,1);

rc3=reshape(c3,sz1*sz2*sz3,1);

ind = find((rc3 >= CSF_threshold) ~= (raparc_v == 1)); % will be output = ind

%remove indices already used for FreeSurfer_ROI
ind(ismember(ind,ind_FS)) = [];

%% Histogram

rsuvr=reshape(suvr,sz1*sz2*sz3,1);      %PET
% define PET_Threshold
max_pet_value = max(rsuvr(ind),[],'all');
start = 0 * max_pet_value;

rsuvr_temp = rsuvr(ind);
figure(1);
h1 = histogram(rsuvr_temp);
numbins = h1.NumBins;
close(1); % close h1 (histogram)
ind_2 = find(rsuvr_temp >= start); % remove 1% in order to get rid of too small signal
% just for checking
% min(rsuvr_temp(ind_2));
figure(1);
h2 = histogram(rsuvr_temp(ind_2),numbins); % use the number of bins (h1.NumBins) from histogram without threshold (h1)
title('CSF not V (PET signal)');
hold on;


%% divide histogram

% % thresholds
% for i=1:2
%     thresh(i) = i*(start + max_pet_value)/3;
% end

% start
xline(start,LineWidth=1,Color='b',LabelHorizontalAlignment='left',LabelVerticalAlignment='middle',LabelOrientation='horizontal',Label='Start'); % start

% % include thresh into histogram
% for i=1:length(thresh)
%     xl = xline(thresh(i),'-.',{strcat('Threshold_',num2str(i))});
%     xl.LabelVerticalAlignment = 'middle';
%     xl.LabelHorizontalAlignment = 'center';
% end

% end
xline(max_pet_value,LineWidth=1,Color='b',LabelHorizontalAlignment='right',LabelVerticalAlignment='middle',LabelOrientation='horizontal',Label='End'); % end
hold off;


% define boundaries I
boundaries(1) = start;

% for i=1:length(thresh)
%     boundaries(i+1) = thresh(i);
% end

n = length(boundaries);
boundaries(n+1) = max_pet_value;