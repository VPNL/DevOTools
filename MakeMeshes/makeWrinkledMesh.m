function [vw,newMeshNum] = makeWrinkledMesh( vw, hemisphere, meshName )
% makeWrinkledMesh makes a wrinkled mesh with zero gray layers
%
% makeWrinkedMesh is a copy of the meshBuild function in mrVista, except it
% automatically sets the mesh parameters commonly used in the Grill-Spector
% lab
%
% [vw,newMeshNum] = makeWrinkledMesh( vw, hemisphere, meshName )
%	vw: a VISTASOFT view structure
%	hemisphere: (string) 'left' or 'right' ('left' is default)
%	meshName: (string) what you would like to call this mesh
%
% AR Dec 2018

% Be sure anatomy is loaded (we need it for the mmPerVox field)
if isempty(vw.anat), vw = loadAnat(vw); end
if ieNotDefined('hemisphere'), hemisphere = 'left'; end

newMeshNum = viewGet(vw,'nmesh') + 1;

% Commenting out where meshBuild asks for parameters
%{
[meshName,numGrayLayers,hemiNum] = readParams(newMeshNum,hemisphere);
if isempty(meshName), newMeshNum = newMeshNum - 1; return; end   % User pressed cancel.
%}

% Automatically setting parameters
numGrayLayers = 0;
if strcmp(hemisphere,'right')
    hemiNum = 2;
else
    hemiNum = 1; % Left hemisphere is default
end

% mmPerVox = viewGet(vw,'mmPerVoxel');

wbar = mrvWaitbar(0.1, ...
    sprintf('meshBuild: Combining white and gray matter...'));

% Load left, right, or both hemispheres.  
if (hemiNum==1)
    [voxels,vw] = meshGetWhite(vw, 'left', numGrayLayers);
elseif (hemiNum==2)
    [voxels,vw] = meshGetWhite(vw, 'right', numGrayLayers);
elseif (hemiNum == 0)
    [voxels,vw] = meshGetWhite(vw, 'left', numGrayLayers);
    [voxels,vw] = meshGetWhite(vw, 'right', numGrayLayers,voxels);
end

% host = 'localhost';
% windowID = -1;

% We build a smoothed (mesh) and an unsmoothed mesh (tenseMesh) with these calls
mrvWaitbar(0.35,wbar,sprintf('Building mesh'));
[newMesh, tenseMesh] = mrmBuild(voxels,viewGet(vw,'mmPerVox'),1);

% Must have a name
newMesh   = meshSet(newMesh,'name',meshName);
tenseMesh = meshSet(tenseMesh,'name',sprintf('%s-tense',meshName));

% mrvWaitbar(0.65,wbar,sprintf('meshBuild: Unsmoothed mesh vertex to gray mapping'));
initVertices = meshGet(tenseMesh,'vertices');
newMesh = meshSet(newMesh,'initialvertices',initVertices);
vertexGrayMap = mrmMapVerticesToGray(...
    initVertices, ...
    viewGet(vw,'nodes'), ...
    viewGet(vw,'mmPerVox'),...
    viewGet(vw,'edges'));

newMesh = meshSet(newMesh,'vertexGrayMap',vertexGrayMap);
newMesh = meshSet(newMesh,'name',meshName);
newMesh = meshSet(newMesh,'nGrayLayers',numGrayLayers);

% Commenting out section where mesh is saved
%{
mrvWaitbar(0.9,wbar,sprintf('meshBuild: Saving mesh file %s',meshGet(newMesh,'name')));

% Save mesh file
[newMesh newMesh.path] = mrmWriteMeshFile(newMesh);
%}

mrvWaitbar(1,wbar,sprintf('meshBuild: Done')); 
pause(0.5);
close(wbar);

% Now refresh the UI
vw = viewSet(vw,'add and select mesh',newMesh);

return;

%---------------------------------------
function classFile = verifyClassFile(vw,hemisphere)

classFile =  viewGet(vw,'classFileName',hemisphere);
str = sprintf('Class %s',classFile);

