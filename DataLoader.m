classdef DataLoader
% DATALOADER Collects data from the database. The purpose is to create a
% general class that will facilitate the code sharing across memory, save
% memory and make it easier for new people to work with the experimental
% data. Also this class acts as a template where each with minor
% alterations will adapt it to his/her experiment.
    
    properties
        % General information
        ServerFilename % the location of the data
        ExperimenterInitials
        Mouse
        Day % here we consider that every mouse has at most on session/day
        Area
        Step
        % Time vector. Time is the main way to synchronize all the data as
        % it is the main common ground for all the experiments
        Time % in sec
        % Behavior and trial parameters, meaning behavior like licking,
        % whisking, start cues etc. and trial parameters like Performance,
        % state if a trial was omitted, early licks etc.
        TrialOnset
        LickOnset
        ContinuousLickTrace
        StimulusAmplitude
        Performance
        AbsoluteTrialNumber
        % Recording parameters, like electrophysiology data, fiber
        % photometry traces etc.
        SpikeTimes
        % Video data, in this case is already preprocessed images here a
        % lot can be done for optimization
        JawVideoOnsets
    end
    
    methods
        function obj = DataLoader(serverfilename, experimenter,...
                mouse, day, area, step)
        % DATALOADER Constructor method, for now it's working only for
        % importing one mouse but this is going to be generalized
        %   obj = DataLoader(serverfilename) loads all the data from all
        %   mice in the defined filename
        %   obj = DataLoader(serverfilename, experimenter) loads all the
        %   data from the defined experimenter
        %   obj = DataLoader(serverfilename, experimenter, mouse) loads all
        %   days all
        %   session from the defined mouse
        %   obj = DataLoader(serverfilename, experimenter, mouse, day)
        %   loads all the
        %   recording for the mouse mouse from day day
        %   obj = DataLoader(serverfilename, experimenter, mouse, day,
        %   area) loads the
        %   session defined from the mouse, day and area from the
        %   definition
            
            obj.ExperimenterInitials = experimenter;
            obj.ServerFilename = serverfilename;
            % Normally here it should be cases but for now there is only
            % implementation from the last case
            obj.Mouse = mouse;
            obj.Day = day;
            obj.Area = area;
            obj.Step = step;
            
            obj = obj.load_recording();
            obj.Time = obj.Step:obj.Step:max(obj.SpikeTimes{:, end});
            obj = obj.load_behavior();
            obj = obj.load_video();
        end
        
        
        function obj = load_behavior(obj)
        % LOAD_BEHAVIOR here you write your method, how you load your data
        %   obj = load_behavior()
            mousename = [obj.ExperimenterInitials num2str(obj.Mouse, '%.3d')];
            behaviorfn = fullfile(obj.ServerFilename, mousename, ...
                ['Day' num2str(obj.Day)], 'Behavior', 'trialData');
            load(behaviorfn)
            obj.StimulusAmplitude = Stimulus; % gives the amplitude, 0 if no stim
            obj.AbsoluteTrialNumber = AbsoluteTrial;
            obj.TrialOnset = Trial;
            obj.LickOnset = LickOnsets - (obj.TrialOnset > 0); % this is a hack
            obj.Performance = Performance;
        end
        
        function obj = load_recording(obj)
        % LOAD_RECORDING here you write your method, how you load your data
        %   obj = load_recording()
            mousename = [obj.ExperimenterInitials num2str(obj.Mouse, '%.3d')];
            areaname = ['Area' num2str(obj.Area)];
            recordingfn = fullfile(obj.ServerFilename, mousename, ...
                ['Day' num2str(obj.Day)], 'Recording', areaname, ...
                'electrophysiologyData');
            load(recordingfn)
            obj.SpikeTimes = SpikeTimes;
        end
        
        
        function obj = load_video(obj)
        % LOAD_VIDEO here you write your method, how you load your data
        %   obj = load_video()
            mousename = [obj.ExperimenterInitials num2str(obj.Mouse, '%.3d')];
            videofn = fullfile(obj.ServerFilename, mousename, ...
                ['Day' num2str(obj.Day)], 'Video', 'Jaw_I');
            load(videofn)
            JawTrace = obj.extract_jawonset(Jaw_I);
            obj.JawVideoOnsets = JawTrace;
        end
        
        
        function jawtrace = extract_jawonset(obj, videomatrix)
        % EXTRACT_JAWTRACE Specific function to extract the jaw onsets
        %   jawtrace = extract_jawonset(videomatrix). It returns an array
        %   were every row is a signal for a specific trial, the implementation is
        %   like that because we have video recordings only for some time in each
        %   trial. The step is defined from the camera frame rate where in this
        %   case is same as our step == 2ms
            firstlick = true; % for now this is kept until further notice
            maxframnumber = 1000; % this is a kind of magic number
            j = -reshape(videomatrix', [], 1);
            thr1 = nanmedian(j) + 10;
            thr2 = nanmean(j) + nanstd(j);
            trialnumber = min(length(obj.AbsoluteTrialNumber), ...
                sum(obj.AbsoluteTrialNumber < min(size(videomatrix))));
            jawtrace = zeros(maxframnumber, trialnumber);
            originaljawtrace = zeros(maxframnumber, trialnumber);
            
            if firstlick
                for i = 1:trialnumber
                    if isnan(sum(videomatrix(obj.AbsoluteTrialNumber(i), :)))
                        jawtrace(:, i) = nan;
                    else
                        tlick = [];
                        tlicks2 = tools.findandmergetj(-videomatrix(...
                            obj.AbsoluteTrialNumber(i), ...
                            1:maxframnumber), 10, thr2, true);
                        if ~isempty(tlicks2)
                            tlick = -videomatrix(obj.AbsoluteTrialNumber(i), :) < thr1;
                            tlick = find(tlick);
                            tlick = tlick(tlick < tlicks2(1));
                            if isempty(tlick)
                                tlick = tlicks2(1);
                            else
                                tlick = tlick(end);
                            end
                        end
                        jawtrace(:, i) = histcounts(tlick, 1:maxframnumber + 1);
                        originaljawtrace(:, i) = videomatrix(...
                            obj.AbsoluteTrialNumber(i), 1:maxframnumber);
                    end
                end
            else
                for i = 1:trialnumber
                    tlick = [];
                    if ~isnan(sum(videomatrix(obj.AbsoluteTrialNumber(i), ...
                            1:maxframnumber)))
                        [~, tlick] = findpeaks(-videomatrix(...
                            obj.AbsoluteTrialNumber(i), :), ...
                            'MinPeakHeight', thr2, 'MinPeakDistance', 40);
                    end
                    jawtrace(:, i) = histcounts(tlick, 1:maxframnumber + 1);
                    originaljawtrace(:, i) = videomatrix(...
                        obj.AbsoluteTrialNumber(i), 1:maxframnumber);
                end
            end
            if obj.Mouse == 39
                jawtrace = [zeros(500, min(size(jawtrace))); jawtrace(1:500, :)];
            end          
        end
       
        
    end
end
























