function eyetrackQA( fName, edfdir, ascdir, rawdir, processeddir, figdir )
% eyetrackQA creates quality assurance files to help determine whether a
% subject was fixating. It mimics Jesse's Eyetrack_final code stored under
% kgs/projects/Longitudinal/Behavioral/Eyetracking/Code
%
%   eyetrackQA( fName, edfdir, ascdir, rawdir, processeddir, figdir )
%       fName: (string) name of edf file (without .edf ending)
%       edfdir: (string) path to edf file
%       ascdir: (string) path to where asc files will be stored
%       rawdir: (string) path to where the raw mat files will be stored
%       processeddir: (string) path to where processed mat files will be
%                              stored
%       figdir: (string) path to where the QA figures will be stored
%
% This script is only compatable for Macs
%
% AR Jan 2019

% Because the edf2asc binary script used in this function only runs on Macs
if ~ismac
    error('This function can only be run on a Mac.');
end

%% Convert edf file to asc
edfFile = [edfdir '/' fName '.edf'];
% There is a unix script called edf2asc that will be called. To run it, we
% need to change the directory
cd /Volumes/group/biac2/kgs/projects/Longitudinal/Behavioral/Eyetracking/Code/
% Storing the unix command
edf2ascCommand = ['./edf2asc -s -miss NaN ' edfFile];
% Running command
unix(edf2ascCommand); % This will save an asc file in the edf directory.
% Move asc file
movefile([edfdir '/' fName '.asc'], ascdir);

%% Convert asc to raw data and save
raw = asc2rawMat([ascdir '/' fName '.asc']);
save([rawdir '/' fName '.mat'],'raw')

% Plot raw data and save figure
fig = makeQAFig( dvaConvert(raw), [fName ' Raw'] );
saveas(fig,[figdir '/' fName '_raw.png']);

%% Delete blinks, convert to dva, and save processed data
processed = removeBlinks( raw ); clear raw;
processed = dvaConvert( processed );
save([processeddir '/' fName '.mat'],'processed')

% Plot processed data and save figure
fig = makeQAFig( processed, [fName ' Processed'] );
saveas(fig,[figdir '/' fName '_processed.png']);

% Close figure
close;

% Change directory to figdir
cd(figdir)

end
