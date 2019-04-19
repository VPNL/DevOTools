function [hV, anatomy] = reinstallClassFile( sesDir )
% reinstallClassFile will reinstall a t1_class file for a mrVista session
% directory
%
%   hV = reinstallClassFile( [sesDir] )
%
%       sesDir (optional): (string) path to mrVista directory (default is 
%                           current directory)
%
%       hV: a hidden gray view object
%
%       anatomy: (string) name of the 3DAnatomy folder
%
% AR April 2019

% Check for session directory
if ~exist('sesDir')
    sesDir = pwd;
elseif ~exist(sesDir)
    error(['Cannot find ' sesDir]);
end

% Find 3D anatomy file
if exist('3Danatomy')
    anatomy = '3Danatomy/';
elseif exist('3DAnatomy')
    anatomy = '3DAnatomy/';
else
    error('Please make a softlink to the appropriate 3Danatomy folder')
end

% Specify class nifti file
clsNftiFile = [anatomy 't1_class.nii.gz'];

% Reinstall segmentation from updated t1_class.nii.gz file
installSegmentation([],[],clsNftiFile,3); % You may be prompted to for the
                                          % Volume Anatomy Path

% Open gray view
hV = initHiddenGray;

% Load anatomy
hV = loadAnat(hV);

% Every time gray coordinates are updated, mrVista saves a folder with the
% deleted coordinates. We don't need this folder, so it gets removed below.
% Get all contents of mrVista directory
list = dir;
list = list([list.isdir]); % Only need folders in list
list = {list.name}; % Organize into a cell array
% Loop through all folders
for d = 1:length(list)
    if length(list{d}) > 12 & strcmp(list{d}(1:12),'deletedGray_')
        rmdir(list{d},'s');
    end
end

end

