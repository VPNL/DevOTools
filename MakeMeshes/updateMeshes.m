function updateMeshes( hemisphere, smooth_iterations, sesDir )
% updateMeshes reinstalls segmentation from nifti class file and makes new
% meshes
%
% In the mrVista directory, make sure that there is a softlink to the
% 3Dantomy, and that the volume anatomy is aligned to the inplane.
%
%   updateMeshes( [hemisphere], [smooth], [sesDir] )
%       hemisphere (optional): (cell of strings) Which hemispheres would
%                              you like to construct? (i.e. {'left'},
%                              {'right'} or {'left','right'}) Default is
%                              both hemispheres
%       smooth_iterations (optional): (vector) number of smooth iterations 
%                                     you would like (default is [200 32])
%       sesDir (optional): (string) path to mrVista directory (default is 
%                           current directory)
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
% AR Feb 2019 used mrmStart to start mrMesh at the beginning of the code
% AR Mar 2019 commented out setting vANATOMYPATH as it was causing issues
%             and is unnecessary; made sesDir an optional argument; added
%             in arguments for hemisphere and smooth_iterations

%% Checking inputs and system
% Check to make sure mrVista is added to the path
if ~exist('mrVista')
    error('Please add mrVista to your path')
end

% Check inputs
% Specify hemispheres and smooth iterations
if ~exist('hemisphere') | isempty(hemisphere)
    fullH = {'left','right'};
    shortH = {'lh','rh'};
else
    fullH = {};
    shortH = {};
    if any(strcmp(hemisphere,'left'))
        fullH{end+1} = 'left';
        shortH{end+1} = 'lh';
    end
    if any(strcmp(hemisphere,'right'))
        fullH{end+1} = 'right';
        shortH{end+1} = 'rh';
    end
    if isempty(fullH)
        error(['Please enter the hemisphere you would like to build as a '...
              'cell array (i.e. {"left"},{"right"} or {"left","right"}).'])
    end
end

% Specify smooth iterations
if ~exist('smooth_iterations')
    smooth_iterations = [200 32];
elseif ~isnumeric(smooth_iterations)
    error(['When specifying your smooth iterations, please use a numeric '...
          'input (e.g. [200 32]).'])
end

% Check for session directory
if ~exist('sesDir')
    sesDir = pwd;
elseif ~exist(sesDir)
    error(['Cannot find ' sesDir]);
end

%% Building meshes
% Start mrMesh (important for Macs)
mrmStart

% Go to session directory
cd(sesDir)

% Reinstall t1_class file
[hV, anatomy] = reinstallClassFile( sesDir );

% Loop across hemispheres
for h = 1:length(fullH)
    
   % Naming the wrinkled mesh
   wName = [shortH{h},'_wrinkled'];
    
   %Build wrinkled mesh
   hV = makeWrinkledMesh(hV,fullH{h},wName);
    
   % Get wrinkled mesh
   wmsh = viewGet(hV,'currentmesh');
   
   % Saving the wrinkled mesh
   wFName = [anatomy wName '.mat'];
   mrmWriteMeshFile(wmsh,wFName);
   
   % Looping across smooth iterations
    for s = smooth_iterations
        
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
        iFName = [anatomy iName '.mat'];
        mrmWriteMeshFile(imsh,iFName);
    end
end

clx

end