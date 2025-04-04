# -*- coding: utf-8 -*-
"""Simulation_python.ipynb

Automatically generated by Colab.

Original file is located at
    https://colab.research.google.com/drive/1WdDN6zGRPoPBTOFurKYAIxwLahx0fSti
"""

# For Visualising the input and output

import matplotlib.pyplot as plt
import numpy as np

# Read data from the text file
try:
    input = np.loadtxt('test_data3.txt', dtype=int)
except FileNotFoundError:
    print("Error: 'input_data.txt' not found. Please ensure the file exists in the current directory.")
    exit()

try:
    output = np.loadtxt('test_data3_ouptut.txt', dtype=int)
except FileNotFoundError:
    print("Error: 'input_data.txt' not found. Please ensure the file exists in the current directory.")
    exit()

# Plotting

plt.figure(figsize=(10, 10))

plt.subplot(2, 1, 1)  # 2 rows, 1 column, first subplot
plt.plot(output[:2000] / 10000000)
plt.xlabel('Sample')
plt.ylabel('Amplitude')
plt.title('Output Data')
plt.grid(True)

plt.subplot(2, 1, 2)  # 2 rows, 1 column, second subplot
plt.plot(input[:2000] / 100)
plt.xlabel('Sample')
plt.ylabel('Amplitude')
plt.title('Input Data')
plt.grid(True)

plt.tight_layout()  # Adjusts subplot parameters for a tight layout
plt.show()

import scipy.io
import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import convolve
import time

# Load the .mat file
first_column = input

# Define the coefficients (replace with your actual coefficients)
coefficients = np.array([   28.,   224.,    47.,    30.,   -31.,   -87.,  -118.,  -104.,   -43.,
         46.,   132.,   176.,   153.,    63.,   -67.,  -190.,  -251.,  -217.,
        -88.,    95.,   265.,   349.,   300.,   122.,  -130.,  -361.,  -474.,
       -407.,  -165.,   175.,   486.,   637.,   546.,   221.,  -234.,  -652.,
       -855.,  -733.,  -297.,   316.,   880.,  1157.,   997.,   406.,  -434.,
      -1216., -1612., -1402.,  -577.,   625.,  1776.,  2396.,  2126.,   897.,
       -999., -2945., -4152., -3897., -1767.,  2168.,  7322., 12701., 17152.,
      19670., 19670., 17152., 12701.,  7322.,  2168., -1767., -3897., -4152.,
      -2945.,  -999.,   897.,  2126.,  2396.,  1776.,   625.,  -577., -1402.,
      -1612., -1216.,  -434.,   406.,   997.,  1157.,   880.,   316.,  -297.,
       -733.,  -855.,  -652.,  -234.,   221.,   546.,   637.,   486.,   175.,
       -165.,  -407.,  -474.,  -361.,  -130.,   122.,   300.,   349.,   265.,
         95.,   -88.,  -217.,  -251.,  -190.,   -67.,    63.,   153.,   176.,
        132.,    46.,   -43.,  -104.,  -118.,   -87.,   -31.,    30.,    47.,
        224.,    28.])

# Convolve the first column with the coefficients

start_time = time.time()  # Record start time

# Your code block
total_time = 0
for i in range(100):

  convolved_signal = convolve(first_column, coefficients/100000, mode='same')

  end_time = time.time()  # Record end time

  execution_time = end_time - start_time  # Calculate execution time

  total_time += execution_time

print(f"Average execution time: {total_time/100:.6f} seconds")


# Plot the first /10 of the original and convolved signals
plt.figure(figsize=(12, 6))
#plt.plot(first_column[:len(first_column)//10], label='Original Signal')
plt.plot(convolved_signal[:len(convolved_signal)//10], label='Convolved Signal')
plt.xlabel('Sample')
plt.ylabel('Amplitude')
plt.title('Original and Convolved Signals (First /10)')
plt.legend()
plt.grid(True)
plt.show()

print(convolved_signal)

ip_size = np.size(input)

clock_period = 2e-8

time_taken = ip_size * clock_period

print(time_taken)