function behave = makeBehave( sheetData, subjID, sheetName, adults )
%makeBehave creates the behave structure for a particular subject ID
%   behave = makeBehave( sheetData, subjID, sheetName, [adults] )
%       sheetData - 9 dimensional data structure with fields "raw" and "sheet". "sheet" gives
%                   the name (string) of the sheet in Development of Perception from which the
%                   raw data (cell) are from. This data structure can be generated using the 
%                   function loadDevelofPercept
%       subjID: (string) The subject ID we want data on
%       sheetName: (string) Name of the sheet in Development of Perception 
%                           we're indexing. For example 'Kids Year 1'.
%       adults: (boolean) optional flag that indicates if you want to organize the adult data
%               or the kid data. A 1 indicates that I want to organize the adult
%               data, while a 0 or no entry indicates that I want to organize the
%               kid data. Default value is 0.
%       behave: a data structure with the following fields and subfields...
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

%% Check inputs and system

% Set default for adults
if nargin < 4 || isempty(adults)
    adults = 0;
end

% Assign corresponding sheet name to get info participant info
if adults
    year1Sheet = 'Adults Year 1';
else
    year1Sheet = 'Kids Year 1';
end

% Check inputs
isField(sheetData,'sheet')
isField(sheetData,'raw')
if ~isSubj(sheetData,sheetName,subjID)
     error([subjID ' is not a subject in ' sheetName])
end

% Check to make sure that DevOTools is in the path
if ~exist('DevOTools')
    error('Please add DevOTools to your path')
end

%% Adding info

% Specifying field names in behave structure
fields = {'name','subj','DOB','hand','race','ethnicity',...
          'ethnicity2','gender'};
% Specifying corresponding column names in the spreadsheet
cols = {'Name','ID','DOB','Hand','Race','Ethnicity 1',...
        'Ethnicity 2','Gender'};

% Storing appropriate data into behave structure
for i = 1:length(fields)
    field = fields{i};
    col = cols{i};
    behave.info.(field) = findData(sheetData,year1Sheet,subjID,col);
end

% Convert date of birth to string
serialDOB = x2mdate(behave.info.DOB); % Need to convert dates from excel 
                                      % serial to MATLAB serial
try
    behave.info.DOB = datestr(serialDOB,'mm/dd/yy'); % This function won't 
                                                     % run if no DOB in
                                                     % spreadsheet
catch
    behave.info.DOB = NaN;
end

%% Adding fMRI

% Specifying field names in behave structure
fields = {'loc','loc_retest','RET','Toonotopy'};
subfields = {'pc','session'}; % Will calculate age later

% Specifying corresponding column names in the spreadsheet
scans = {'kidLoc ','kidLoc Retest ','Ret ','Toon '};
colTypes = {'Behave','Session'};

% Storing appropriate data into behave structure
for i = 1:length(fields) % Looping across fields
    field = fields{i};
    scan = scans{i};
    % Adding in percent correct and session
    for j = 1:length(subfields)
        subfield = subfields{j};
        colType = colTypes{j};
        col = [scan,colType];
        behave.fmri.(field).(subfield) = findData(sheetData,sheetName,subjID,col);
    end
    % Adding in age of participant
    subfield = 'age';
    col = [scan,'Date'];
    behave.fmri.(field).(subfield) = ...
                        yearfrac(serialDOB,...
                        x2mdate(findData(sheetData,sheetName,subjID,col)));
end

%% Adding RecMem

% Specifying field names in behave structure
fields = {'total','adult','child','house','limb','cars','words'};
subfields = {'hits','false_alarms','pc'};

% Specifying corresponding column names in spreadsheet
stimuli = {'Total ','Adult Faces ','Child Faces ','House ','Limb ','Cars ','Words '};
colTypes = {'Hit','False Alarm','Overall Correct'};

% Storing appropriate date into behave structure
for i = 1:length(fields)
    field = fields{i};
    stimulus = stimuli{i};
    % Adding hits, false alarms and overall corrects
    for j = 1:length(subfields)
        subfield = subfields{j};
        colType = colTypes{j};
        col = [stimulus,colType];
        behave.rec_mem.(field).(subfield) = findData(sheetData,sheetName,...
                                                     subjID,col);
    end
end

% Adding age for RecMem
behave.rec_mem.age = ...
    yearfrac(serialDOB,...
    x2mdate(findData(sheetData,sheetName,subjID,'Rec Mem Date')));

%% CFMT

% Specifying field names in behave structure
fields = {'cfmt_boys','cfmt_adults','cfpt'};

% Specifying corresponding column names
testNames = {'CFMT Boys ','CFMT Adult ','CFPT Boys '};

% Storing into behave structure
for i = 1:length(fields)
    field = fields{i};
    test = testNames{i};
    
    % Adding percent correct
    behave.(field).pc = findData(sheetData,sheetName,subjID,[test 'Score']);
    
    % Adding age
    behave.(field).age = yearfrac(serialDOB,...
            x2mdate(findData(sheetData,sheetName,subjID,[test 'Date'])));
end

%% WASI and Benton

% Specifying fields and subfields
fields = {'wasi','benton','wj3'};

% Corresponding column names
tests = {'WASI ','Benton ','WJ3 '};

% Adding to behave
for i = 1:length(fields)
    field = fields{i};
    test = tests{i};
    
    % Need to use try/catch because WASI and Benton are not in all of the
    % sheets since we stopped running those tests
    try
        behave.(field).score = findData(sheetData,sheetName,subjID,[test ...
                                                                   'Score']);
    catch
        behave.(field).score = NaN;
    end
    
    try
        behave.(field).age = ...
            yearfrac(serialDOB,...
                     x2mdate(findData(sheetData,sheetName,subjID,...
                                      [test 'Date'])));
    catch
        behave.(field).age = NaN;
    end
end

% Adding percent correct field to benton and wj3
behave.benton.pc = (behave.benton.score/54)*100;
behave.wj3.pc = (behave.wj3.score/60)*100;

%% Reading

% Calculating age at reading test
readingAge = yearfrac(serialDOB,...
                      x2mdate(findData(sheetData,sheetName,subjID,...
                                       'Reading Date')));
                                   
% Field names
fields = {'towre_real','towre_pseudo','wrmt3_real','wrmt3_pseudo'};

% Test name in Sheet
cols = {'TOWRE Real WPM','TOWRE Psuedo WPM','WRMT3 Real Score',...
        'WRMT3 Pseudo Score'};

% Adding to behave
for i = 1:length(fields)
    field = fields{i};
    col = cols{i};
    behave.(field).score = findData(sheetData,sheetName,subjID,col);
    behave.(field).age = readingAge;
end

% Adding percent correct to WRMT
behave.wrmt3_real.pc = (behave.wrmt3_real.score/46)*100;
behave.wrmt3_pseudo.pc = (behave.wrmt3_pseudo.score/26)*100;

end
