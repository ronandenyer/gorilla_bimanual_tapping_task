%{
Author: Ronan Denyer

Code to generate spreadsheet to drive Gorilla task "Bimnanual tapping task -
quick version".
%}

cd spreadsheets\quick_study

% variables
bpm = [80, 100, 120, 140, 160, 180, 200, 220, 240, 260, 280, 300]; %tempo in bpm for each block
stim_jitter = 30; %jitter for single stimulus condition in ms
intro_display_number = 1; %number of intro rows
trial_number = 32; %number of trials
end_display_number = 1; %
spreadsheet_rows = intro_display_number  + trial_number + end_display_number;
intro_start_row = intro_display_number;
intro_end_row = intro_display_number;
trial_start_row = intro_display_number + 1;
trial_end_row = trial_start_row + trial_number -1;
end_display_start_row = trial_end_row + 1;
end_display_end_row = end_display_start_row + end_display_number -1;

% spatial condition stimuli
stimulus1_inphase_spatial = 'stimuli_inphase_lateral.png';
stimulus2_inphase_spatial = 'stimuli_inphase_medial.png';

stimulus1_antiphase_spatial = 'stimuli_antiphase_right.png';
stimulus2_antiphase_spatial = 'stimuli_antiphase_left.png';

% double symbolic condition stimuli
stimulus1_inphase_symbolic = 'stimuli_symbolic_inphase_lateral.png';
stimulus2_inphase_symbolic = 'stimuli_symbolic_inphase_medial.png';

stimulus1_antiphase_symbolic = 'stimuli_symbolic_antiphase_right.png';
stimulus2_antiphase_symbolic = 'stimuli_symbolic_antiphase_left.png';

% single symbolic condition stimuli
stimulus_single = 'stimuli_single.png';

% task instructions stimuli
inphase_symbolic_legend = 'stimuli_legend_inphase_symbolic.png';
antiphase_symbolic_legend = 'stimuli_legend_antiphase_symbolic.png';
inphase_single_stim_legend = 'stimuli_legend_inphase_single_stim.png';
antiphase_single_stim_legend = 'stimuli_legend_antiphase_single_stim.png';
spatial_legend = 'stimuli_legend_spatial.png';

% stimulus responses
stimulus1_inphase_left_key = 'z';
stimulus1_inphase_right_key = '.';
stimulus2_inphase_left_key = 'x';
stimulus2_inphase_right_key = ',';

stimulus1_antiphase_left_key = 'x';
stimulus1_antiphase_right_key = '.';
stimulus2_antiphase_left_key = 'z';
stimulus2_antiphase_right_key = ',';

master_spreadsheet = table();

%% Spreadsheet for task demo
% This code section generates the spreadsheet for the practice section
% presented at the beginning of the task
demo_spreadsheet=table();
demo_spreadsheet.display(1:1,1) = {'demo_intro'};
demo_spreadsheet.display(2:7,1) = {'fake_trial'};
demo_spreadsheet.display(8:8,1) = {'demo_practice'};
demo_spreadsheet.display(9:9,1) = {'demo_fixation'};
demo_spreadsheet.display(10:15,1) = {'demo_trial'};
demo_spreadsheet.display(16:16,1) = {'demo_result'};

demo_spreadsheet.ANSWER(2:15) = {'correct'};
demo_spreadsheet.pace(2:15) = 500;
demo_spreadsheet.single_stim_jitter(2:15) = 470;

demo_stimulus1_inphase_spatial = 'task_demo_spatial_inphase_lateral.png';
demo_stimulus2_inphase_spatial = 'task_demo_spatial_inphase_medial.png';

demo_stimulus1_antiphase_spatial = 'task_demo_spatial_antiphase_right.png';
demo_stimulus2_antiphase_spatial = 'task_demo_spatial_antiphase_left.png';

demo_stimulus1_inphase_symbolic = 'task_demo_symbolic_inphase_lateral.png';
demo_stimulus2_inphase_symbolic = 'task_demo_symbolic_inphase_medial.png';

demo_stimulus1_antiphase_symbolic = 'task_demo_symbolic_antiphase_right.png';
demo_stimulus2_antiphase_symbolic = 'task_demo_symbolic_antiphase_left.png';

demo_stimulus1_inphase_single = 'task_demo_single_symbolic_inphase_lateral.png';
demo_stimulus2_inphase_single = 'task_demo_single_symbolic_inphase_medial.png';

