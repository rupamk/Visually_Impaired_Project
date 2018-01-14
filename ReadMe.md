# Modelling cane motion used by Visually Impaired

A visually impaired person sweeps a cane to probe the environment for
finding out any obstacle in the vicinity. We want to model the cane motion. 
The cane is attached with an IMU sensor. When the cane rotates, it
undergoes two motion. The rotational motion of the cane and another
motion induced due to the user moving forward while rotating the cane.
This code separates the two components and depicts the variation of each
independent component in two different graphs. "Angle phi" is the
inclination angle of the cane w.r.t. the gravity vector/the user. "Angle theta"
is the rotational angle of the cane.

Running Instruction:

1. Typically IMU information can be collected via smartphone. To setup:

Follow instructions https:

	a. Android: //www.mathworks.com/help/supportpkg/mobilesensor/ug/set-up-and-connect-to-android-device.html
	b. IOS : https://www.mathworks.com/hardware-support/iphone-sensor.html

2. After installing the softwares, you can download codes from MATLAB to record IMU sensor data. Or you can use my
code "Saving_sensors.m" to record. 

Note: For connecting the smartphone to your laptop/desktop where you are going to log your sensors, you cannot use
a standard WiFi access point (it will block the connection). Either use a dummy access point of yours or connect via
another smartphone's hotspot (Tethering).

Note: If you use my code "Saving_sensors.m" to log the sensor data, it will usually ask for an user input about the timespan for
recording. The input is considered in "SECONDS". So if you want to log it for 1 min, provide input as "60"


3. After the data has been collected and stored, run "gyroscope_corr.m" to break down in two components.
