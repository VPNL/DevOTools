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
%       colTitle
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

%Checking to make sure that there is a column with the title colTitle and
%finding what index it is.
column = whichCol(data,colTitle,sheetName);

%Getting the sheet index in data corresponding to sheetName
sheetIndx = whichSheet(data,sheetName);

%Getting the row index corresponding to subjID
row = whichRow(data,sheetName,subjID);

%Get the appropriate data
dataPoint = data(sheetIndx).raw(row,column);
dataPoint = dataPoint{1};
%{
dataPoint = cell2mat(dataPoint);

%If dataPoint is anything other than numeric, change it to NaN
if ~isnumeric(dataPoint)
    dataPoint = NaN;
end
%If there were two rows for the subject, then length of dataPoint would be
%greater than 1
if length(dataPoint) > 1
    %If there's more than one datapoint that's not NaN, then I'll throw an
    %error message
    if sum(~isnan(dataPoint)) > 1
        error([subjID{1},' in sheet ',sheetName{1},...
               ' has more than one date listed for ',colTitle])
    elseif sum(~isnan(dataPoint)) == 0 %If none of the data points are not NaN
        dataPoint = NaN;
        return
    else
        dataPoint = dataPoint(~isnan(dataPoint));
    end
end
%}
end

