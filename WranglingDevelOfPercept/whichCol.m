function column = whichCol( data, colTitle, sheetName )
%whichCol checks to make sure that colTitle is an actual name of a column
%in the Development of Perception spreadsheet, and returns the index of
%this column
%   whichCol( data, colTitle, sheetName )
%       data: 9 dimensional data structure with fields "raw" and "sheet". "sheet" gives
%             the name (string) of the sheet in Development of Perception from which the
%             raw data (cell) are from. This data structure can be
%             generated using the function loadDevelofPercept
%       colTitle: (string) Name of the column in the spreadsheet from which I
%             want data. Example "Anatomy"
%       sheetName: (string) Name of the sheet in Development of Perception we're
%                  indexing. For example 'Kids Year 1'.
%   throws error message if colTitle isn't actually in the spreadsheet
%   returns the index of the column for colTitle and sheetName
%
%AR Oct 2018

%Checking to make sure that data contains raw and that sheetName is in the
%spreadsheet
isField(data,'raw')
isSheet(data,sheetName)

%Get all sheetNames in data
sheetNames = [data.sheet];

%Getting all columns in this sheet
columnTitles = [data(strcmp(sheetNames,sheetName)).raw(1,:)];
%Excluding NaNs
nanIndx = cellfun(@isnan,columnTitles,'uni',false);
nanIndx = cellfun(@any,nanIndx);
columnTitles(nanIndx) = [];

%Checking to see if colTitle is in columnTitles
if ~any(strcmp(strtrim(columnTitles),colTitle))
    error([colTitle ' is not a column name in Development of Perception'])
end

%Finding index for colTitle
column = find(strcmp(strtrim(columnTitles),colTitle));
end