demo_stimulus1_antiphase_single = 'task_demo_single_symbolic_antiphase_right.png';
demo_stimulus2_antiphase_single = 'task_demo_single_symbolic_antiphase_left.png';

for j = 2:15
        if mod(j,2) == 0
            demo_spreadsheet.left_correct_inphase(j,1) = {stimulus1_inphase_left_key};
            demo_spreadsheet.left_incorrect_inphase(j,1) = {stimulus2_inphase_left_key};
            demo_spreadsheet.right_correct_inphase(j,1) = {stimulus1_inphase_right_key};
            demo_spreadsheet.right_incorrect_inphase(j,1) = {stimulus2_inphase_right_key};
            
            demo_spreadsheet.left_correct_antiphase(j,1) = {stimulus1_antiphase_left_key};
            demo_spreadsheet.left_incorrect_antiphase(j,1) = {stimulus2_antiphase_left_key};
            demo_spreadsheet.right_correct_antiphase(j,1) = {stimulus1_antiphase_right_key};
            demo_spreadsheet.right_incorrect_antiphase(j,1) = {stimulus2_antiphase_right_key};
            
            demo_spreadsheet.inphase_spatial(j, 1) = {demo_stimulus1_inphase_spatial};
            demo_spreadsheet.antiphase_spatial(j, 1) = {demo_stimulus1_antiphase_spatial};
            
            demo_spreadsheet.inphase_symbolic(j, 1) = {demo_stimulus1_inphase_symbolic};
            demo_spreadsheet.antiphase_symbolic(j, 1) = {demo_stimulus1_antiphase_symbolic};
            
            demo_spreadsheet.inphase_single_stim(j, 1) = {demo_stimulus1_inphase_single};
            demo_spreadsheet.antiphase_single_stim(j, 1) = {demo_stimulus1_antiphase_single};
        else
            demo_spreadsheet.left_correct_inphase(j,1) = {stimulus2_inphase_left_key};
            demo_spreadsheet.left_incorrect_inphase(j,1) = {stimulus1_inphase_left_key};
            demo_spreadsheet.right_correct_inphase(j,1) = {stimulus2_inphase_right_key};
            demo_spreadsheet.right_incorrect_inphase(j,1) = {stimulus1_inphase_right_key};
            
            demo_spreadsheet.left_correct_antiphase(j,1) = {stimulus2_antiphase_left_key};
            demo_spreadsheet.left_incorrect_antiphase(j,1) = {stimulus1_antiphase_left_key};
            demo_spreadsheet.right_correct_antiphase(j,1) = {stimulus2_antiphase_right_key};
            demo_spreadsheet.right_incorrect_antiphase(j,1) = {stimulus1_antiphase_right_key};
            
            demo_spreadsheet.inphase_spatial(j, 1) = {demo_stimulus2_inphase_spatial};
            demo_spreadsheet.antiphase_spatial(j, 1) = {demo_stimulus2_antiphase_spatial};
            
            demo_spreadsheet.inphase_symbolic(j, 1) = {demo_stimulus2_inphase_symbolic};
            demo_spreadsheet.antiphase_symbolic(j, 1) = {demo_stimulus2_antiphase_symbolic};
            
            demo_spreadsheet.inphase_single_stim(j, 1) = {demo_stimulus2_inphase_single};
            demo_spreadsheet.antiphase_single_stim(j, 1) = {demo_stimulus2_antiphase_single};
        end
end

demo_spreadsheet.inphase_symbolic(8,1) = {inphase_symbolic_legend};
demo_spreadsheet.antiphase_symbolic(8,1) = {antiphase_symbolic_legend};
demo_spreadsheet.inphase_spatial(8,1) = {spatial_legend};
demo_spreadsheet.antiphase_spatial(8,1) = {spatial_legend};
demo_spreadsheet.inphase_single_stim(8,1) = {inphase_single_stim_legend};
demo_spreadsheet.antiphase_single_stim(8,1) = {antiphase_single_stim_legend};

master_spreadsheet = demo_spreadsheet;

