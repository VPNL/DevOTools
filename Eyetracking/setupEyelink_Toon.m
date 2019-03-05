function setupEyelink_Toon( edfName )
% setupEyelink_Toon setups eyelink system for eye tracking during the
% toonotopy experiment. Will reduce projector resolution to 1280 x 800 
% pixels, and sets display distance to 940 mm.
%
%   setupEyelink_Toon( edfName )
%
% AR March 2019

% Initialize eyelink and check to make sure Eyelink is online
if EyelinkInit() ~= 1
    error(['Cannot connect to eye tracker'])
end

% Open PsychToolBox Window on largest screen
screenNumber = max(Screen('Screens'));
Screen('Resolution',screenNumber,1280,800) % Decrease the projector
                                           % resolution so the participant
                                           % can see the full screen.
                                           % Matches resolution used for
                                           % Toonotopy
win = Screen('OpenWindow',max(Screen('Screens')));
% Set this window to highest priority
Priority(MaxPriority(win));
% Flip screen
Screen('Flip',win);

% Get init defaults
el = EyelinkInitDefaults(win);

% Open edf file to record data
edf = Eyelink('Openfile',edfName);
% Check to make sure file was created
if edf ~= 0
    Eyelink('Shutdown')
    error(['Could not create EDF file ' edfName]);
end

% Setting eyelink preferences
Eyelink('command', 'add_file_preamble_text ''dynamic stim eyetracking''');
[width, height]=Screen('WindowSize',win); % returns screen size in pixels
Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, ...
        width-1, height-1); % sets physical.ini to screen pixels
Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, width-1, ...
        height-1);
Eyelink('command','screen_distance = 940') % Distance from eye tracker 
                                           % camera to mirror image of
                                           % subject's eye (measured by AR
                                           % and MN on 03.05.2019)
Eyelink('command', 'calibration_type = HV3'); % 3 point calibration, 
                                              % set in calibr.ini
% set EDF file contents
Eyelink('command', ...
        'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON');
Eyelink('command', ...
        'file_sample_data  = LEFT,RIGHT,GAZE,DIAMETER,HREF,AREA,GAZERES,STATUS');
Eyelink('Command', 'file_event_data = GAZE,GAZEREZ,DIAMETER,HREF,VELOCITY');
% set data available in real time
Eyelink('command', ...
        'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON');
Eyelink('command', ...
        'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS');
% allow to use eyelink gamepad to accept fixations/targets
Eyelink('command', 'button_function 5 "accept_target_fixation"');

% Calibrate, Validate and Correct Eye Tracker for Drift
EyelinkDoTrackerSetup(el); % Will wait for you to do the calibration, validation, and drift correction. Will end when you move to the Output/Record Window

% Close edf file
Eyelink('CloseFile')

end