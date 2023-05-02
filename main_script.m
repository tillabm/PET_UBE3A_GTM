function [FS_ROI_not_included,roigroups_2,percinroi,c,equal,stat_3rd,stat_4th,stat_L_v,stat_R_v,stat_CSF_not_v,stat_m]=main_script(files,time_points,subjects,i,j)

fname_suvr = strcat(files(i).folder,'\',files(i).name,'\coreg_',subjects(i,:),'_D',time_points(j,:),'_brain.nii');
% fname_suvr = strcat(erase(files(i).folder,'\PET'),'\PVC\',subjects(i,:),'\day_5\IV_2\ROI_PET_nonpvcval_smoothed5.nii');
fname_aparc = strcat(erase(files(i).folder,'\PET'),'\Freesurfer\outputs\',subjects(i,:),'\raw\aparc+aseg_converted_pmod.nii');
fname_c1 = strcat(erase(files(i).folder,'\PET'),'\Freesurfer\outputs\',subjects(i,:),'\spm_segmentation\c1nu_converted_pmod.nii');
fname_c2 = strcat(erase(files(i).folder,'\PET'),'\Freesurfer\outputs\',subjects(i,:),'\spm_segmentation\c2nu_converted_pmod.nii');
fname_c3 = strcat(erase(files(i).folder,'\PET'),'\Freesurfer\outputs\',subjects(i,:),'\spm_segmentation\c3nu_converted_pmod.nii');
fname_c4 = strcat(erase(files(i).folder,'\PET'),'\Freesurfer\outputs\',subjects(i,:),'\spm_segmentation\c4nu_converted_pmod.nii');
fname_c5 = strcat(erase(files(i).folder,'\PET'),'\Freesurfer\outputs\',subjects(i,:),'\spm_segmentation\c5nu_converted_pmod.nii');
fname_cere = strcat(erase(files(i).folder,'\PET'),'\Freesurfer\outputs\',subjects(i,:),'\suit_segmentation\riw_rCerebellum-SUIT_u_a_c_nu_converted_pmod_seg1.nii');

cd('C:\Users\tillm\Documents\master_arbeit\code\UBE3A_PVC_concentration');

%% check images having all the same dimension and origin
img=UBE3A_PVC_LoadFiles_c(fname_aparc,fname_suvr,fname_c1,fname_c2,fname_c3,fname_c4,fname_c5,fname_cere);

%% define ROIs (FreeSurfer)
aparc=img{1}.data;                                      % FreeSurfer-Segmentation
suvr=img{2}.data;                                       % PET image

% 3D --> 1D
[sz1, sz2, sz3]=size(aparc);
raparc=reshape(aparc,sz1*sz2*sz3,1);
rsuvr=reshape(suvr,sz1*sz2*sz3,1);

[rnewaparc, roigroups]=UBE3A_PVC_AssignFreeSurferROIs_c_new_arranged(raparc,rsuvr);

% 1D --> 3D
newaparc=reshape(rnewaparc,sz1,sz2,sz3);

connect = 6; % 3d-connectivity (also used later for ECH)
threshold = 500; % number of voxels for contiguous ROI

% making sure all ROIs do have contiguous voxels
[newaparc_2,roigroups_2]=UBE3A_PVC_change_ROI_from_FreeSurfer_c(roigroups,newaparc,connect,threshold);

% which FreeSurfer-ROI are not included
[names]=UBE3A_PVC_get_names_ROI_c(roigroups);
[names_2]=UBE3A_PVC_get_names_ROI_c(roigroups_2);
FS_ROI_not_included = setdiff(names,names_2);

% indices used for ROI FreeSurfer
ind_FS = find(newaparc_2 > 0);

resol = [6.4 6.4 6.4];

% SPM images
c3=img{5}.data;         % CSF
c4=img{6}.data;         % bone
c5=img{7}.data;         % soft tissue

%% CSF-3rd_ventricle-ROI
[ECH_3rd,stat_3rd]=UBE3A_PVC_FindECHs_c_CSF_3rd(c3,suvr,aparc,ind_FS);

% save histogram
cd(strcat('C:\Users\tillm\Documents\master_arbeit\UBE3A_images\PVC\',subjects(i,:),'\day_5'));
saveas(1, fullfile(pwd, strcat('CSF 3rd V_day_',time_points(j,:))));
close(1)
cd('C:\Users\tillm\Documents\master_arbeit\code\UBE3A_PVC_concentration');

x = length(roigroups_2);

for k=1:length(ECH_3rd)
    ECH_temp = ECH_3rd{k}.data; % ROI's inside ECH_temp to have seperate integer values
    ind=ECH_temp>0;
    uech=unique(ECH_temp(ind));
    for kk=1:length(uech)
        ind=ECH_temp==uech(kk);
        newaparc_2(ind)=(x+kk);
        roigroups_2{x+kk}.name=['CSF 3rd Ventricle_' num2str(kk)]; 
        roigroups_2{x+kk}.ind=x+kk;
    end
    x = x + length(uech); 
end

% indices used for previous ROIs
ind_FS = find(newaparc_2 > 0);

%% CSF-4th_ventricle-ROI
[ECH_4th,stat_4th]=UBE3A_PVC_FindECHs_c_CSF_4th(c3,suvr,aparc,ind_FS);

% save histogram
cd(strcat('C:\Users\tillm\Documents\master_arbeit\UBE3A_images\PVC\',subjects(i,:),'\day_5'));
saveas(1, fullfile(pwd, strcat('CSF 4th V_day_',time_points(j,:))));
close(1)
cd('C:\Users\tillm\Documents\master_arbeit\code\UBE3A_PVC_concentration');

for k=1:length(ECH_4th)
    ECH_temp = ECH_4th{k}.data; % ROI's inside ECH_temp to have seperate integer values
    ind=ECH_temp>0;
    uech=unique(ECH_temp(ind));
    for kk=1:length(uech)
        ind=ECH_temp==uech(kk);
        newaparc_2(ind)=(x+kk);
        roigroups_2{x+kk}.name=['CSF 4th Ventricle_' num2str(kk)]; 
        roigroups_2{x+kk}.ind=x+kk;
    end
    x = x + length(uech); 
end

% indices used for previous ROIs
ind_FS = find(newaparc_2 > 0);

%% CSF-L_ventricle-ROI
[ECH_L_v,stat_L_v]=UBE3A_PVC_FindECHs_c_CSF_L_v(c3,suvr,aparc,ind_FS);

% save histogram
cd(strcat('C:\Users\tillm\Documents\master_arbeit\UBE3A_images\PVC\',subjects(i,:),'\day_5'));
saveas(1, fullfile(pwd, strcat('CSF L V_day_',time_points(j,:))));
close(1)
cd('C:\Users\tillm\Documents\master_arbeit\code\UBE3A_PVC_concentration');

for k=1:length(ECH_L_v)
    ECH_temp = ECH_L_v{k}.data; % ROI's inside ECH_temp to have seperate integer values
    ind=ECH_temp>0;
    uech=unique(ECH_temp(ind));
    for kk=1:length(uech)
        ind=ECH_temp==uech(kk);
        newaparc_2(ind)=(x+kk);
        roigroups_2{x+kk}.name=['CSF L lateral Ventricle_' num2str(kk)]; 
        roigroups_2{x+kk}.ind=x+kk;
    end
    x = x + length(uech); 
end

% indices used for previous ROIs
ind_FS = find(newaparc_2 > 0);

%% CSF-R_ventricle-ROI
[ECH_R_v,stat_R_v]=UBE3A_PVC_FindECHs_c_CSF_R_v(c3,suvr,aparc,ind_FS);

% save histogram
cd(strcat('C:\Users\tillm\Documents\master_arbeit\UBE3A_images\PVC\',subjects(i,:),'\day_5'));
saveas(1, fullfile(pwd, strcat('CSF R V_day_',time_points(j,:))));
close(1)
cd('C:\Users\tillm\Documents\master_arbeit\code\UBE3A_PVC_concentration');

for k=1:length(ECH_R_v)
    ECH_temp = ECH_R_v{k}.data; % ROI's inside ECH_temp to have seperate integer values
    ind=ECH_temp>0;
    uech=unique(ECH_temp(ind));
    for kk=1:length(uech)
        ind=ECH_temp==uech(kk);
        newaparc_2(ind)=(x+kk);
        roigroups_2{x+kk}.name=['CSF R lateral Ventricle_' num2str(kk)]; 
        roigroups_2{x+kk}.ind=x+kk;
    end
    x = x + length(uech); 
end

% indices used for previous ROIs
ind_FS = find(newaparc_2 > 0);

%% CSF-subarachnoid_space-ROI
[ECH_not_v,stat_CSF_not_v]=UBE3A_PVC_FindECHs_c_CSF_not_v(c3,suvr,aparc,resol,ind_FS);

% save histogram
cd(strcat('C:\Users\tillm\Documents\master_arbeit\UBE3A_images\PVC\',subjects(i,:),'\day_5'));
saveas(1, fullfile(pwd, strcat('CSF not V_day_',time_points(j,:))));
close(1)
cd('C:\Users\tillm\Documents\master_arbeit\code\UBE3A_PVC_concentration');

for k=1:length(ECH_not_v)
    ECH_temp = ECH_not_v{k}.data; % ROI's inside ECH_temp to have seperate integer values
    ind=ECH_temp>0;
    uech=unique(ECH_temp(ind));
    for kk=1:length(uech)
        ind=ECH_temp==uech(kk);
        newaparc_2(ind)=(x+kk);
        roigroups_2{x+kk}.name=['CSF not Ventricle_' num2str(kk)]; 
        roigroups_2{x+kk}.ind=x+kk;
    end
    x = x + length(uech); 
end

% indices used for previous ROIs
ind_FS = find(newaparc_2 > 0);

%% Meninges-ROI
[ECH_m,stat_m]=UBE3A_PVC_FindECHs_c_meninges(c3,c4,c5,suvr,aparc,resol,ind_FS);

% save histogram
cd(strcat('C:\Users\tillm\Documents\master_arbeit\UBE3A_images\PVC\',subjects(i,:),'\day_5'));
saveas(1, fullfile(pwd, strcat('histogram_meninges_day_',time_points(j,:))));
close(1)
cd('C:\Users\tillm\Documents\master_arbeit\code\UBE3A_PVC_concentration');

for l=1:length(ECH_m)
    ECH_temp = ECH_m{l}.data; % ROI's inside ECH_temp to have seperate integer values
    ind=ECH_temp>0;
    uech=unique(ECH_temp(ind));
    for kk=1:length(uech)
        ind=ECH_temp==uech(kk);
        newaparc_2(ind)=(x+kk);
        roigroups_2{x+kk}.name=['meninges_' num2str(kk)]; 
        roigroups_2{x+kk}.ind=x+kk;
    end
    x = x + length(uech); 
end

%% get ready for solving LGS

Vaparc=img{1}.V;
Vaparc.fname=[strcat('C:\Users\tillm\Documents\master_arbeit\UBE3A_images\PVC\',subjects(i,:),'\day_5') strcat('\newaparc_2_day',time_points(j,:),'.nii')];
spm_write_vol(Vaparc,newaparc_2); % writes Vaparc as newaparc (having other and less integer values corresponding to ROI)

apet = fname_suvr;                  % PET
% apet = Vsuvr.fname;                  % artifical PET
aaparc = Vaparc.fname;               % new aparc-file with new integer values

[roigroups_2,percinroi,c,equal]=UBE3A_PVC_ApplyRousset_c_3(apet,aaparc,roigroups_2,resol);


%% making artificial PET image (nonpvcval and pvcval)

% Artifical PET nonpvcval
[ROI_PET_before_PVC,ROI_PET_before_PVC_smoothed]=UBE3A_PVC_artificial_c(newaparc_2,roigroups_2,suvr,'nonpvcval',resol);
[ROI_PET_after_PVC,ROI_PET_after_PVC_smoothed]=UBE3A_PVC_artificial_c(newaparc_2,roigroups_2,suvr,'pvcval',resol);

Vsuvr=img{2}.V;
Vsuvr.fname=[strcat('C:\Users\tillm\Documents\master_arbeit\UBE3A_images\PVC\',subjects(i,:),'\day_5') strcat('\ROI_PET_nonpvcval',time_points(j,:),'.nii')];
spm_write_vol(Vsuvr,ROI_PET_before_PVC);

Vsuvr=img{2}.V;
Vsuvr.fname=[strcat('C:\Users\tillm\Documents\master_arbeit\UBE3A_images\PVC\',subjects(i,:),'\day_5') strcat('\ROI_PET_nonpvcval_smoothed',time_points(j,:),'.nii')];
spm_write_vol(Vsuvr,ROI_PET_before_PVC_smoothed);

Vsuvr=img{2}.V;
Vsuvr.fname=[strcat('C:\Users\tillm\Documents\master_arbeit\UBE3A_images\PVC\',subjects(i,:),'\day_5') strcat('\ROI_PET_pvcval',time_points(j,:),'.nii')];
spm_write_vol(Vsuvr,ROI_PET_after_PVC);

Vsuvr=img{2}.V;
Vsuvr.fname=[strcat('C:\Users\tillm\Documents\master_arbeit\UBE3A_images\PVC\',subjects(i,:),'\day_5') strcat('\ROI_PET_pvcval_smoothed',time_points(j,:),'.nii')];
spm_write_vol(Vsuvr,ROI_PET_after_PVC_smoothed);


% % Artifical PET pvcval
% [artificial_2]=UBE3A_PVC_artificial_c(newaparc_2,roigroups_2,suvr,'pvcval',resol);
% Vsuvr=img{2}.V;
% Vsuvr.fname=[strcat('C:\Users\tillm\Documents\master_arbeit\UBE3A_images\PVC\',subjects(i,:),'\day_5') strcat('\artificial_pvcval',time_points(j,:),'.nii')];
% spm_write_vol(Vsuvr,artificial_2); % writes Vaparc as newaparc (having other and less integer values corresponding to ROI)
% 
% residual_1 = suvr - artificial_1;
% residual_2 = suvr - artificial_2;
% 
% numrois = size(roigroups_2,2);
% for i=1:numrois
%     index = newaparc_2 == i;
%     std_dev_res_1(i,1) = std(residual_1(index));
%     coef_var_res_1(i,1) = std_dev_res_1(i,1)/mean(suvr(index));
%     mean_res_1(i,1) = mean(residual_1(index));
% 
%     std_dev_res_2(i,1) = std(residual_2(index));
%     coef_var_res_2(i,1) = std_dev_res_2(i,1)/mean(suvr(index));
%     mean_res_2(i,1) = mean(residual_2(index));
% end
% 
% for i=1:numrois
%     roigroups_2{i}.std_dev_res_1=std_dev_res_1(i,1);
%     roigroups_2{i}.coef_var_res_1=coef_var_res_1(i,1);
%     roigroups_2{i}.mean_res_1=mean_res_1(i,1);
% 
%     roigroups_2{i}.std_dev_res_2=std_dev_res_2(i,1);
%     roigroups_2{i}.coef_var_res_2=coef_var_res_2(i,1);
%     roigroups_2{i}.mean_res_2=mean_res_2(i,1);
% end
