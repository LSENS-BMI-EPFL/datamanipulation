# Data Manipulator
This repo is dedicated in making templates classes for general manipulation

## Current Status

I have a simple half template/half problem specific data loader class. With having the following filesystem in mind:

<<<<<<< HEAD
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
=======

````
|-- {ExperimterInitials}{#mouse1}
|   |-- Day{X}
|      |-- Behavior
|      |   |-- behaviorData.mat
|      |-- Recording
|      |   |-- Area{Y}
|      |   |   |-- electrophysiologyData.mat 
|      |   |-- Area{Z}
|      |   |   |-- electrophysiologyData.mat 
|      |-- Video
|          |-- PreprocessedVideo.mat
|-- {ExperimterInitials}{#mouse1}
````

>>>>>>> c7917c4c0452bd51d859499e87cad3f1b8b98b4f
