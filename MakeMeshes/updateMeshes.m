function updateMeshes( sesDir )
% updateMeshes reinstalls segmentation from nifti class file and makes new
% meshes
%
% In the mrVista directory, make sure that there is a softlink to the
% 3Dantomy, and that the volume anatomy is aligned to the inplane.
%
%   updateMeshes( sesDir )
%       sesDir: (string) path to mrVista directory
%
%       Saves 6 meshes...
%           - lh_wrinkled: wrinkled left hemisphere
%           - rh_wrinkled: wrinkled right hemisphere
%           - lh_inflated_200_1: left hemisphere inflated with 200 smooth
%                                iterations
%           - rh_inflated_200_1: right hemisphere inflated with 200 smooth
%                                iterations
%           - lh_inflated_32_1: left hemisphere inflated with 32 iterations
%           - rh_inflated_32_1: right hemisphere inflated with 32
%                               iterations
%       All 4 inflated meshes have smooth with window sinc set to 0 and
%       smooth relaxation set to 1
%
% AR Nov 2018
% AR Dec 2018 modified mrVista code so that mesh parameters are set 
%             automatically


% Check to make sure mrVista is added to the path
if ~exist('mrVista')
    error('Please add mrVista to your path')
end

% Go to session directory
cd(sesDir)

% Specify class nifti file
clsNftiFile = '3Danatomy/t1_class.nii.gz';

% Check the class file
if ~exist(clsNftiFile)
    error('Please make a softlink to the appropriate 3Danatomy folder')
end

% Reinstall segmentation from updated t1_class.nii.gz file
installSegmentation([],[],clsNftiFile,3); % You may be prompted to for the
                                          % Volume Anatomy Path
                                          
% Open volume view
hV = initHiddenGray;

% Load anatomy
hV = loadAnat(hV);

% Specify hemispheres and smooth iterations
fullH = {'left','right'};
shortH = {'lh','rh'};
smooth = [200 32];

% Loop across hemispheres
for h = 1:length(fullH)
    
   % Naming the wrinkled mesh
   wName = [shortH{h},'_wrinkled'];
    
   %Build wrinkled mesh
   hV = makeWrinkledMesh(hV,fullH{h},wName);
   
   %{
   % Build and save wrinkled mesh
   hV = meshBuild(hV,fullH{h}); % When you are prompted for parameters, you
                                % can just press enter. We rename the mesh
                                % name below, so it doesn't matter what you
                                % originally enter. It'll also ask you to
                                % verify the class file path. When it asks
                                % you to save, you can cancel or save it as
                                % lh_wrinkled.mat or rh_wrinkled.mat.
    %}
    
   % Get wrinkled mesh
   wmsh = viewGet(hV,'currentmesh');
   
   %{
   % Naming the wrinkled mesh
   wName = [shortH{h},'_wrinkled'];
   wmsh = meshSet(wmsh,'name',wName);
   %}
   
   % Saving the wrinkled mesh
   wFName = ['3Danatomy/' wName '.mat'];
   mrmWriteMeshFile(wmsh,wFName);
   
   % Looping across smooth iterations
    for s = smooth
        
        % Naming the inflated mesh
        iName = [shortH{h},'_inflated_',mat2str(s),'_1'];
        
        % Setting the number of smooth iterations and sinc method
        imsh = meshSet(wmsh,'smooth_iterations',s,...
                       'smooth_sinc_method',0);
                   
        % There's some bug in meshSet when setting smooth relaxation, so it
        % needs to be set separately from iterations, since method.
        imsh = meshSet(imsh,'smooth_relaxation',1);
        
        % Setting name
        imsh = meshSet(imsh,'name',iName);
        
        % Smooth mesh
        imsh = meshSmooth(imsh);
        
        % Saving inflated mesh
        iFName = ['3Danatomy/' iName '.mat'];
        mrmWriteMeshFile(imsh,iFName);
    end
end

clx

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