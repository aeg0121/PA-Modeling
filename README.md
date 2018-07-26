# PA-Modeling

## Purpose
The goal of this collection of programs is to create a means of modeling the behavior of a power amplifier (PA). In an ideal world, a PA would always work in a linear fashion, so that any output Y from input X is just X times a constant. Unfortunately, a PA is an analog device and runs into physical limitations. It can only be driven so much until the PA saturates and the output plateaus. Thus, the PA is non-linear.

So, this aims to create a polynomial model of the PAs, where Y = 

## Downloads

## Installation

### SD Card

## Overview of Programs

### Main
As the main program, this is the one you want to run every time you wish to gather a new set of coefficients. 

### WARP

### WebRF

### Signal

### OFDM

### WhiteNoise

### Power Amplifier

### Evaluate PA Models

### Plot Results

### PA Tables

### Create Figure

## Running the Programs

### 1. Check Your Board
First, you'll need to make sure that your WARP board is in proper order before you begin. The board needs to be plugged into a power source and to your computer with an Ethernet cable. Unplug any unnecessary attatchments the motherboard has to any surrounding daughter cards. The SD card needs to be inserted in the slot on the end of the board. on the opposite end are the two ports where you should attatch two coaxial cables joined together by a 30dB attenuator. On all WARP boards are two sets of four binary switches. Switch all of them to 0. Some boards have a clock module with a set of two switches on top of it. Turn those switches to 1.

With all of this done, finally turn the board on. If everything was done correctly, you should see "01" on the number display and a green LED flashing next to it. The LED will continue flashing for a few seconds until two pairs of LEDs start shuffling back and forth. After the shuffling, all the LEDs should be off. The board is now ready to go for testing.  

WARNING: Failure to attatch the coaxial cables and attenuator to the WARP ports may cause a total internal reflection of the signal's power back to the PA, which may damage it. Also, it leaves poor results that may fool one to believe their PA is already broken.

### 2. Check Your Inputs
Near the top of Main are primary inputs that one controls when running the program. When we were collecting data, we titled each of our tables based on the inputs found in main. Thus, it is important that you double back between Main and PA Tables so that whatever is the title of what you plan to save actually matches what is found in main. For instance, if you wrapped up collecting data for one type of signal and moved on to the next one, you may change your inputs in main but forget to reflct that change in what you are saving in PA Tables. You would then go one to keep adding the wrong data on top of your previous table rather than start a new one. Alternatively, you could remember to change the title to match new changes, but get those changes wrong. Now you are filling out a mislabeled table that you believe is meant to represent one signal type, but is actually another. 

### 3. Run!
When everything is set, it's time to run Main

X
Y
Z

### 4. Options
If you feel that waiting for the figures to load every time the program is run is tedious and would like to shave off a few seconds, comment out the Plots section of Main.

Running the program constantly will continue to add rows to whatever table is slated for loading and saving. If left unchecked, a massive, bloated table will ensue. If you wish to test for aspects besides coefficients, it may be in your interest to comment out the line that saves the table in PA Tables. You can still view the coefficients from that run if you wish, but they won't be permanently added to any table. 

You are free to try using higher orders and memory taps in Evaluate PA Models if you wish, but improvements may be marginal and take longer to produce.

## Data Display
After you have a collection of tables, it may be time to visualize what you have collected. What we did was take the median of the absolute value of each coefficient per table, and display it in a bar graph along with the absolute medians from other tables. To ensure that these graphs aren't cluttered, use a sensible amount of tables per graph, around 6 or so.

If you are creating multiple graphs of data you would consider grouped together, standardizing aspects like the axis limits and image size is advised. That way you could flip through the graphs and retain the same sense of scale for each of them. 

As you can see, the tick marks have been changed from integers to betas with the accompanying order and tap as subscripts. To do this, go the Axes Properties and set each tick to "\beta_{order,tap}".

Upon the creation of the absolute median graphs, anyone who wasn't there to run the program can see which PAs may be broken. Feel free to forget about the from broken PAs while adjusting the Y axis limits. Not only might these bars dwarf that of working boards, they are also largely false and worthless. 

## Data Compilation
At some point, you will have run as many tests as possible on all signal types and boards at your disposal. Now it is time to compile the data. What we did was make two sets of massive matrices: one containing all coefficients taken, and one that only contained the data from PAs that weren't broken. Each matrix was based on a signal type. An accompanying document was made as a guide to which row numbers correspond to which specific PA. If all boards were arranged in the same order for all signal types, the list can be standard for all signal types as well. 

With these "master" matrices we also created two sets of statistics matrices that contained the median, mean, standard deviation, 5th, and 95th percentiles of each coefficient from a corresponding signal type. To visualize these results, we created error bar graphs that contained the median and standard deviation from raw data and the clean data for comparison. As you can see, the differences in variance can be stark, and demonstrate how much the borken PAs can skew values. 

## Troubleshooting
