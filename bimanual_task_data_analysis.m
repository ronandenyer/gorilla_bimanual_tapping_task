%{
Author: Ronan Denyer

This script reads RT data recorded from Gorilla.sc task 
"bimanual tapping task - quick version".

The script will iterate over each trial (32) and each block (12), and pull 
out 32 pairs of RT and button press values (one value for each hand, 64 
total values).

This data will be used to calculate the following variables:
    1. Number of correct/incorrect button presses per block
    2. Average RT difference per block
    3. Transition point - trial number at which the first error occured in
    each block

%}

%% Section 1 - Reading raw data into Matlab
% go to directory containing RT data
% file = [insert .xlsx filename here];
RT_data_raw = readtable(file); % read .csv file into matlab

%% Section 2 - Find rows at which each block starts
% Each block may have multiple start points for each block because of a 
% mechanism in task code that prevents wrong presses on first button press.
% This code section will look through rows of data and record actual start 
% and end  of blocks based on correct pattern (2 complete trials after fixation).
% Result will be stored as array variables startBlockRows and endBlockRows.

startBlockPattern1 = ["break", "fixation", "fixation", "trial",  "trial", "trial", "trial"];
startBlockPattern2 = ["demo_result", "fixation", "fixation", "trial",  "trial", "trial", "trial"];

startBlockRows = [];
endBlockRows = [0,0,0,0,0,0,0,0,0,0,0,0];

for i = 1:height(RT_data_raw)-3
    if strcmp(RT_data_raw.display{i,1},startBlockPattern1(1)) || strcmp(RT_data_raw.display{i,1},startBlockPattern2(1))
        checkBlockStart = [];
        for j = i:i+6
            checkBlockStart = [checkBlockStart, convertCharsToStrings(RT_data_raw.display{j,1})];
        end
        if isequal(checkBlockStart, startBlockPattern1) || isequal(checkBlockStart, startBlockPattern2)
            startBlockRows = [startBlockRows, i+3];
        end
    end
end

for i = 2:length(startBlockRows)
    endBlockRows(i-1) = startBlockRows(i)-1;
end

endBlockRows(12) = height(RT_data_raw);

%% Section 3 - pull out RT and button press data from raw data

varNames = ["SID","block", "trial", "left_RT", "right_RT", "RT_diff", "key_press", "responses"];
varTypes = ["string","double", "double", "double","double","double", "string","cell"];
size = [384 length(varNames)];
outcome_variables = table('Size',size,'VariableTypes', varTypes, 'VariableNames', varNames);

correctResponse1 = ["left_correct","right_correct"];
correctResponse2 = ["right_correct", "left_correct"];

correctTrialPattern1 = ["timelimit_screen", "response_keyboard","response_keyboard","timelimit_screen"];
correctTrialPattern2 = ["fixation", "response_keyboard","response_keyboard","timelimit_screen"];

row_count = 1;
trial_count = 1;
bad_block = [];

