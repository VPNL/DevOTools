function saveBehavFiles( spreadsheet )
%saveBehavFiles takes the Development of Perception Spreadsheet and creates
%behave.mat files capturing all behavioral data for each participant
%
%   saveBehavFiles( spreadsheet )
%       spreadsheet - (string) file path to Development of Perception 
%                              Spreadsheet download
%
%   Creates a new directory under
%   /projects/Longitudinal/Behavioral/BehaveMatFiles that is named after
%   the date this function is run (for example 12-Oct-2018). Within this
%   directory will be two subfolders called "Adults" and "Kids". Under the
%   Adults directory will be separate folders for each year in the study 
%   (e.g. "Year1"). Under each year's folder will be  individual folders 
%   for each adult or kid subject containing their behave.mat file. Folders
%   for each subject will take the name of their participant ID.
%
%   The behave.mat files contain a data structure called behave that takes
%   on the following organization:
%       behave
%           - info
%               - name: (string) participant's first and last name
%               - subj: (string) participant ID (e.g. 'AWMS24')
%               - DOB: (string) participant's date of birth ('MM/DD/YY')
%               - hand: (string) participant's dominant hand (e.g. 'Right')
%               - race: (string) participant's race (e.g. 'White')
%               - ethnicity: (string) is the participant Hispanic or Latino
%                                     (e.g. 'Non-Hispanic or Non-Latino')
%               - ethnicity2: (string) participant's self-identified
%                                      ethnicity
%               - gender: (string) participant's gender marker (e.g. 'M')
%           - fmri
%               - loc
%                   - pc: (double) average percent correct across kidLoc
%                                  runs
%                   - age: (double) age of participant at time of scan
%                   - session: (double) exam number for this scan
%               - loc_retest
%                   - pc: (double) average percent correct across kidLoc
%                                  runs
%                   - age: (double) age of participant at time of scan
%                   - session: (double) exam number for this scan
%               - RET
%                   - pc: (double) average percent correct across RET runs
%                   - age: (double) age of participant at time of scan
%                   - session: (double) exam number for this scan
%               - Toonotopy
%                   - pc: (double) average percent correct across RET runs
%                   - age: (double) age of participant at time of scan
%                   - session: (double) exam number for this scan
%           - rec_mem
%               - total
%                   - hits: (double) total hit rate as a percent
%                   - false_alarms: (double) total false alarm rate as a
%                                            percent
%                   - pc: (double) total percent correct
%               - adult
%                   - hits: (double) hit rate for adult faces as a percent
%                   - false_alarms: (double) false alarm rate for adult
%                                            faces as a percent
%                   - pc: (double) percent correct for adult faces
%               - child
%                   - hits: (double) hit rate for child faces as a percent
%                   - false_alarms: (double) false alarm rate for child
%                                            faces as a percent
%                   - pc: (double) percent correct for child faces
%               - house
%                   - hits: (double) hit rate for houses as a percent
%                   - false_alarms: (double) false alarm rate for houses as
%                                            a percent
%                   - pc: (double) percent correct for houses
%               - limb
%                   - hits: (double) hit rate for limbs as a percent
%                   - false_alarms: (double) false alarm rate for limbs as
%                                            a percent
%                   - pc: (double) percent correct for limbs
%               - cars
%                   - hits: (double) hit rate for cars as a percent
%                   - false_alarms: (double) false alarm rate for cars as
%                                            a percent
%                   - pc: (double) percent correct for cars
%               - words
%                   - hits: (double) hit rate for words as a percent
%                   - false_alarms: (double) false alarm rate for words as
%                                            a percent
%                   - pc: (double) percent correct for words
%               - age: (double) age of participant at time of test
%           - cfmt_boys
%               - pc: (double) percent correct on CFMT Boys
%               - age: (double) age of participant at time of test
%           - cfmt_adults
%               - pc: (double) percent correct on CFMT Adults
%               - age: (double) age of participant at time of test
%           - cfpt
%               - pc: (double) percent correct on CFMT Boys
%               - age: (double) age of participant at time of test
%           - wasi
%               - score: (double) score on WASI
%               - age: (double) age of participant at time of test
%           - towre_real
%               - score: (double) score on TOWRE with real words
%               - age: (double) age of participant at time of test
%           - towre_pseudo
%               - score: (double) score on TOWRE with pseudonyms
%               - age: (double) age of participant at time of test
%           - benton
%               - score: (double) score on Benton
%               - pc: (double) percent correct on Benton
%               - age: (double) age of participant at time of test
%           - wj3
%               - score: (double) score on WJ3
%               - pc: (double) percent correct on WJ3
%               - age: (double) age of participant at time of test
%           - wrmt3_real
%               - score: (double) score on WRMT3 with real words
%               - pc: (double) percent correct on WRMT3 with real words
%               - age: (double) age of participant at time of test
%           - wrmt3_pseudo
%               - score: (double) score on WRMT3 with pseudonyms
%               - pc: (double) percent correct on WRMT3 with pseudonyms
%               - age: (double) age of participant at time of test
%
% AR Oct 2018

