function row = whichRow( data, sheetName, subjID )
%whichRow finds the row index in the spreadsheet that contains data for a
%subject
%   row = whichRow( data, sheetName, subjID )
%       data: 9 dimensional data structure with fields "raw" and "sheet". "sheet" gives
%             the name (string) of the sheet in Development of Perception from which the
%             raw data (cell) are from. This data structure can be
%             generated using the function loadDevelofPercept
%       subjID: (string) The subject ID we want data on
%       sheetName: (string) Name of the sheet in Development of Perception we're
%                  indexing. For example 'Kids Year 1'.
%   throws error if subject is not in the sheet
%   returns the index for the row that contains data for subjID
%
%AR Oct 2018

%Checking to make sure that data contains raw and that sheetName is in the
%spreadsheet and subjID is an actual subject
isField(data,'raw')
isSheet(data,sheetName)
if ~isSubj(data,sheetName,subjID)
    error([subjID ' is not listed as a subject under ' sheetName])
end

%Getting all entries in the column containing subject IDs
%subjCol = whichCol(data,'subj',sheetName); %Column Index
subjCol = whichCol(data,'ID',sheetName); %Column Index
sheetIndx = whichSheet(data,sheetName); %Sheet Index
IDCol = data(sheetIndx).raw(:,subjCol);

%Trimming strings in IDCol
nanIndx = cellfun(@isnan,IDCol,'uni',false); %Finding NaN entries to exclude
strIndx = ~cellfun(@any,nanIndx);
IDCol(strIndx) = strtrim(IDCol(strIndx));

%Finding the index of the row containing the data for subjID
row = find(strcmp(IDCol,subjID));

end