% loop through 12 blocks
for i = 1:length(startBlockRows)
    % for each block, loop through each row in raw data
    for row = startBlockRows(i):endBlockRows(i)
        % Trial will always end with a timelimit_screen. If we are
        % currently on a timelimit_screen, this if statement will create an
        % anchor point to work with RT data further
        if strcmp(RT_data_raw.ZoneType{row,1},correctTrialPattern1(1))
            % store current trial in outcome_variable table and then add to
            % trial_count for the next iteration
            outcome_variables.trial(row_count) = trial_count;
            trial_count = trial_count + 1;
            % store subject ID in first column of outcome variable table
            outcome_variables.SID(row_count) = participant;
            % create temporary array to check if current trial follows the
            % pattern of a correct trial (one left_correct and one
            % right_correct response)
            checkTrialCorrect = []; 
            % for a correct trial, the first criteria is to have exactly 2 key
            % presses. here a for loop followed by an if statement is used
            % to check if current trial has 2 key presses.
            for k = row-3:row
                checkTrialCorrect = [checkTrialCorrect, convertCharsToStrings(RT_data_raw.ZoneType{k,1})]; % populate array with names of these 3 responses
            end
            
            if isequal(checkTrialCorrect, correctTrialPattern1) || isequal(checkTrialCorrect, correctTrialPattern2)% check if 3 rows match preferred pattern
                % if there are exactly 2 key presses, record the nature of
                % the response (incorrect/correct) in a string array
                % called keyPressArray
                keyPress1 = convertCharsToStrings(RT_data_raw.Response{row-2,1});
                keyPress2 = convertCharsToStrings(RT_data_raw.Response{row-1,1});
                keyPressArray = [keyPress1, keyPress2];
                % the second criteria is for one of the key presses to be
                % "right_correct" and the other key press to be "left_correct"
                if isequal(keyPressArray, correctResponse1)
                    % if the key presses match this criteria, mark trial as
                    % "correct" and record RT data for each hand and the
                    % difference between RTs. The order of responses will
                    % also be recorded in a cell variable, in case we want to 
                    % look at which hand tends to press first, etc.
                    outcome_variables.key_press(row_count) = "correct"; % store key_press as correct
                    outcome_variables.responses{row_count,1} = cellstr(keyPressArray);
                    outcome_variables.left_RT(row_count) = RT_data_raw.ReactionTime(row-2,1);
                    outcome_variables.right_RT(row_count) = RT_data_raw.ReactionTime(row-1,1);% extract RTs and store in table
                    outcome_variables.RT_diff(row_count) = abs(outcome_variables.left_RT(row_count) - outcome_variables.right_RT(row_count));
                elseif isequal(keyPressArray, correctResponse2)
                    outcome_variables.key_press(row_count) = "correct"; % store key_press as correct
                    outcome_variables.responses{row_count,1} = cellstr(keyPressArray);
                    outcome_variables.left_RT(row_count) = RT_data_raw.ReactionTime(row-1,1);
                    outcome_variables.right_RT(row_count) = RT_data_raw.ReactionTime(row-2,1);% extract RTs and store in table
                    outcome_variables.RT_diff(row_count) = abs(outcome_variables.left_RT(row_count) - outcome_variables.right_RT(row_count));

                else
                    % same procedure for incorrect trials, but they will be
                    % marked as "incorrect".
                    outcome_variables.key_press(row_count) = "incorrect"; % store key_press as correct
                    outcome_variables.responses{row_count,1} = cellstr(keyPressArray);
                    outcome_variables.left_RT(row_count) = RT_data_raw.ReactionTime(row-1,1);
                    outcome_variables.right_RT(row_count) = RT_data_raw.ReactionTime(row-2,1);% extract RTs and store in table
                    outcome_variables.RT_diff(row_count) = abs(outcome_variables.left_RT(row_count) - outcome_variables.right_RT(row_count));
                end
            % a system for capturing failed trials where less than or more
            % than 2 key presses are made is needed. The else statement
            % below will capture these scenarios.
            else
                % a for loop will be used to loop backwards from endpoint of
                % current trial to the startpoint of the trial. A trial
                % always ends on timelimit_screen and can start one row
                % after either a fixation or timelimit screen. Therefore we
                % will loop backwards from our anchor until we encounter one of these
                % screens. We will track how many steps back are made to
                % track how many button presses were made in this
                % failed trial.
                numberIncorrectKeyPresses = 0; % reset tracker
                for m = row-1:-1:row-10
                    if strcmp(RT_data_raw.ZoneType{m,1},correctTrialPattern1(1)) || ...
                            strcmp(RT_data_raw.ZoneType{m,1},correctTrialPattern2(1))
                        % once we habe landed on either a fixation or
                        % timelimit_screen, break the for loop.
                        break;
                    % otherwise keep looping back and add one to
                    % numberIncorrectPresses to track how many presses were
                    % made in this failed trial
                    else
                        numberIncorrectKeyPresses = numberIncorrectKeyPresses + 1;
                    end
                end
                % if we had more than zero presses, need to make array to
                % show what kind of presses they were
                if numberIncorrectKeyPresses > 0
                    % make blank array to store keyPresses in
                    incorrectPressArray = [];
                    for n = row-numberIncorrectKeyPresses:row-1
                        % loop to store presses
                        incorrectPressArray = [incorrectPressArray, convertCharsToStrings(RT_data_raw.Response{n,1})];
                    end
                else
                % otherwise, if zero presses were made on trial, record as
                % "no_presses".
                    incorrectPressArray = "no_presses";
                end
                % store this information in same convention as trials with
                % 2 presses. RT data will be stored as NaN since it is not
                % valid when we have anything other than 2 presses.
                outcome_variables.key_press(row_count) = "incorrect_wrong_number_key_presses"; % store key_press as correct
                outcome_variables.responses{row_count,1} = cellstr(incorrectPressArray);
                outcome_variables.left_RT(row_count) = NaN;
                outcome_variables.right_RT(row_count) = NaN;
                outcome_variables.RT_diff(row_count) = NaN;
                
            end
            outcome_variables.block(row_count) = i; % store current block to outcome_variables
            row_count = row_count + 1; %increase row_count for next iteration
        end
                
    end
    trial_count = 1; %reset trial_count for next iteration

