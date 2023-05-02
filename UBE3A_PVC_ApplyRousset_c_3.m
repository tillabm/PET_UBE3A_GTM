function [roigroups,percinroi,c,equal]=UBE3A_PVC_ApplyRousset_c_3(apet,aaparc,roigroups,scannersmooth)

% Applies Rousset method of partial volume correction to PET data.  This
% particular script relies on ROIs solely derived from the Freesurfer
% segmentation.  If you want to add ROIs that aren't part of the freesurfer
% segmentation or use a bunch of ROI masks, this won't work.  See Suzanne.
%
% apet : full filename path to pet data.  can be multiple frames of PET data 
%           that are coregistered to the nu.nii that belongs to the aparc+aseg.nii
%
% aaparc : full filename path to aparc+aseg.nii from Freesurfer segmentation.
%
% roigroups : variable that lists the ROIs used in the analysis 
%
% scannersmooth : variable representing x, y and z resolutions of the
%           scanner.0
%
% Citation: Rousset OG, Ma Y, Evans AC. Correction for partial volume
%               effects in PET: principle and validation. J Nucle Med. 
%               1998; 39:904-11.

% load('C:\Users\tillm\Documents\master_arbeit\UBE3A_images\PVC\S01\day_5\input_roussel.mat');
% 
% roigroups = roigroups_2;
% scannersmooth = resol;

[fa, ~, ~]=fileparts(apet(1,:));
if isempty(fa)
    fa=pwd;
end

Vpet=spm_vol(apet);
pet=spm_read_vols(Vpet);                                    % read PET image

Vaparc=spm_vol(aaparc);
aparc=spm_read_vols(Vaparc);				                % read MRI-segmentation from FreeSurfer

[sz1, sz2, sz3]=size(pet);				                    % PET image has 4 dimensions because there are 3 time points (sz4) of pet images
[ssz1, ssz2, ssz3]=size(aparc);
numrois=size(roigroups,2);				                    % number of columns in roigroups
voxsmooth(1)=scannersmooth(1)./abs(Vpet.mat(1,1));	        % x
voxsmooth(2)=scannersmooth(2)./abs(Vpet.mat(2,2));	        % y
voxsmooth(3)=scannersmooth(3)./abs(Vpet.mat(3,3));	        % z

if sz1==ssz1 && ssz2==sz2 && sz3==ssz3			            % PET and MRI-segmentation have to be same size!
    rpet=reshape(pet,sz1*sz2*sz3,1);			            % making column-vector (PET)
    raparc=reshape(aparc,sz1*sz2*sz3,1);		            % making column-vector (MRI-segmentation from FreeSurfer)
    disp('smoothing')

    % Preallocate memory for ry and rys
%     ry = spalloc(sz1*sz2*sz3, numrois, nnz(raparc));
%     rys = spalloc(sz1*sz2*sz3, numrois, nnz(raparc));
%     sigma = voxsmooth/(2*sqrt(2*log(2)));   % isotropic Gaussian-Filter

    % time consuming (spm_smooth function)
    for i =1:numrois                                     
        ind=ismember(raparc, roigroups{i}.ind);
        rroi=zeros(sz1*sz2*sz3,1);
        rroi(ind)=1;
        roi=reshape(rroi,sz1,sz2,sz3);
        
        % works slower but is from the original code (reproducibility)
        smoothroi=zeros(sz1,sz2,sz3);
        spm_smooth(roi,smoothroi,voxsmooth);

%         % works faster but has small differences in results to spm_smooth
%         smoothroi = imgaussfilt3(roi,sigma);


        % working with sparse matrix to reduce memory storage (28.2.23)
        ry(:,i) = sparse(reshape(roi,sz1*sz2*sz3,1));
        rys(:,i) = sparse(reshape(smoothroi,sz1*sz2*sz3,1));
    end
	           
    chdir(fa)

    disp('Calculating')

    % for pre-allocation (reduce computational cost)
    percinroi = zeros(numrois);
    GTM = zeros(numrois);
    meanroi = zeros(numrois,1);
    sdroi = zeros(numrois,1);
    numberroi = zeros(numrois,1);

    for i=1:numrois                                     % i = column = ROI
        index = ry(:,i) > 0;                            % i = column = ROI

        % original (don't understand why is working)
        for j=1:numrois			                
            percinroi(i,j)=mean(rys(index,j));		    % GTM (geometric transfer matrix) (mean is taken because we take average/mean of RSF of one segment).
        end                                             % i = row = ROI / j = column = other ROI influencing ROI (i)

        % approach II (implement equation 7 from Rousset et al.)
        % i und j sind vertauscht bezüglich equation 7!
        for j=1:numrois
            overlap = rys(index,j);
            int_overlap = sum(overlap);
            GTM(i,j) = int_overlap/sum(index);
        end

        ind=find(ry(:,i)>0);                        % PET values in ROI (binary; meaning not smoothed!) 
        meanroi(i,1)=mean(rpet(ind));               % measured PET signal in each ROI (mean is taken because we assume there is homogeneous uptake!)
        sdroi(i,1)=std(rpet(ind));                  % as a check, taking standard deviation for each ROI
        numberroi(i,1)=length(rpet(ind));
    end

    % condition number for matrix inversion
    c = cond(percinroi,2); % compute the 2-norm condition number
    equal = isequal(GTM,percinroi);


%% SOLVE LINEAR EQUATION (EQUATION 8 in Rousset et al. 1998) one for each time point
% left-side matrix divsion (solves system of linear equations Ax=B -> x = inv(A)*B = A\B). percinroi(GTM)*x=meanroi(:,i)

% % create the augmented matrix
% A_aug = [ percinroi meanroi ];
% 
% % perform Gaussian elimination to transform A_aug into row echelon form
% n = size(A_aug, 1); % number of rows
% for k = 1:n-1
%     for i = k+1:n
%         factor = A_aug(i,k) / A_aug(k,k);
%         A_aug(i,k:n+1) = A_aug(i,k:n+1) - factor * A_aug(k,k:n+1);
%     end
% end
% 
% % perform back substitution to solve for the unknowns
% x = zeros(n, 1);
% x(n) = A_aug(n,n+1) / A_aug(n,n);
% for i = n-1:-1:1
%     x(i) = ( A_aug(i,n+1) - A_aug(i,i+1:n) * x(i+1:n) ) / A_aug(i,i);
% end
% 
% pvcroi = x;

pvcroi=percinroi\meanroi;

    for i=1:numrois
        roigroups{i}.nonpvcval=meanroi(i,1);
        roigroups{i}.pvcval=pvcroi(i,1);
        roigroups{i}.percinroi=percinroi(i,:);
        roigroups{i}.sd=sdroi(i,1);
        roigroups{i}.numbervoxels=numberroi(i,1);
    end
    chdir(fa);
else
    disp('aparc+aseg and pet are not the same size... cannot run PVC')
end