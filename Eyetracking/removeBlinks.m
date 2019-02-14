function processed = removeBlinks(raw)
% removeBlinks will set all time points corresponding to blinks in raw
% eyetracking data to NaN
%
%   processed = deleteBlinks( raw )
%       raw - 3 dimensional data matrix of doubles containing eyetracking 
%             data. raw(:,1) gives time, raw(:,2) gives x coodinate, and 
%             raw(:,3) gives y coordinate.
%       processed - Data matrix of doubles with the same shape as raw.
%                   Contains processed data where blinks are taken out.
%
% AR Jan 2019, adapted from a script DF wrote

% Extract x and y components of raw
x = raw(:,2);
y = raw(:,3);

%% Removing Blinks

% Find when subject starts to blink
d       = diff(isnan(x) | isnan(y));
starts  = find(d==1);

%{
% Don't need to look at x data because will only notice blinks in y
  direction
% Look at how x data behaves to see when there are large jumps before
% and after blink
xvel     = diff(x);
%xsmvel   = smooth(diff(smooth(x,3)),3); % smoothing step, takes a while
xsmvel = xvel;
xmeanspd = nanmean(abs(xsmvel));
xstdspd  = nanstd( abs(xsmvel));
%}
% Look at how y data behaves to see when there are large jumps before
% and after blink
ydiff     = diff(y);
ydiffmean = nanmean(abs(ydiff));
ydiffstd  = nanstd( abs(ydiff));

% Delete data before start of blink
for i = 1:length(starts)
  s = starts(i); % Timepoint right before the start of the blink
  go = 20; % Will continue deleting until there are this many consecutive 
           % non-blink datapoints. Since the RecMem experiment records at
           % 150 Hz, each data points are taken once every 7 miliseconds or
           % so.
  while s>0 & go>0
    % Check to see if y value shows a significant jump in the data
    if (ydiff(s) > (ydiffmean + 3*ydiffstd)) | ...
       (ydiff(s) < (ydiffmean - 3*ydiffstd))
      raw(s,2:3)=nan; % Get rid of bad data before blink
      go=20; % Reset go
    else
      raw(s,2:3)=nan; % Get rid of a few extra timepoints before the blink
                      % to make sure the data is clean
      go=go-1;
    end
    s=s-1; % Look at previous timepoint
  end
end

% Find when subject stops blinking
ends  = find(d==-1);

% Delete data after end of blink
for i = 1:length(ends)
  e = ends(i) + 1; % Timepoint right after the end of the blink
  go = 20; % Will continue deleting until there are this many consecutive 
           % non-blink datapoints
  while e<length(x) & go>0
    % Check to see if y value shows a significant jump in the data
    if (ydiff(e) > (ydiffmean + 3*ydiffstd)) | ...
       (ydiff(e) < (ydiffmean - 3*ydiffstd))
      raw(e,2:3)=nan; % Get rid of bad data before blink
      go=20; % Reset go 
    else
      raw(e,2:3)=nan; % Get rid of a few extra timepoints before the blink
                      % to make sure the data is clean
      go=go-1;
    end
    e=e+1;
  end
end

% Return processed
processed = raw;

end