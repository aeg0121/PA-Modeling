# PA-Modeling

## Purpose
In an ideal world, a power amplifier (PA) would always work in a linear fashion, so that any output Y from input X is just X times a constant. Unfortunately, a PA is an analog device and runs into physical limitations. It can only be driven so much until the PA saturates and the output plateaus. Thus, the PA is non-linear. The goal of this collection of programs is to create a means of modeling the behavior of a PA and saving the results in tables that can add new rows for each modeling run.

Ultimately, the hope is that if enough models of different PAs are similar enough, one could use a single general model for digital predistortion purposes.

## Downloads

## Installation

### SD Card
Make sure you can identify it! 

## Overview of Programs

### Main
As the main program, this is the only one that you actually want to run by itself. It contains several input parameters that then get passed on to the other function programs:

#### Board
The type of board used is either

#### RF Port
Since there are two PAs on the WARP board, 

#### Signal Type
Type if input signal. So far the only two types are orthogonal frequency-division multiplexing (OFDM) and white gaussian noise (WGN). 

#### Random Signal
Controls if you want different new random input signals or the same signal for when you run the program.

#### Signal Bandwidth
Only certain bandwidths are acceptable. In this case, it is 1.4, 5, and 10 MHz. The number of the input here is in MHz.

#### Channel

#### RMS Power
Controls the root mean square power of the signal. This one is best left unchanged.

### WARP
Contains the settings for which board channel is used and how much gain on the transmitter or receiver there is. 

### WebRF


### Signal


### OFDM


### White Noise


### Power Amplifier


### Evaluate PA Models


### Plot Results
Plots the five (or four) results graphs after running Main.  

### PA Tables
Generates and saves new tables. Loads and appends to existing tables.

### Create Figure
This program is a function meant to speed up the creation of absolute median graphs. It was created by using File > Generate Code for a completed figure already manually created. It serves to create a bar graph and immediately implement a title, legend, and coefficient tick marks. Don't forget to change the inputs of this function when you are making a new graph, or else you'd wast time going back to edit the title or legend and waste time, defeateing the whole purpose of the function.

## Running the Programs

### 1. Check Your Board
First, you'll need to make sure that your WARP board is in proper order before you begin. The board needs to be plugged into a power source as well as to your computer with an Ethernet cable. Unplug any unnecessary attatchments the motherboard has to any surrounding daughter cards. The SD card needs to be inserted in the slot on the end of the board. On the opposite end are the two ports where you should attatch two coaxial cables joined together by a 30dB attenuator. On all WARP boards are two sets of four dip switches. Switch all of them to 0. Some boards have an external clock module with a set of two switches on top of it. Turn those switches to 1.

With all of this done, turn the board on. If everything was done correctly, you should see "01" on the number display and a green LED flashing next to it. The LED will continue flashing for a few seconds until two pairs of LEDs start shuffling back and forth. After the shuffling, all the LEDs should be off. The board is now ready to go for testing.  

WARNING: Failure to attatch the coaxial cables and attenuator to the WARP ports may cause a total internal reflection of the signal's power back to the PA, which may damage it! Also, it leaves poor results that may fool one to believe their PA is already broken.

### 2. Check Your Inputs
Near the top of Main are the primary input parameters that one controls when running the program. When we were collecting data, we titled each of our tables based on the board used and the inputs found in main. Other details like the date which the data was collected and which channel was used were also used to make sure one has as clear an idea as possible as to what the table contains. An example for a table name could be "july_30_board00472_ofdm_5mhz_ch6_a2b". It's best to reflect as many variable parameters you are using. A set of tables where more parameters are held constant may have less detail. Saving and loading tables for the purpose of adding new coefficients is found in PA Tables. The names go where you currently see 'evaluate_pa_models'.

Keep in mind that what creates a new table as opposed to loading a new one is changing the name in the "save" line of PA Tables to something new. 

It is important that you double back between Main and PA Tables so that whatever is the title of what you plan to save actually matches what is found in main. For instance, if you wrapped up collecting data for one type of signal and aim to move on to the next one, you may change your inputs in Main but forget to reflct that change in what you are saving in PA Tables. You would then go on to keep adding the wrong data to your previous table rather than start a new one. Alternatively, you could remember to change the title to match new changes, but get those changes wrong. Now you are filling out a mislabeled table that you believe is meant to represent one signal type, but is actually another. 

Don't forget to ensure that what is slated for saving and loading match!

### 3. Run and Review Results
When everything is set, it's time to run Main. Note that lower bandwidths take a bit longer to run, especially for WGN, so don't be discouraged if it seems to be taking its time. Out of the five figures that are plotted, these two give the clearest indication of a clean or broken board.

