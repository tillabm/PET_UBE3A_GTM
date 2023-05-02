function [mask]=UBE3A_PVC_FindClusters_c(mask)

[sz1, sz2, sz3]=size(mask);
cnt=0;
d=[1 0 0;-1 0 0;0 1 0;0 -1 0; 0 0 1; 0 0 -1]; % neihbouring voxel, only the one touching the "middle" one
for i=1:sz1
    for j=1:sz2
        for k=1:sz3
            if mask(i,j,k)>0.9 && mask(i,j,k)<1.1 % when binary --> if mask(i,j,k)==1
                cnt=cnt+10;
                mask(i,j,k)=cnt;
                spread=0;       % is not used...
                newvox=[i j k]; % voxel coordinate! (not value of voxel)
                while exist('newvox') % after the first loop the neighbouring voxel come here again, the "middle" voxel does not get count again because it's value=10
                    nvcnt=0;
                    for m=1:size(newvox,1)      % just at the first time size(newvox,1)=1
                        for l=1:size(d,1)       % size(d,1)=6
                            if (newvox(m,1)+d(l,1)>0 && newvox(m,1)+d(l,1)<=sz2) && ... % checking voxel is NOT located at boundary
                                    (newvox(m,2)+d(l,2)>0 && newvox(m,2)+d(l,2)<=sz2) && ...
                                    (newvox(m,3)+d(l,3)>0 && newvox(m,3)+d(l,3)<=sz3)
                                if mask(newvox(m,1)+d(l,1),newvox(m,2)+d(l,2),newvox(m,3)+d(l,3))>0.9 ...
                                     && mask(newvox(m,1)+d(l,1),newvox(m,2)+d(l,2),newvox(m,3)+d(l,3))<1.1
                                    nvcnt=nvcnt+1;
                                    newnew(nvcnt,:)=[newvox(m,1)+d(l,1),newvox(m,2)+d(l,2),newvox(m,3)+d(l,3)];
                                    mask(newvox(m,1)+d(l,1),newvox(m,2)+d(l,2),newvox(m,3)+d(l,3))=cnt;
                                end
                            end
                        end
                    end
                    clear newvox
                    if exist('newnew')
                        newvox=newnew; % neighbouring voxel with value = 1
                        clear newnew;
                    end
                end
            end
        end
    end
end

% a cluster does have the same voxel values (first cluster does have value
% 10, second cluster does have value 20)