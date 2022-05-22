# See https://witestlab.poly.edu/~ffund/el9043/labs/lab1.html
import matplotlib.pyplot as plt
import numpy as np

# Read in data that has been stored as complex64 I/Q data
data = np.fromfile("./chal00_250ksps.fc32", dtype="complex64")

# Plot the spectogram of this data
plt.specgram(data, NFFT=1024, Fs=1000000)
plt.title("Spectogram of Loaded I/Q Data")
plt.xlabel("Time")
plt.ylabel("Frequency")
plt.show()
