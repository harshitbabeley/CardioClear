# CardioClear
Low-Pass FIR Filter for Real-Time ECG Denoising Using Verilog for Hardware Implementation.
You can find the Verilog code for the tree-based architecture for the convolution of FIR Low-Pass Filter coefficients with the input ECG signal contaminated with EMG and other noises. 
The dataset and test data are also available with a verified testbench.
You can get a visual representation of the data using Python. Code for the same is provided in the simulation.

### NOTE: Scale and truncate the floating values to convert them into integers for Verilog testing. The values of coefficients are scaled to 100000 and the test values by a factor of 100. Finally, for simulation, the output data is scaled down by 10000000. This ensures maximum accuracy during the signal processing by the Verilog testbench.
