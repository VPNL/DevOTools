function fig = makeQAFig( data, figName, screenshot, mmScrnDim, ...
                          scrnDstnce )
%makeQAFig plots processed eyetracking data
%
%   fig = makeQAFig( data, figName, [screenshot], [mmScrnDim], [scnDstnce] )
%       data - 3 dimensional data matrix of doubles containing 
%              eyetracking data with blinks taken out. processed(:,1)
%              gives time, processed(:,2) gives x coordinate, and
%              processed (:,3) gives y coordinate. Units in dva
%       figName - string defining how you want to name your figure file
%       screenshot - (optional) path to image you want to appear behind the
%                    plot (default is from RecMem experiment)
%       mmScrnDim - (optional) vector of length 2 containing the x and y
%                   screen dimensions in milimeters. Defaults to the screen
%                   dimensions for the Recognition Memory experiment
%                   [385.28 288.96]
%       scnDstnce - (optional) scalar. Distance from eye to screen in
%                   milimeters. Defaults to screen distance for Recognition
%                   Memory experiment (540 mm)
%       fig - a plot of the processed eyetracking data showing where the
%             participant looked across the experiment
%
% AR Jan 2019
% AR Feb 2019 Setting the axes to match the edges of the screen. Overlaying
%             screenshot of experiment. Updating default parameters to
%             match RecMem code.
% AR Mar 2019 Added coloring to show how eye movements change over time

%% Check inputs and set defaults
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

%% Plot Data
fig = figure('visible','off');

% Calculating max dva in each direction
maxX = atand(mmScrnDim(1)/(2*scrnDstnce));
maxY = atand(mmScrnDim(2)/(2*scrnDstnce));
% Store max time value
maxT = max(data(:,1))/1000;

% Overlay screenshot of experiment
img = imread(screenshot);
image('CData',img,'XData',[-maxX,maxX],'YData',[-maxY,maxY]);
hold on

% Plot eyetracking data (x, y and time in seconds)
surface([data(:,2),data(:,2)],[data(:,3),data(:,3),],[data(:,1)/1000,...
    data(:,1)/1000],'EdgeColor','flat', 'FaceColor','none');

% Label axes and figure
ylabel('Degrees of Visual Angle From Screen Center')
xlabel('Degrees of Visual Angle From Screen Center')
title(figName)

% Setting x and y limits
xlim([-maxX,maxX])
ylim([-maxY,maxY])
% Adjusting x and y tick font
xtic = get(gca,'XTickLabel');
%set(gca,'XTickLabel',xtic,'fontsize',16);

% Set colormap
%sec = ' seconds  ';
cbar = colorbar('Ticks',[0 maxT*.25 maxT*.5 maxT*.75 maxT],'TickLabels',...
                {[num2str(0)], [num2str(maxT*.25)], ...
                 [num2str(maxT*.5)], [num2str(maxT*.75)], ...
                 [num2str(maxT)]});
cbar.Label.String = 'Time (seconds)';
colormap(cool);

hold off

end

