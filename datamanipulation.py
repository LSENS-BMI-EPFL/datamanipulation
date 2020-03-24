import os

class DataLoader:
    # DATALOADER Collects data from the database. The purpose is to create a
    # general class that will facilitate the code sharing across memory, save
    # memory and make it easier for new people to work with the experimental
    # data. Also this class acts as a template where each with minor
    # alterations will adapt it to his/her experiment.


    def __init__(self, serverfilename, experimenter, mouse, day, area, step):
        ''' DATALOADER Constructor, for now it's working only for
        importing one session of a mouse but this is going to be generalized

        Parameters:
            serverfilename(str) : absolute directory name to server
            experimenter(str) : experimeters initials
            mouse(int) : name of mouse
            date(str) : date of the experiment
            area(str) : name or #id of the area
        '''

        self.ExperimenterInitials = experimenter
        self.ServerFilename = serverfilename
        # Normally here it should be cases but for now there is only
        # implementation from the last case
        self.Mouse = mouse
        self.Date = date
        self.Area = area
        self.Step = step # in seconds

        # Time vector. Time is the main way to synchronize all the data as
        # it is the main common ground for all the experiments
        self.Time = []# in sec
        # Behavior and trial parameters, meaning behavior like licking,
        # whisking, start cues etc. and trial parameters like Performance,
        # state if a trial was omitted, early licks etc.
        self.TrialOnset = []
        self.LickOnset = []
        self.StimulusAmplitude = []
        self.Performance = []
        self.AbsoluteTrialNumber = []
        self.LickTraceBehavior = []
        self.StimulusTrace = []
        # Recording parameters, like electrophysiology data, fiber
        # photometry traces etc.
        self.SpikeTimes = []
        self.Raster = []
        # Video data, in this case is already preprocessed images here a
        # lot can be done for optimization
        self.JawVideoOnsets = []
        self.LickTraceVideo = []
        self.CorruptedTrials = []

        self.load_recording()
        self.load_behavior()
        self.load_video()

    def load_recording(self):
        ''' LOAD_RECORDING here you write your method, how you load your data'''

        mousename = "{}{:0=3}".format(self.ExperimenterInitials, self.Mouse)
        behaviorfn = os.path.join(self.ServerFilename,
         mousename, "Recordings", "{}".format(self.Date), 'Recordings')
        self.behaviorfn = behaviorfn

    def load_behavior(self):
        ''' LOAD_BEHAVIOR here you write your method, how you load your data'''

        mousename = "{}{:0=3}".format(self.ExperimenterInitials, self.Mouse)
        recordingfn = os.path.join(self.ServerFilename,
        mousename, "Recordings", "{}".format(self.Date), 'Behavior', 'trialData');
        self.recordingfn = recordingfn

    def load_video(self):
        ''' LOAD_VIDEO here you write your method, how you load your data'''

        mousename = "{}{:0=3}".format(self.ExperimenterInitials, self.Mouse)
        videofn = os.path.join(self.ServerFilename,
         mousename, "Recordings", "{}".format(self.Date), 'Video', 'videoDate')
        self.videofn = videofn
