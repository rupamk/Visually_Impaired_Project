%% Author: Rupam Kundu
% The Ohio State University
% A visually impaired person sweeps a cane to probe the environment for
% finding out any obstacle in the vicinity. We want to model the cane motion. 
% The cane is attached with an IMU sensor. When the cane rotates, it
% undergoes two motion. The rotational motion of the cane and another
% motion induced due to the user moving forward while rotating the cane.
% This code separates the two components and depicts the variation of each
% independent component in two different graphs. "Angle phi" is the
% inclination angle of the cane w.r.t. the gravity vector/the user. "Angle theta"
% is the rotational angle of the cane.

clear ALL
clc
close ALL
%% Inputs
% Usually IMUs have a bias. The value mentioned is measured in our device.
bias=-0.08075; 
% Open the experiment file
filename='trajectory_exp_5.csv';

% Read the file
fid = fopen(filename);
HDRS = textscan(fid,'%s %s %s %s %s %s %s %s',1, 'delimiter',',');
DATA = textscan(fid,'%f %f %f %f %f %f %f %f','delimiter',',');
fclose(fid);

% load data into variables
acc_x=DATA{1,1};
acc_y = DATA{1,2};
acc_z= DATA{1,3};
time_acc= DATA{1,4};
gyro_x = DATA{1,5};
gyro_y = DATA{1,6};
gyro_z = DATA{1,7};
time_gyro=DATA{1,8};
%% Plot Raw Gyroscope
start =1; 
end_v=length(gyro_x);
acc_x=acc_x(start:end_v);
acc_y = acc_y(start:end_v);
acc_z= acc_z(start:end_v);
time_acc= time_acc(start:end_v);
gyro_x = gyro_x(start:end_v);
gyro_y = gyro_y(start:end_v);
gyro_z = gyro_z(start:end_v);
time_gyro=time_gyro(start:end_v);
% 
%% Angle phi 
%angle formed between the cane and the user/gravity vector
phi = angle_phi(acc_x,acc_y,acc_z);

% Plot cane inclination angle

subplot(2,2,1);plot(time_gyro, phi,'r','LineWidth',2);
set(gca,'fontsize',16)
grid on
if(sign(mean(phi))==-1)
ylim([-90 0]);
else
ylim([0 90]);
end
xlim([0,time_gyro(end)])
xlabel('Time', 'FontSize',16)
ylabel({'Angle w.r.t' ; 'gravity vector'},'FontSize',16)
title({'Inclination angle: Angle \phi'; ' '},'FontSize',16)

%% Angle theta: rotation angle of the cane
theta_sum = angle_theta(acc_x,acc_y,acc_z, gyro_x,gyro_y,gyro_z,time_gyro,time,bias);

%% Separating the two components: 
%1. Directional component
%2. Rotational component

[theta_sum_corrected, new_drift] = break_2components(theta_sum);


%% Plot


subplot(2,2,2);plot(time_gyro, theta_sum,'b','LineWidth',2);
xlim([0,time_gyro(end)])
legend('2 comp together')
hold on
set(gca,'fontsize',16)
grid on
xlabel('Time', 'FontSize',16)
ylabel({'Rotation Angle +';' Direction'},'FontSize',16)
title({'Two components together'; ' '},'FontSize',16)
hold off


subplot(2,2,3); plot(time_gyro, (theta_sum_corrected),'r','LineWidth',2);
legend('Abs \theta variation  ')
set(gca,'fontsize',16)
xlim([0,time_gyro(end)])
grid on
xlabel('Time', 'FontSize',16)
ylabel('Rotation Angle','FontSize',16)
title({'Rotational Component: \theta'; ' '},'FontSize',16)
hold off


subplot(2,2,4);plot(linspace(0,120,length(new_drift(1:end-2))),(smooth(new_drift(1:end-2),21)),'r--','LineWidth',2); 
set(gca,'fontsize',20)
xlim([0,time_gyro(end)])
ylim([-300,0])
grid on
xlabel('Time','FontSize',16)
ylabel({'Change in'; 'Direction (degree)'},'FontSize',16)
title({'Directional Component';' '},'FontSize',16)




