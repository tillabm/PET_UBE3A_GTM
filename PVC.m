clear all; close all; clc;

cd('C:\Users\tillm\Documents\master_arbeit\UBE3A_images\PET');

files = dir('S*');

time_points = char('1', '2', '5');

subjects = char('S01','S02','S03','S04','S05','S06','S07','S08','S09','S10','S11','S12','S14','S15','S16','S17','S18','S19','S20','S21','S22','S23','S24','S25');

% for i=1:24
% 
%     cd(strcat('C:\Users\tillm\Documents\master_arbeit\UBE3A_images\PVC\',subjects(i,:),'\day_5'));
% 
%     % Define the name of the new folder
%     new_folder_name = 'IV_meninges_test';
% 
%     % Create the new folder
%     mkdir(new_folder_name);
% 
%     % Get a list of all the files in the current directory
%     file_list = dir;
% 
%     % Loop through each file in the list and move it to the new folder
%     for i = 1:length(file_list)
%         if ~file_list(i).isdir % only move files (not directories)
%             movefile(file_list(i).name, new_folder_name);
%         end
%     end
% 
% end


%% loop for all subjects

for i=1 % Subject 

        for j=3 % Day 

            addpath('C:\Users\tillm\Documents\master_arbeit\code\UBE3A_PVC_concentration');
            tic
            [FS_ROI_not_included,roigroups_2,percinroi,c,equal,stat_3rd,stat_4th,stat_L_v,stat_R_v,stat_CSF_not_v,stat_m]=main_script(files,time_points,subjects,i,j);
            toc
            n = size(roigroups_2,2);

            for k=1:n
                values(k,1) = roigroups_2{1,k}.nonpvcval;
                values(k,2) = roigroups_2{1,k}.pvcval;
                values(k,3) = roigroups_2{1,k}.sd;
                values(k,4) = roigroups_2{1,k}.numbervoxels;
                names(1,k) = {roigroups_2{1,k}.name};
                GTM(k,:) = roigroups_2{1,k}.percinroi;
            end

            figure(1)
            plot(values(:,1:2),'-o');
            yline(0);
            title(strcat('Subject',subjects(i,:),' Day5'));
            legend('nonpvcval','pvcval');
            % Set the x-labels to the names in the cell array
            ylabel('[kBq/cc]');
            % Set the x-tick locations and labels
            xticks(1:length(names));
            xticklabels(names);
            % Rotate the x-tick labels vertically
            xtickangle(45);
            % Set the font size of the x-tick labels
            set(gca, 'FontSize', 6);
        
            cd(strcat('C:\Users\tillm\Documents\master_arbeit\UBE3A_images\PVC\',subjects(i,:),'\day_5'));

            saveas(1, strcat('plot_day_5 ',subjects(i,:)));
            close(1)

            %% saving

            % save FS_ROI_not_included
            save(strcat('FS_ROI_not_included_day_',time_points(j,:)),'FS_ROI_not_included');

            % save values
            save(strcat('values_day_',time_points(j,:)),'values');

            % save names
            save(strcat('names_day_',time_points(j,:)),'names');      

            % save GTM
            save(strcat('GTM_day_',time_points(j,:)),'GTM');

            % save roigroups
            save(strcat('roigroups_day_',time_points(j,:)),'roigroups_2');

            % save percinroi
            save(strcat('percinroi_day_',time_points(j,:)),'percinroi');

            % save c
            save(strcat('c_day_',time_points(j,:)),'c');

            % save equal
            save(strcat('equal_day_',time_points(j,:)),'equal');

            % save stat_CSF
            save(strcat('stat_3rd_day_',time_points(j,:)),'stat_3rd');
            save(strcat('stat_4th_day_',time_points(j,:)),'stat_4th');
            save(strcat('stat_L_v_day_',time_points(j,:)),'stat_L_v');
            save(strcat('stat_R_v_day_',time_points(j,:)),'stat_R_v');
            save(strcat('stat_CSF_not_v_day_',time_points(j,:)),'stat_CSF_not_v');

            % save stat_m
            save(strcat('stat_m_day_',time_points(j,:)),'stat_m');

            clear values names GTM roigroups_2 percinroi c equal stat_3rd stat_4th stat_L_v stat_R_v stat_CSF_not_v stat_m;

        end
end