end

%% Section 4 - summary data for each block

varTypes = ["string","string","double", "double", "double", "double", "double", "double"];
varNames = ["SID","condition","block","BPM", "RT_diff", "correct_press_count", "incorrect_press_count", "first_wrong_press"];
size = [12 length(varNames)];
outcome_variables_summary = table('Size',size,'VariableTypes', varTypes, 'VariableNames', varNames);

bpm = 80;

for block = 1:height(outcome_variables_summary)
    outcome_variables_summary.condition(block) = condition;
    outcome_variables_summary.block(block) = block;
    outcome_variables_summary.SID(block) = outcome_variables.SID(1);
    trials = table();
    trials.RT_diff = outcome_variables.RT_diff(block*32-31:block*32);
    trials.key_press = outcome_variables.key_press(block*32-31:block*32);
    outcome_variables_summary.RT_diff(block) = mean(trials.RT_diff(trials.key_press == "correct"), 'omitnan');
    correct_press = 0;
    incorrect_press = 0;
    % for loop to establish number of errors, and where the first wrong 
    % press in all blocks occured
    for n = block*32-31:block*32 % loop through each trial in each block
        % check if trial is correct or error
        if strcmp(outcome_variables.key_press(n), "correct");
           correct_press = correct_press + 1;
           % in cases where no errors, save first rong press as 33 as placeholder
           if n - ((block-1)*32) == 32
               outcome_variables_summary.first_wrong_press(block) = 33;
           end
        % in case an error is found, store trial number at which error happened   
        else
            if incorrect_press == 0
                % save first error found in block as first wrong press
                outcome_variables_summary.first_wrong_press(block) = n - ((block-1)*32);
            end
            incorrect_press = incorrect_press + 1;
        end
    end
    
    outcome_variables_summary.correct_press_count(block) = correct_press;
    outcome_variables_summary.incorrect_press_count(block) = incorrect_press;
    outcome_variables_summary.BPM(block) = bpm;
    bpm = bpm + 20;
end

%% Save outcome_variables and summary to a .mat file
pathname = pwd;
SID = outcome_variables_summary.SID(1);
filename=sprintf("C:/Users/Ronan Denyer/Documents/Data/Gorilla/Scripts/RT_data/baltimore_pilot/%s/%s_%s_bimnaual_task_data_analyzed", SID, SID, condition);
save(filename, 'outcome_variables', 'outcome_variables_summary');