%% Spreadsheet for main portion of task
% This code section gneerates the spreadsheet for the main portion of the
% task. 32 trials are created for each bpm, and vertically concatenated to
% with the practice section to form the master spreadsheet
for i = 1:length(bpm)
    spreadsheet=table();
    spreadsheet.display(intro_start_row : intro_end_row,1) = {'fixation'};
    spreadsheet.display(trial_start_row : trial_end_row,1) = {'trial'};
    spreadsheet.display(end_display_start_row : end_display_end_row,1) = {'break'};
    spreadsheet.ANSWER(1:spreadsheet_rows) = {'correct'};
    pace = round(60/bpm(i)*1000);
    spreadsheet.pace(trial_start_row:spreadsheet_rows-end_display_number) = pace; %transformation from bpm to ms
    spreadsheet.single_stim_jitter(trial_start_row:spreadsheet_rows-end_display_number) = pace - stim_jitter;
    
    spreadsheet.inphase_symbolic(1,1) = {inphase_symbolic_legend};
    spreadsheet.antiphase_symbolic(1,1) = {antiphase_symbolic_legend};
    spreadsheet.inphase_spatial(1,1) = {spatial_legend};
    spreadsheet.antiphase_spatial(1,1) = {spatial_legend};
    spreadsheet.inphase_single_stim(1,1) = {inphase_single_stim_legend};
    spreadsheet.antiphase_single_stim(1,1) = {antiphase_single_stim_legend};
    
    
    for j = trial_start_row:spreadsheet_rows-end_display_number
        if mod(j,2) == 0
            spreadsheet.left_correct_inphase(j,1) = {stimulus1_inphase_left_key};
            spreadsheet.left_incorrect_inphase(j,1) = {stimulus2_inphase_left_key};
            spreadsheet.right_correct_inphase(j,1) = {stimulus1_inphase_right_key};
            spreadsheet.right_incorrect_inphase(j,1) = {stimulus2_inphase_right_key};
            
            spreadsheet.left_correct_antiphase(j,1) = {stimulus1_antiphase_left_key};
            spreadsheet.left_incorrect_antiphase(j,1) = {stimulus2_antiphase_left_key};
            spreadsheet.right_correct_antiphase(j,1) = {stimulus1_antiphase_right_key};
            spreadsheet.right_incorrect_antiphase(j,1) = {stimulus2_antiphase_right_key};
            
            spreadsheet.inphase_spatial(j, 1) = {stimulus1_inphase_spatial};
            spreadsheet.antiphase_spatial(j, 1) = {stimulus1_antiphase_spatial};
            
            spreadsheet.inphase_symbolic(j, 1) = {stimulus1_inphase_symbolic};
            spreadsheet.antiphase_symbolic(j, 1) = {stimulus1_antiphase_symbolic};
            
            spreadsheet.inphase_single_stim(j, 1) = {stimulus_single};
            spreadsheet.antiphase_single_stim(j, 1) = {stimulus_single};
        else
            spreadsheet.left_correct_inphase(j,1) = {stimulus2_inphase_left_key};
            spreadsheet.left_incorrect_inphase(j,1) = {stimulus1_inphase_left_key};
            spreadsheet.right_correct_inphase(j,1) = {stimulus2_inphase_right_key};
            spreadsheet.right_incorrect_inphase(j,1) = {stimulus1_inphase_right_key};
            
            spreadsheet.left_correct_antiphase(j,1) = {stimulus2_antiphase_left_key};
            spreadsheet.left_incorrect_antiphase(j,1) = {stimulus1_antiphase_left_key};
            spreadsheet.right_correct_antiphase(j,1) = {stimulus2_antiphase_right_key};
            spreadsheet.right_incorrect_antiphase(j,1) = {stimulus1_antiphase_right_key};
            
            spreadsheet.inphase_spatial(j, 1) = {stimulus2_inphase_spatial};
            spreadsheet.antiphase_spatial(j, 1) = {stimulus2_antiphase_spatial};
            
            spreadsheet.inphase_symbolic(j, 1) = {stimulus2_inphase_symbolic};
            spreadsheet.antiphase_symbolic(j, 1) = {stimulus2_antiphase_symbolic};
            
            spreadsheet.inphase_single_stim(j, 1) = {stimulus_single};
            spreadsheet.antiphase_single_stim(j, 1) = {stimulus_single};
        end
        
    end
    
    master_spreadsheet = [master_spreadsheet;spreadsheet];
   

end

filename = sprintf('spreadsheet_quick_study_all_12BPM.xlsx');

writetable(master_spreadsheet, filename);

cd ..
cd ..

