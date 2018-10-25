function sortedIDs = sortIDs_alphabetically( IDs )
%sortIDs sorts participant IDs alphabetically
%   sortIDs_alphabetically( IDs )
%       IDs - a cell array containing all of the participant IDs you want
%             to sort
%       returns a cell array with the sorted participant IDs
%
%MN Oct 2018

%First sort alphabetically and trim off spaces
sortedIDs = strtrim(sort(IDs));

end