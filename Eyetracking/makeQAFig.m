function fig = makeQAFig( data, figName )
%makeQAFig plots processed eyetracking data
%
%   fig = makeQAFig( processed )
%       data - 3 dimensional data matrix of doubles containing 
%              eyetracking data with blinks taken out. processed(:,1)
%              gives time, processed(:,2) gives x coordinate, and
%              processed (:,3) gives y coordinate.
%       fig - a plot of the processed eyetracking data showing where the
%             participant looked across the experiment
%
% AR Jan 2019
% AR Feb 2019 Made sure axes are equal in size

% Plot data
fig = figure('visible','off');
plot(data(:,2),data(:,3))

% Label axes and figure
ylabel('Degrees of Visual Angle From Screen Center')
xlabel('Degrees of Visual Angle From Screen Center')
title(figName)

% Make sure axes are equal in size
max = nanmax([data(:,2); data(:,3)]);
min = nanmin([data(:,2); data(:,3)]);
xlim([min max])
ylim([min max])

end