%% Input and System Checks

% Check to make sure spreadsheet exists
if exist(spreadsheet) == 0
    error([spreadsheet ' was either typed incorrectly or needs to be '...
           'added to your path'])
end

% Check to make sure DevOTools and VPNLtools are added to the path
if exist('DevOTools') == 0
    error('Please add DevOTools to your path')
end

if exist('VPNLtools') == 0
    error('Please add VPNLtools to your path')
end

% Check to make sure computer is mounted to our server and can access the
% /projects/Longitudinal/Behavioral/BehaveMatFiles directory
if exist(RAID('projects','Longitudinal','Behavioral','BehaveMatFiles')) == 0
   error(['This computer is not mounted to the server'])
end

%% Make a new directory for the behave.mat files

directory = RAID('projects','Longitudinal','Behavioral','BehaveMatFiles',date);

% First check to see if directory already exists for today's date
if exist(directory) ~= 0
    reply = input(['A directory containing behave.mat files was ' ...
                   'created earlier today. Would you like to rewrite ' ...
                   'these files? Y/N : '],'s');
    if strcmp(reply,'N')
        error(['Please rename the directory created earlier today to '...
               'avoid having files overwritten'])
    end
else
    mkdir(directory)
end

%% Load Spreadsheet and Extract All Participant IDs

sheetData = loadDevelofPercept(spreadsheet);
kidIDs = extractIDs(sheetData,'Kids Year 1');
adultIDs = extractIDs(sheetData,'Adults Year 1');

%% Create files for adult subjects

% Specify sheet names
adultSheetNames = {'Adults Year 4','Adults Year 3','Adults Year 2',...
                   'Adults Year 1'};

% Loop across adult subjects
for i = 1:length(adultIDs)
    id = adultIDs{i};
    % Loop across sheets
    for j = 1:length(adultSheetNames)
        sheetName = adultSheetNames{j};
        % Not all subjects are in all sheets
        if isSubj(sheetData,sheetName,id)
            behave = makeBehave(sheetData,id,sheetName,1);
            % Save behave structure
            subjDir = [directory '/Adults/Year' sheetName(end) '/' id];
            if ~exist(subjDir)
                mkdir(subjDir);
            end
            save([subjDir '/behave.mat'],'behave');
        end
    end
end

% Specify kid sheet names
kidSheetNames = {'Kids Year 1','Kids Year 2','Kids Year 3',...
                 'Kids Year 4','Kids Year 5'};

% Loop across kids subjects
for i = 1:length(kidIDs)
    id = kidIDs{i};
    % Loop across sheets
    for j = 1:length(kidSheetNames)
        sheetName = kidSheetNames{j};
        % Not all subjects are in all sheets
        if isSubj(sheetData,sheetName,id)
            % Make behave structure
            behave = makeBehave(sheetData,id,sheetName);
            % Save behave structure
            subjDir = [directory '/Kids/Year' sheetName(end) '/' id];
            if ~exist(subjDir)
                mkdir(subjDir);
            end
            save([subjDir '/behave.mat'],'behave');
        end
    end
end
