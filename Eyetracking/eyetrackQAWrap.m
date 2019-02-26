function eyetrackQAWrap( year, plotRaw )
% eyetrackQAWrap will run eyetrackQA on all edffiles in the Rec Mem 
% meridian mapping data directory corresponding to the indicated year and 
% experiment
%
%   eyetrackQAWrap( year, [plotRaw] )
%       year - (double) year in study you want analyzed
%       plotRaw: (optional) boolean denoting whether you would like to plot
%                           the raw data in addition to the processed data
%                           (default is false)
%
% AR Feb 2019

% Checking inputs
if ~exist('plotRaw')
    plotRaw = false;
end

% Setting data file paths
datadir = RAID('projects','Longitudinal','Behavioral','RecognitionMemory',...
               'data',['Year' num2str(year)],'eyetracking','meridianMapping'); 
edfdir = [datadir, '/edffiles'];
ascdir = [datadir, '/ascfiles'];
rawdir = [datadir, '/matfiles/raw'];
processeddir = [datadir, '/matfiles/processed'];
figdir = [datadir, '/figures'];

% Getting list of all edf files in edfdir
edfFiles = dir(edfdir);
edfFiles = edfFiles(~[edfFiles.isdir]); % Exclude directories
edfFiles = {edfFiles.name}; % Transform into cell array

% Loop through all files
for e = 1:length(edfFiles)
    % Get fName, without .edf ending
    edfFile = edfFiles{e};
    fName = edfFile(1:end-4);
    
    % Run eyetrackQA
    eyetrackQA( fName, edfdir, ascdir, rawdir, processeddir, figdir, plotRaw );
end