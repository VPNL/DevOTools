function raw = asc2rawMat( ascFile )
% asc2rawMat converts asc files to a raw data variable that can be saved as
% a .mat file. This function mirrors Jesse's function asc2mat stored in
% kgs/projects/Longitudinal/Behavioral/Eyetracking/Code/asc2mat
%
%   raw = asc2rawMat( ascFile )
%       ascFile - (string) filepath to asc file
%       raw - 3 dimensional data matrix of doubles. raw(:,1) gives time, 
%             raw(:,2) gives x coodinate, and raw(:,3) gives y coordinate.
%
% AR Jan 2019

% Open asc file
fid = fopen(ascFile);

% Reads data in asc file and organizes it into 155056×5 cell array of
% strings called raw. The asc file stores 5 dimensions of data and each
% dimension is separated out into this cell array.
raw = textscan(fid, '%s %s %s %s %s');

% raw{1} stores time, raw{2} stores x coordinate, and raw{3} stores y
% coordinate. We won't use raw{4} or raw{5}, so they get deleted here.
raw(:,4:5) = [];

% Reorganize raw into a matrix of doubles
raw = horzcat(raw{:});
raw = str2double(raw);

% Set start time to zero
raw(:,1) = raw(:,1) - raw(1,1);

% Close asc file
fclose(fid);

end

