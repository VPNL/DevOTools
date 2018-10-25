function organizedData = organizeData( data,columns,adults,years )
%organizeData organizes data from the spreadsheet for each participant and 
%year in study
%   organizeData( data,columns,[adults],[years])
%       data: 9 dimensional data structure with fields "raw" and "sheet". "sheet" gives
%             the name (string) of the sheet in Development of Perception from which the
%             raw data (cell) are from. This data structure can be
%             generated using the function loadDevelofPercept
%       columns: (cell array of strings) names of the columns that you
%               want data from
%       adults: (boolean) optional flag that indicates if you want to organize the adult data
%               or the kid data. A 1 indicates that I want to organize the adult
%               data, while a 0 or no entry indicates that I want to organize the
%               kid data. Default value is 0.
%       years: (array) optional, what years in the study you want to extract
%              data from. Default is [1 2 3 4]
%   returns organizedData - Data structure with a field for each subject.
%                           Under each subject, there will be a field for each column in columns.
%                           Under each column will be an array with the same length of years
%                           corresponding to the data points for that subject and column organized
%                           by increasing year (e.g. [year1 year2 ...]).
%
%AR Oct 2018

%Checking to make sure that data contains the fields raw and sheet
isField(data,'raw')
isField(data,'sheet')

%Checking imputs and setting default values
if nargin < 3 || isempty(adults)
    adults = 0;
end
if nargin < 4 || isempty(years)
    if adults
        years = 1:4;
    else
        years = 1:5;
    end
end

%If adults = 1, organize adult data, otherwise organize kid data
if adults
    allIDs = extractIDs(data,'Adults Year 1'); %Storing all adult IDs
    %Finding indices for adult sheets
    allSheetsIndx = find(~cellfun(@isempty,strfind([data.sheet],'Adult')));
    %Need to resort allSheetsIndx because adult sheets are shorted in
    %descending years in Development of Perception
    allSheetsIndx = sort(allSheetsIndx,'descend');
else
    allIDs = extractIDs(data,'Kids Year 1'); %Storing all kid IDs
    %Finding indices for kid sheets
    allSheetsIndx = find(~cellfun(@isempty,strfind([data.sheet],'Kid')));
end
allSheets = [data(allSheetsIndx).sheet]; %Storing all sheets for adults/kids
                                         %for the appropriate years

%Organizing data into structure                                         
for subj = allIDs
    for column = columns
        for year = years
            col = column{1};
            fieldname = col(col ~= '%' & col ~= ' ' & col ~= '-' & ...
                col ~= '(' & col ~= ')' & col ~= '/');
            sheet = allSheets(year);
            %Get data point
            dataPoint = findData(data,sheet,subj,col);
            %Store in structure
            organizedData.(subj{1}).(fieldname)(year) = dataPoint;
        end
    end
end

end