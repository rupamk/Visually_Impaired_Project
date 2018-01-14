clc
clear 'ALL'
connector on 12345;  %% establish connection
exp_num=1;
prompt = 'For how much time do you want to log? ';
x = input(prompt);
%% Collecting data
m = mobiledev;
fprintf('Logging session starts...');
%% Data Collection Timiing Control
m.AccelerationSensorEnabled = 1;
m.OrientationSensorEnabled=1;
m.MagneticSensorEnabled=1;
m.AngularVelocitySensorEnabled=1;
% m.PositionSensorEnabled=1;
fprintf('Following parameters will be logged:');
disp(m); %%display the log details
%% Start acquiring data
% After enabling the sensors, the Sensors screen of MATLAB Mobile will show
% the current data measured by the sensors. The |Logging| property allows 
% you to begin sending sensor data to |mobiledev|.
m.Logging = 1;
pause(x); %% log the data for x seconds// subject to vary according to experiment

%% Stop logging data
% Use |mobiledev|'s logging property again to stop logging data. 

m.Logging = 0;

%% Retrieve logged position data
[acc, tacc] = accellog(m); %accelerometer: acc, [log, timestamp] = accellog(m) 
[o, to]= orientlog(m); %orientation: o
[ma, tma]= magfieldlog(m); %magnetic field: ma
[av, tav]=angvellog(m); %angular velocity: av
% [lat, lon, tpos, spd, course, alt, horizacc] = poslog(m); %position:

% Resample: y = resample(x,p,q) resamples the input sequence, x, at p/q times
% the original sample rate. If x is a matrix, then resample treats each column 
% of x as an independent channel. resample applies an antialiasing FIR lowpass 
% filter to x and compensates for the delay introduced by the filter.

%o=resample(o, size(tacc,1),size(to,1));
%to=resample(to,size(tacc,1),size(to,1));
%ma=resample(ma, size(tacc,1),size(tma,1));
%tma=resample(tma,size(tacc,1),size(tma,1));
av=resample(av,size(tacc,1),size(tav,1));
tav=resample(tav,size(tacc,1),size(tav,1));

%% Convert to absolute timestamps
% To convert all sensor timestamps into absolute timestamps, the
% InitialTimestamp value is converted into a |datetime| object. The
% individual sensor timestamps, which are in units of seconds, are
% converted into |seconds|. This simplifies the date arithmetic of turning
% relative timestamps into absolute timestamps.

tInit = datetime(m.InitialTimestamp, 'InputFormat', 'dd-MM-yyyy HH:mm:ss.SSS');
%tAngVel = tInit + seconds(tav);
%tOrient = tInit + seconds(to);
tAcc    = tInit + seconds(tacc);
tAv    = tInit + seconds(tav);
%tMa    = tInit + seconds(tma);
%% Saving the data in Excel
toCSV=[];
toCSVpos=[];
for i=1:size(tacc,1)
%toCSV=[toCSV; [i acc(i,1) acc(i,2) acc(i,3) tacc(i) o(i,1) o(i,2) o(i,3) to(i) ma(i,1) ma(i,2) ma(i,3) tma(i) av(i,1) av(i,2) av(i,3) tav(i)]]; 
toCSV=[toCSV; [acc(i,1) acc(i,2) acc(i,3) tacc(i) av(i,1) av(i,2) av(i,3) tav(i)]]; 

end
% for i=1:size(lat,1)
% toCSVpos=[toCSVpos; [lat(i) lon(i) tpos(i) spd(i) course(i), alt(i), horizacc(i)]];
% end


%csvwrite(filename,M) writes matrix M into filename as comma-separated values. 
%The filename input is a string enclosed in single quotes.
headers={'acc_1', 'acc_2',  'acc_3', 'tacc', 'av_1', 'av_2', 'av_3', 'tav'};
%csvwrite(sprintf('vip_%d.csv',exp_num),toCSV); 
% headers={'latitude', 'longitude', 'tpos', 'spd', 'course', 'altitudeposlog', 'horizacc'};
 csvwrite_with_headers(sprintf('trajectory_exp_%d.csv',exp_num),toCSV,headers); 

%% Plot raw sensor data
% The logged acceleration data for all three axes can be plotted together.
figure(1) 
hold on
plot(tacc,acc(:,1));
plot(tacc,acc(:,2));
plot(tacc,acc(:,3));
legend('X', 'Y', 'Z');
xlabel('Relative time (s)');
ylabel('Acceleration (m/s^2)');
%%
figure(2) 
hold on
plot(tav,av(:,1));
plot(tav,av(:,2));
plot(tav,av(:,3));
legend('X', 'Y', 'Z');
xlabel('Relative time (s)');
ylabel('Angular Velocity (m/s^2)');

%% Clean up
% Turn off the enabled sensors and clear |mobiledev|.
m.AccelerationSensorEnabled = 0;
m.OrientationSensorEnabled=0;
m.MagneticSensorEnabled=0;
m.AngularVelocitySensorEnabled=0;
m.PositionSensorEnabled=0;
clear m;
displayEndOfDemoMessage(mfilename) 