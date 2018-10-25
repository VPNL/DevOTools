function dataPoint = findData( data, sheetName, subjID, colTitle )
%findDate Finds the data point of in Development of Perception
%corresponding to the given sheet, subject ID and column title
%   findData(data,sheetName,subjID,colTitle)
%       data: 9 dimensional data structure with fields "raw" and "sheet". "sheet" gives
%             the name (string) of the sheet in Development of Perception from which the
%             raw data (cell) are from. This data structure can be
%             generated using the function loadDevelofPercept
%       subjID: (string) The subject ID we want data on
%       sheetName: (string) Name of the sheet in Development of Perception we're
%                  indexing. For example 'Kids Year 1'.
%       colTitle: (string) Name of the column in the spreadsheet from which I
%             want data. Example "Anatomy"
%   returns the data point for the corresponding subject ID, sheet, and
%       colTitle. If colTitle is not in sheetName, then it will return Nan.
%
%AR Oct 2018

%Check to make sure that data contains the field "raw"
isField(data,'raw')

%Check to make sure that sheetName exists in data
isSheet(data,sheetName)

%Checking to make sure that subjID is in data for this sheetName
if ~isSubj(data,sheetName,subjID)
    dataPoint = NaN;
    return;
end

%Trying to find the index for this column
try
    column = whichCol(data,colTitle,sheetName);
catch
    %If this isn't a valid column, return a NaN data point
    dataPoint = NaN;
    return;
end

%Getting the sheet index in data corresponding to sheetName
sheetIndx = whichSheet(data,sheetName);

%Getting the row index corresponding to subjID
row = whichRow(data,sheetName,subjID);

%Get the appropriate data
dataPoint = data(sheetIndx).raw(row,column);
dataPoint = dataPoint{1};
end