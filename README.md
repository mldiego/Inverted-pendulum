# Inverted-pendulum
Modeling and simulation of various types of a closed-loop inverted pendulum system

The parameters of the initial controller (the K-controller) and the linearized plant are obtained from the following repository https://github.com/ttj/invpend .

To run the simulations, collect data, and train a neural network controller and plent, we need to run the Collect_data_sim.m

The other 4 files are closed loop simulink models. 
	- ClosedLoop_Kcont.slx.  This file has the original plant and controller.
	- ClosedLoop_wNNcont.slx  Here I substitute the original controller for a neural network controller.
	- ClosedLoop_wNNplant.slx  From the original system, I susbtitute the the original plant by a neural network plant (More work to do, this still does not work).
	- ClosedLoop_wallNN.slx  I changed the original controller and plant for a neural network plant and a neural network controller (Closed loop simulation does not work, further work to do on this).