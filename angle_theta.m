function [theta_sum] = angle_theta(acc_x,acc_y,acc_z, gyro_x,gyro_y,gyro_z,time_gyro,time,bias)
%% Angle theta: rotation angle of the cane

theta_sum = linspace(1,numel(time)-1,numel(time)-1);
 for t=2:numel(time)
    sum=0;
    for i=1:time(t)-1
        acc= sqrt((acc_x(i+1))^2 + (acc_y(i+1))^2 + (acc_z(i+1))^2);
        sum = sum + (time_gyro(i+1)-time_gyro(i))*(gyro_x(i+1)*acc_x(i+1)+gyro_y(i+1)*acc_y(i+1)+gyro_z(i+1)*acc_z(i+1))/acc;
    end
    theta_sum(t) = (sum*180/pi) - t*bias ;
 end
end

