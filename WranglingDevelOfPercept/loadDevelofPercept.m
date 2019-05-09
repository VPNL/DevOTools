function data = loadDevelofPercept( filename, sheetNames, xlRange )
%loadDevelofPercept Loads data from a download of the Development of Perception
%Spreadsheet and organizes it into a data structure
%   data = loadDevelofPercept( filename, [sheetNames], [xlRange] )
%       filename - (string) file name of Development of Perception Spreadsheet
%                           download
%       sheetNames - (cell array of strings) names of the sheets in the
%                    Development of Perception Spreadsheet. Default is 
%                    'Adults Year 4','Adults Year 3','Adults Year 2',
%                    'Adults Year 1','Kids Year 1','Kids Year 2','Kids Year
%                    3','Kids Year 4','Kids Year 5'
%       xlRange - (string) the cells in the sheets you want to extract
%                 data from. Default is A2:CJ50
%       returns data - 9 dimensional data structure with fields "raw" and 
%                      "sheet". "sheet" gives the name (string) of the 
%                       sheet in Development of Perception from which the
%                       raw data (cell) are from. This data structure can be
%                       generated using the function loadDevelofPercept
%
%AR Oct 2018
%AR May 2019 Fixed bug so that data matches sheetNames

%Argument checks
if nargin < 3
    xlRange = 'A2:CJ50';
end
if nargin < 2
    sheetNames = {'Adults Year 4','Adults Year 3','Adults Year 2',...
              'Adults Year 1','Kids Year 1','Kids Year 2','Kids Year 3',...
              'Kids Year 4','Kids Year 5'};
end

%Store all sheet names
allSheets = {'Adults Year 4','Adults Year 3','Adults Year 2',...
             'Adults Year 1','Kids Year 1','Kids Year 2','Kids Year 3',...
             'Kids Year 4','Kids Year 5'};

% Find the sheet indices in the file for the sheet names inputed
iSheets = [];
for i = 1:length(sheetNames)
	iSheets = [iSheets find(contains(allSheets,sheetNames{i}))];
end

j = 1;
for s = iSheets %Looping across all of the sheets in Development of Perception
    [~,~,data(j).raw] = xlsread(filename,s,xlRange); %Importing Raw Data
    data(j).sheet = allSheets(s); %Labeling sheet
    j = j + 1;
end

end