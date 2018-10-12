function isSheet( data, sheetName )
%isSheet checks to see if the Development of Perception spreadsheet
%contains a sheet of a given name
%   isSheet( data, sheetName ) 
%       data: 9 dimensional data structure with fields "raw" and "sheet". "sheet" gives
%             the name (string) of the sheet in Development of Perception from which the
%             raw data (cell) are from. This data structure can be
%             generated using the function loadDevelofPercept
%       sheetName: (string) Name of the sheet to check for in Development 
%                           of Perception. For example 'Kids Year 1'.
%   throws an error message if sheetName is not in the spreadsheet
%
%AR Oct 2018

%Check to make sure that data contains the field sheet
isField(data,'sheet')

%Getting all sheet names
actualSheets = [data.sheet];

%Checking to see if sheetName is in actualSheets
if any(strcmp(actualSheets,sheetName))
    return
end
%If function hasn't returned yet, then sheetName is not in data
error([sheetName ' is not a sheet in Development of Perception'])
end

