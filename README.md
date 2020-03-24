# Data Manipulator
This repo is dedicated in making templates classes for general manipulation

## Current Status

I have a simple half template/half problem specific data loader class. With having the following filesystem in mind:

.
+-- {ExperimterInitials}{#mouse1}
|   +-- Recordings{X}
|   |   +-- Date
|   |   |	+-- Behavior
|   |   |	|   +-- behaviorData.mat
|   |	|   +-- Area{Y}
|   |	|   	+-- electrophysiologyData.mat
|   |   |	+-- Area{Z}
|   |   |	  	+-- electrophysiologyData.mat
|   |   |	+-- Video
|   |   |	   +-- PreprocessedVideo.mat
+-- {ExperimterInitials}{#mouse1}
