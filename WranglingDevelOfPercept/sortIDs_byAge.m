function sortedIDs_byAge = sortIDs_byAge( IDs )
%sortIDs_byAge sorts participant IDs by their age in ascending order
%   sortIDs_byAge( IDs )
%       IDs - cell array containing all of the participant IDs you want
%             to sort
%       returns a cell array with the sorted participant IDs
%
%AR Oct 2018

%First sort alphabetically and trim off spaces
IDs = strtrim(sort(IDs));

%Extracting all of the ages from IDs
ages = nan(length(IDs),1);
i = 1;
for ID = IDs
    IDchar = char(ID);
    ages(i) = str2num(IDchar(end-1:end));
    i = i + 1;
end

%Sort IDs by age
[~,indx] = sort(ages);
sortedIDs_byAge = IDs(indx);
end