![cc](https://raw.githubusercontent.com/aeg0121/PA-Modeling/master/Results/Clean%20Constellation.png "Clean Constellation")

![cam](https://raw.githubusercontent.com/aeg0121/PA-Modeling/master/Results/Clean%20AM%20AM.png "Clean AM AM Curve")

![bc](https://raw.githubusercontent.com/aeg0121/PA-Modeling/master/Results/Broken%20Constellation.png "Broken Constellation")

![bam](https://raw.githubusercontent.com/aeg0121/PA-Modeling/master/Results/Broken%20AM%20AM.png "Broken AM AM Curve")

These results were taken from the exact same board and exact same signal type. However, the first two clean results were from A to B and the latter two broken results were from B to A. 

For a sufficient amount of data per signal per board, use at least 20 trials each.

The table that shows up in the workspace, "pa_tables", is not permanent! It should be treated as a variable like all others in the workspace. 

### 4. Options
If you feel that waiting for the figures to load every time the program is run is tedious and would like to shave off a few seconds, comment out the Plots section of Main.

Running the program constantly will continue to add rows to whatever table is slated for loading and saving. If left unchecked, a massive, bloated table will ensue. If you wish to test for aspects besides coefficients, it may be in your interest to comment out the line that saves the table in PA Tables. You can still view the coefficients from that run if you wish as a new row added to "pa_tables", but "pa_tables" only exists as a variable that gets cleared out with the next run. The table that is saved is unaffected. 

You are free to try using higher orders and memory taps in Evaluate PA Models if you wish, but improvements may be marginal and take longer to produce.

## Data Display
After you have a collection of tables, it may be time to visualize what you have collected. What we did was take the median of the absolute value of each coefficient per table, and display it in a bar graph along with the absolute medians from other tables. 

To ensure that these graphs aren't cluttered, use a sensible amount of tables per graph, around 6 or so.

It is important to know that since the tables for 7th order, 4 memory taps contains 16 coefficients, the most data, we used the data from those tables in all visualizations, compilations, and statistics to follow.

To create the graph, we went through multiple tables and took the rows containing their absolute medians (excluding the 17th and last column!). With these rows, we created a matrix for the bar function of MATLAB to draw from. Add a legend to identify the bars after using the bar function. 

If you are creating multiple graphs of data you would consider grouped together, standardizing aspects like the axis limits and image size is advised. That way you could flip through the graphs and retain the same sense of scale for each of them. 

![comp](https://raw.githubusercontent.com/aeg0121/PA-Modeling/master/Results/July%2016%20ofdm%205%20mhz%20order74%20a2b%20PA%20comparison.png "Example Median Bar Graph")

With this example, one can see the median coefficients of several boards, including one that clearly sticks out. This is the kind of results found in a broken board.

For a some better spacing, the X axis limits have been standardized as going from 0 to 17. As you can also see, the tick marks have been changed from integers to betas with the accompanying order and tap as subscripts. To do this, go the Axes Properties and set each tick to "\beta_{order,tap}". To remove a little clutter, the 0 and 17 ticks have been erased.

Upon the creation of the absolute median graphs, anyone who wasn't there to run the program can see which PAs may be broken. Feel free to forget about the from broken PAs while adjusting the Y axis limits, as their bars may dwarf that of working boards. 

## Data Compilation
At some point, you will have run as many tests as possible on all signal types and boards at your disposal. Now it is time to compile the data. What we did was make two sets of massive matrices: one containing all coefficients taken from the 7th order, 4 tap tables, and one that only contained the data from those tables of PAs that weren't broken. Each matrix was based on a signal type. To guide yourself among what may hundreds of rows, make anaccompanying document a guide to point out which row numbers correspond to which specific PA. If all boards were arranged in the same order for all signal types, the list can be standard for all signal types as well. 

With these "master" matrices we also created two sets of statistics matrices that contained the median, mean, standard deviation, 5th, and 95th percentiles of each coefficient from a corresponding master matrix. To visualize these results, we created error bar graphs that contained the median and standard deviation from raw data and the clean data for comparison. 

![error](https://raw.githubusercontent.com/aeg0121/PA-Modeling/master/Results/ofdm%205mhz%20error%20plot.png "Error Bar Graph")

As you can see, the differences in variance can be stark, and demonstrate how much the broken PAs can skew values. 

## Troubleshooting

Issue: I have some error where nodes with a certain ID aren't responding

Answer: Try turning the board on

Issue: By the graph results after running Main, the board looks broken, but the constellation is a little more contained, and the NMSE isn't too bad

Answer: Attatch the coaxials. 
