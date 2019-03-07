function finalData = dvaConvert( data, pxlScrnDim, mmScrnDim, ...
                                             scrnDstnce )
% dvaConvert converts eyetracker data from pixel units to degrees of visual
% angle (dva)
%
%   finalData = dvaConvert( data, [pxlScrnDim], [mmScrnDim], [scnDstnce] )
%       data - 3 dimensional data matrix of doubles containing eyetracking 
%              data. raw(:,1) gives time, raw(:,2) gives x coodinate, and 
%              raw(:,3) gives y coordinate. Contains data in units of
%              pixels.
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
%       finalData - Data matrix of doubles with the same shape as raw.
%                   Contains data in units of degree of visual angle.
%
% AR Jan 2019
% AR Feb 2019 updated default parameters to match the RecMem code,
% corrected dva conversion (was off by a factor of 2)

%% Check inputs and set defaults
if ~exist('scnDstnce')
    scrnDstnce = 540;
end

if ~exist('mmScrnDim')
    mmScrnDim = [385.28 288.96];
end

if ~exist('pxlScrnDim')
    pxlScrnDim = [1024 768];
end

%% Unit Convertion on Data

% Center data at zero
data(:,2) = data(:,2) - ( pxlScrnDim(1) / 2 );
data(:,3) = data(:,3) - ( pxlScrnDim(2) / 2 );

% Flip direction of y axes
data(:,3) = data(:,3)*-1;

% Calculate conversion from pixels to milimeters
MMCONVERT = mmScrnDim(1) / pxlScrnDim(1);

% Convert data to milimeters
data(:,2:3) = data(:,2:3) * MMCONVERT;

% Convert data to DVA
data(:,2:3) = atand(data(:,2:3)/scrnDstnce);

% Return finalData
finalData = data;

end

