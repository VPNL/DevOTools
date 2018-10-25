%% PlotAllDates
% PlotAllDates will make a plots that show when each participant had scans
% and behavioral testing across the years. The purpose of these plots is to
% check to make sure that the scans and behavioral tests are grouped
% closely across the years of the experiment. To run this code, you will
% need DevOTools added to your path.
%
% AR Oct 2018

% Check to make sure that DevOTools is in the path
if ~exist('DevOTools')
    error('Please add DevOTools from the VPNL GitHub to your path')
end

%% Load Development of Perception Spreadsheet and Organize Data

% Load sheet, will need to update with each new download
sheet = loadDevelofPercept('DevelopmentOfPerception10252018.xlsx');

% Specify column names for all dates
dateCols = {'Anatomy Date','kidLoc Date','Ret Date','Toon Date','MT Date',...
            'LO Date','kidLoc Retest Date','DTI Run 1 Date','DTI Run 2 Date',...
            'Rec Mem Date','CFMT Boys Date','CFMT Adult Date','CFPT Boys Date',...
            'Benton Date','WASI Date','Reading Date'};

% Organize data into structures for adult and kid participants
adultData = organizeData(sheet,dateCols,1);
kidData = organizeData(sheet,dateCols);

%% Organize all dates for each subject into matrices and plot

% Make color scheme by year
colors = {'r','g','b','m','k'};
% Have different size dot for each year's dates to avoid overlap between
% years
sizes = [300 150 75 50 25];

% Loop through adult subject IDs, experiments, and years
adultSubj = fieldnames(adultData); % Getting all of the subject names
experiments = fieldnames(adultData.AD25); % Getting all of the experiment 
                                          % field names
figure(1) % Open figure
for i = 1:length(adultSubj) % Loop across adult subject IDs
    subj = adultSubj{i};
    for j = 1:length(experiments) % Loop across experiment names
        exprmnt = experiments{j};
        % Add data from this experiment to a matrix
        subjDateMatrix(j,:) = adultData.(subj).(exprmnt);
    end
    % Subtract the minimum date from subjDateMatrix so that the dates are
    % relative to the first scan of the first year.
    subjDateMatrix = subjDateMatrix - min(subjDateMatrix(:));
    % Plot each year in a separate color
    for y = 1:length(subjDateMatrix(1,:))
        % Scan dates will be filled circles, slightly shifted up in case
        % there's overlap with behavioral dates
        scatter(subjDateMatrix(1:9,y),(ones(1,9)*i)-.1,sizes(y),...
                colors{y},'filled');
        hold on
        % Behavior dates will unfilled circles, slightly shifted down to
        % avoid overlap
        scatter(subjDateMatrix(10:end,y),(ones(1,7)*i)+.1,sizes(y),...
                colors{y});
    end
end

% Axes labels, legend, gridlines
yticks(1:length(adultSubj));
yticklabels(adultSubj);
xticks([0 365 365*2 365*3 365*4 365*5]);
xticklabels({'0','1','2','3','4','5'});
xlabel('Years Since First Experiment');
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',24);
a = get(gca,'YTickLabel');
set(gca,'YTickLabel',a,'fontsize',24);
%Adding gridlines
set(gca,'YGrid','on')
legend('Year 1 Scan','Year 2 Behavioral','Year 2 Scan','Year 2 Behavioral',...
       'Year 3 Scan','Year 3 Behavioral','Year 4 Scan','Year 4 Behavioral',...
       'Location','best');
title('Dates of Adult Experiments')
hold off

clear subjDateMatrix

% Loop through kid subject IDs
kidSubj = fieldnames(kidData);
experiments = fieldnames(kidData.AAH06);
figure(2)
for i = 1:length(kidSubj) % Loop across kid subject IDs
    subj = kidSubj{i};
    for j = 1:length(experiments) % Loop across experiment names
        exprmnt = experiments{j};
        % Add data from this experiment to a matrix
        subjDateMatrix(j,:) = kidData.(subj).(exprmnt);
    end
    % Subtract the minimum date from subjDateMatrix so that the dates are
    % relative to the first scan of the first year.
    subjDateMatrix = subjDateMatrix - min(subjDateMatrix(:));
    % Plot each year in a separate color
    for y = 1:length(subjDateMatrix(1,:))
        % Scan dates will be filled circles, slightly shifted up in case
        % there's overlap with behavioral dates
        scatter(subjDateMatrix(1:9,y),(ones(1,9)*i)-.1,sizes(y),...
                colors{y},'filled');
        hold on
        % Behavior dates will unfilled circles, slightly shifted down to
        % avoid overlap
        scatter(subjDateMatrix(10:end,y),(ones(1,7)*i)+.1,sizes(y),...
                colors{y});
    end
end

% Axes labels, legend, gridlines
yticks(1:length(kidSubj));
yticklabels(kidSubj);
xticks([0 365 365*2 365*3 365*4 365*5]);
xticklabels({'0','1','2','3','4','5'});
xlabel('Years Since First Experiment');
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',24);
a = get(gca,'YTickLabel');
set(gca,'YTickLabel',a,'fontsize',24);
%Adding gridlines
set(gca,'YGrid','on')
legend('Year 1 Scan','Year 2 Behavioral','Year 2 Scan','Year 2 Behavioral',...
       'Year 3 Scan','Year 3 Behavioral','Year 4 Scan','Year 4 Behavioral',...
       'Year 5 Scan','Year 5 Behavioral','Location','best');
title('Dates of Kid Experiments')
hold off

clear subjDateMatrix