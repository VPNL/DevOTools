function subj = isSubj( data, sheetName, subjID )
%isSubj checks to make sure that subj has data in a given sheet of
%Development of Perception
%   isSubj( data, sheetName, subjID ) 
%       data: 9 dimensional data structure with fields "raw" and "sheet". "sheet" gives
%             the name (string) of the sheet in Development of Perception from which the
%             raw data (cell) are from. This data structure can be
%             generated using the function loadDevelofPercept
%       subjID: (string) The subject ID we want data on
%       sheetName: (string) Name of the sheet in Development of Perception we're
%                  indexing. For example 'Kids Year 1'.
%   returns subj, a boolean that indicates whether subjID is a subject in 
%   the spreadsheet (1 if in the sheet, 0 if not)
%
%AR Oct 2018

%Check to make sure that data contains the fields raw and sheet, and that
%sheetName is in the spreadsheet
isField(data,'raw')
isSheet(data, sheetName)

%Get all subject IDs for the sheet
allIDs = strtrim(extractIDs(data,sheetName));

%Check to see if subjID is in allIDs
if any(strcmp(allIDs,subjID))
    subj = 1;
else
    subj = 0;
end

end

