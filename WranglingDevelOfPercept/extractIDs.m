function allsortedIDs = extractIDs( data, sheetName )
%extractIDs Extracts all of the participant IDs from a particular sheet in the
%Development of Perception spreadsheet.
%   extractIDs( data, sheetName )
%       data: 9 dimensional data structure with fields "raw" and "sheet". "sheet" gives
%             the name (string) of the sheet in Development of Perception from which the
%             raw data (cell) are from. This data structure can be
%             generated using the function loadDevelofPercept
%       sheetName: (string) Name of the sheet in Development of Perception we're
%                  indexing. For example 'Kids Year 1'.
%   returns cell array with all of the participant IDs
%
%   AR Oct 2018

%Check to make sure that data contains the fields raw and sheet, and that
%sheetName is in the spreadsheet
isField(data,'raw')
isSheet(data, sheetName)

%Finding the sheetIndx (boolean) corresponding with this sheetName
sheetIndx = whichSheet(data, sheetName);

%Finding which column in the spreadsheet has the subject IDs
column = whichCol(data,'ID',sheetName);

%If any of the cells in this column are not empty (have an ID), concatenate them
%into a cell array.
i = 1;
allIDs = {}; %Instantiating cell array to store all participant IDs
for row = 2:size(data(sheetIndx).raw,1) %Looping across all rows 
                                        %except for the first row, which
                                        %contains the column titles
    %Checking to make sure that cell isn't empty or NaN
    if (~isnan(cell2mat(data(sheetIndx).raw(row,column))) &...
        ~isempty(data(sheetIndx).raw(row,column)))
            %Adding ID to cell array
            allIDs{i} = strtrim(data(sheetIndx).raw(row,column));
            i = i + 1;
    end
end
allIDs = [allIDs{:}];

%Sort IDs alphabetically
allsortedIDs = sortIDs_alphabetically(allIDs);
end