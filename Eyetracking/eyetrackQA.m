function eyetrackQA( fName, edfdir, ascdir, rawdir, processeddir, figdir, ...
                     plotRaw, screenshot, pxlScrnDim, mmScrnDim, scrnDstnce )
% eyetrackQA creates quality assurance files to help determine whether a
% subject was fixating. It mimics Jesse's Eyetrack_final code stored under
% kgs/projects/Longitudinal/Behavioral/Eyetracking/Code
%
%   eyetrackQA( fName, edfdir, ascdir, rawdir, processeddir, figdir,
%               [plotRaw], [screenshot], [pxlScrnDim], [mmScrnDim], 
%               [scnDstnce] )
%       fName: (string) name of edf file (without .edf ending)
%       edfdir: (string) path to edf file
%       ascdir: (string) path to where asc files will be stored
%       rawdir: (string) path to where the raw mat files will be stored
%       processeddir: (string) path to where processed mat files will be
%                              stored
%       figdir: (string) path to where the QA figures will be stored
%       plotRaw: (optional) boolean denoting whether you would like to plot
%                           the raw data in addition to the processed data
%                           (default is false)
%       screenshot - (optional) path to image you want to appear behind the
%                    plot (default is from RecMem experiment)
%       pxlScrnDim - (optional) vector of length 2 containing the x and y
%                    screen dimensions in pixels. Defaults to the screen
%                    dimensions for the Recognition Memory experiment [1024
%                    768].
%       mmScrnDim - (optional) vector of length 2 containing the x and y
%                   screen dimensions in milimeters. Defaults to the screen
%                   dimensions for the Recognition Memory experiment
%                   [385.28 288.96]
%       scnDstnce - (optional) scalar. Distance from eye to screen in
%                   milimeters. Defaults to screen distance for Recognition
%                   Memory experiment (540 mm)
%
% This script is only compatable for Macs
%
% AR Jan 2019
% AR Feb 2019 changed location of edf2asc to GitHub; added screenshot
%             behind plots; added flag to plot raw data; updated default
%             dimensions to match RecMem code

% Because the edf2asc binary script used in this function only runs on Macs
if ~ismac
    error('This function can only be run on a Mac.');
end

%% Setting defaults to RecMem parameters

if ~exist('screenshot')
    screenshot = RAID('projects','GitHub','DevOTools','Eyetracking',...
                      'RecMemFixationAndBar.png');
end

if ~exist('scnDstnce')
    scrnDstnce = 540;
end

if ~exist('mmScrnDim')
    mmScrnDim = [385.28 288.96];
end

if ~exist('pxlScrnDim')
    pxlScrnDim = [1024 768];
end

if ~exist('plotRaw')
    plotRaw = false;
end

%% Convert edf file to asc
edfFile = [edfdir '/' fName '.edf'];
% There is a unix script called edf2asc that will be called. To run it, we
% need to change the directory
cd /Volumes/group/biac2/kgs/projects/GitHub/DevOTools/Eyetracking
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
if plotRaw
    fig = makeQAFig( dvaConvert(raw, pxlScrnDim, mmScrnDim, scrnDstnce),...
                     [fName ' Raw'], screenshot, mmScrnDim, scrnDstnce );
    saveas(fig,[figdir '/' fName '_raw.png']);
end

%% Delete blinks, convert to dva, and save processed data
processed = removeBlinks( raw ); clear raw;
processed = dvaConvert( processed, pxlScrnDim, mmScrnDim, scrnDstnce );
save([processeddir '/' fName '.mat'],'processed')

% Plot processed data and save figure
fig = makeQAFig( processed, [fName ' Processed'], screenshot, mmScrnDim, ...
                 scrnDstnce );
saveas(fig,[figdir '/' fName '_processed.png']);

% Close figure
close;

% Change directory to figdir
cd(figdir)

end
