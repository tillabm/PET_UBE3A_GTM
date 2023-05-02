function [img]=UBE3A_PVC_LoadFiles_c(filename_aparc,filename_suvr,filename_c1,filename_c2,filename_c3,filename_c4, filename_c5,filename_cere)

% Load files and check that the matrix sizes are the same.

% load aparc file, save spm mat matrix to check against other files
Vaparc=spm_vol(filename_aparc);
rmat=reshape(Vaparc.mat,4*4,1); % a 4x4 affine transformation matrix mapping from voxel coordinates to "real world" coordinates. (https://people.duke.edu/~njs28/spmdatastructure.htm)
mat(:,1)=round(rmat*1000);
aparc=spm_read_vols(Vaparc);
[sz1 sz2 sz3]=size(aparc);
img{1}.name=['aparc'];
img{1}.V=Vaparc;
img{1}.data=aparc;

% load suvr file
Vsuvr=spm_vol(filename_suvr);
rmat=reshape(Vsuvr.mat,4*4,1);
%rmat=reshape(Vsuvr(1).mat,4*4,1); % a 4x4 affine transformation matrix mapping from voxel coordinates to "real world" coordinates. (https://people.duke.edu/~njs28/spmdatastructure.htm)
mat(:,2)=round(rmat*1000);
suvr=spm_read_vols(Vsuvr);
[s1 s2 s3]=size(suvr); 
if s1~=sz1 | s2~=sz2 | s2~=sz3; disp(['SUVR ERROR: matrix sizes are different']); return; end
img{2}.name=['suvr'];
img{2}.V=Vsuvr;
img{2}.data=suvr;

% load spm12 c1 file
Vc1=spm_vol(filename_c1);
rmat=reshape(Vc1.mat,4*4,1);
mat(:,3)=round(rmat*1000);
c1=spm_read_vols(Vc1);
[s1 s2 s3]=size(c1); 
if s1~=sz1 | s2~=sz2 | s2~=sz3; disp(['C1 ERROR: matrix sizes are different']); return; end
img{3}.name=['c1'];
img{3}.V=Vc1;
img{3}.data=c1;

% load spm12 c2 file
Vc2=spm_vol(filename_c2);
rmat=reshape(Vc2.mat,4*4,1);
mat(:,4)=round(rmat*1000);
c2=spm_read_vols(Vc2);
[s1 s2 s3]=size(c2); 
if s1~=sz1 | s2~=sz2 | s2~=sz3; disp(['C2 ERROR: matrix sizes are different']); return; end
img{4}.name=['c2'];
img{4}.V=Vc2;
img{4}.data=c2;

% load spm12 c3 file
Vc3=spm_vol(filename_c3);
rmat=reshape(Vc3.mat,4*4,1);
mat(:,5)=round(rmat*1000);
c3=spm_read_vols(Vc3);
[s1 s2 s3]=size(c3); 
if s1~=sz1 | s2~=sz2 | s2~=sz3; disp(['C3 ERROR: matrix sizes are different']); return; end
img{5}.name=['c3'];
img{5}.V=Vc3;
img{5}.data=c3;

% load spm12 c4 file
Vc4=spm_vol(filename_c4);
rmat=reshape(Vc4.mat,4*4,1);
mat(:,6)=round(rmat*1000);
c4=spm_read_vols(Vc4);
[s1 s2 s3]=size(c4); 
if s1~=sz1 | s2~=sz2 | s2~=sz3; disp(['C4 ERROR: matrix sizes are different']); return; end
img{6}.name=['c4'];
img{6}.V=Vc4;
img{6}.data=c4;

% load spm12 c5 file
Vc5=spm_vol(filename_c5);
rmat=reshape(Vc5.mat,4*4,1);
mat(:,7)=round(rmat*1000);
c5=spm_read_vols(Vc5);
[s1 s2 s3]=size(c5); 
if s1~=sz1 | s2~=sz2 | s2~=sz3; disp(['C5 ERROR: matrix sizes are different']); return; end
img{7}.name=['c5'];
img{7}.V=Vc5;
img{7}.data=c5;


% load SUIT cerebellar gray template that has been reverse-normalized and
% resliced to the same space as SUVR, aparc+aseg, and nu.nii

% Vcere=spm_vol(filename_cere);
% rmat=reshape(Vcere.mat,4*4,1);
% mat(:,8)=round(rmat*1000);
% cere=spm_read_vols(Vcere);
% [s1 s2 s3]=size(cere); 
% if s1~=sz1 | s2~=sz2 | s2~=sz3; disp(['SUIT cerebellar template ERROR: matrix sizes are different']); return; end
% img{8}.name=['cere'];
% img{8}.V=Vcere;
% img{8}.data=cere;

% check that the V.mat for each file is the same across files to 1000th
% decimal
for i=1:16
    umat=unique(mat(i,:));
    if length(umat)>1       % ERROR when there are different values in the row
        disp(['ERROR: V.mat is different across files, they may not be resliced to each other'])
        return
    end
end