% Commenting out section where meshBuild asks you to verify the class file
%{
r=questdlg(str);   
if ~strcmp(r,'Yes')
    switch hemisphere
        case 'left'
            vw = viewSet(vw,'leftClassFileName',[]); 
        case 'right'
            vw = viewSet(vw,'rightClassFileName',[]); 
    end
    classFile =  viewGet(vw,'classFileName',hemisphere);
end
%}

return;

%---------------------------------------
function voxels = classExtractWhite(voxels,data,voi,whiteValue)
%

% ras 05/07: the indexing of data seems off to me -- is this correct?
voxels(voi(1):voi(2), voi(3):voi(4), voi(5):voi(6)) = ...
    voxels(voi(1):voi(2), voi(3):voi(4), voi(5):voi(6)) ...
    | (data(voi(1):voi(2), voi(3):voi(4), voi(5):voi(6)) == whiteValue);

return;


%----------------------------------------
function [meshName,numGrayLayers,hemiNum,alpha,restrictVOI,relaxIterations] = ...
    readParams(newMeshNum,hemisphere)
%
%  readParams
%
% Internal routine to read the parameters for meshBuild
% 
meshName = sprintf('%sSmooth',hemisphere);
numGrayLayers = 0;
switch hemisphere
    case 'left'
        hemiNum = 1;
    case 'right'
        hemiNum = 2;
    case 'both'
        hemiNum = 0;
end

% transparency level (transparency is off by default, but if it gets turned
% on, this alpha parameter will have an effect).
alpha = 200;
restrictVOI = 1;
relaxIterations = 0.2;

prompt = {'Mesh Name:',...
        'Number of Gray Layers (0-4):',...
        'Hemisphere (0=both, 1=left, 2=right):',...
        % 'Default alpha (0-255):',...
        % 'Inflation (0=none, 1=lots):',...
        % 'Restrict to class VOI (0|1):'};
        };
defAns = {meshName,...
        num2str(numGrayLayers),...
        num2str(hemiNum),...
        % num2str(alpha),...
        % num2str(relaxIterations),...
        % num2str(restrictVOI)};
        };

resp = inputdlg(prompt, 'meshBuild Parameters', 1, defAns);

if(~isempty(resp))
    meshName = resp{1};
    numGrayLayers = str2num(resp{2});
    hemiNum = str2num(resp{3});
    % alpha = str2num(resp{4});
    % relaxIterations = round(str2num(resp{5})*160);  % Arbitrary choice, scales iters [0,160]
    % restrictVOI = str2num(resp{6});
else
    meshName = [];
    numGrayLayers = [];
    hemiNum = [];
    % alpha = [];
    % relaxIterations = [];  % Arbitrary choice, scales iters [0,160]
    % restrictVOI = [];
end

return;


%---------------------------------
function [voxels,vw] = meshGetWhite(vw, hemiName, numGrayLayers, voxels)
%
%
%

if ieNotDefined('vw'), error('You must send in a volume vw'); end
if ieNotDefined('hemiName'), error('You must define right,left or both'); end
if ieNotDefined('numGrayLayers'), numGrayLayers = 0; end

classFile = verifyClassFile(vw,hemiName);
if isempty(classFile),
    close(wbar); newMeshNum = -1;
    voxels = [];
    return;
end
classFileParam = [hemiName,'ClassFile'];
vw       = viewSet(vw,classFileParam,classFile);

classData = viewGet(vw,'classdata',hemiName);
if ieNotDefined('voxels'),
    voxelsOld = uint8(zeros(classData.header.xsize, ...
        classData.header.ysize, ...
        classData.header.zsize));
else
    voxelsOld = voxels;
end
voxels = zeros(classData.header.xsize, ...
        classData.header.ysize, ...
        classData.header.zsize);

% Restrict the white matter volume to a size equal to the ROI in which it
% was selected 
voxels = classExtractWhite(voxels,...
    classData.data,classData.header.voi,classData.type.white);
%   msh = meshColor(meshSmooth(meshBuildFromClass(voxels,[1 1 1])));
%   meshVisualize(msh);

% Add the gray matter
if(numGrayLayers>0)
    
    [nodes,edges,classData] = mrgGrowGray(classData,numGrayLayers);
    voxels = ...
        uint8( (classData.data == classData.type.white) | ...
        (classData.data == classData.type.gray));
end

voxels = uint8(voxels | voxelsOld);

return;