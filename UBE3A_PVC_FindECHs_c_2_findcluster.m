function [ECHclusters,loss]=UBE3A_PVC_FindECHs_c_2_findcluster(mask,sz1,sz2,sz3,minClust,delta)

% how many voxels do we have at the beginning for searching for contiguous
% cluster
index_0 = find(mask > 0);
n = length(index_0);

% divide the mask created above into contiguous clusters
mask2=UBE3A_PVC_FindClusters_c(mask);
rmask2=reshape(mask2,sz1*sz2*sz3,1);
umask2=unique(rmask2);
ind=umask2>0;
uumask2=umask2(ind); %delete 0
cnt=0;
%% old version
% rnew=zeros(sz1*sz2*sz3,1);
% for i=1:length(uumask2)
%     ind=find(rmask2==uumask2(i)); % find where cluster mask (rmask2) has same value as cluster value (starting with 10)
%     if length(ind)>minClust 
%         cnt=cnt+delta; 
%         rnew(ind)=cnt.*ones(length(ind),1); 
%     end
% end

%% new version (faster)
rnew = zeros(size(rmask2));
for i = 1:length(uumask2)
    ind = (rmask2 == uumask2(i)); % find where cluster mask (rmask2) has same value as cluster value (starting with 10)
    if sum(ind) > minClust 
        cnt = cnt + delta;
        rnew(ind) = cnt;
    end
end

ECHclusters=reshape(rnew,sz1,sz2,sz3);

% how many voxels do we have at the end after searching for contiguous
% cluster
index_1 = find(ECHclusters > 0);
m = length(index_1);

% loss of voxels in procent (%)
loss = (n - m)/n *100;