function sheetIndx = whichSheet( data, sheetName )
%whichSheet returns the boolean index in data indicating which sheet
%corresponds with the given sheet name
%   whichSheet( data, sheetName )
%       data: 9 dimensional data structure with fields "raw" and "sheet". "sheet" gives
%             the name (string) of the sheet in Development of Perception from which the
%             raw data (cell) are from. This data structure can be
%             generated using the function loadDevelofPercept
%       sheetName: (string) Name of the sheet in Development of Perception we're
%                  indexing. For example 'Kids Year 1'.
%       returns sheetIndx: (logical array) boolean index in data 
%                          corresponding to sheetName
%
%AR Oct 2018

%Checking data and sheetName
isSheet(data, sheetName)

%Get sheetNames
sheetNames = [data.sheet];

%Finding the sheetIndx (boolean) corresponding with this sheetName
sheetIndx = strcmp(sheetNames,sheetName);

end

