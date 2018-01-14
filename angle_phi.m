function [phi] = angle_phi(acc_x,acc_y,acc_z)
%% Angle phi 
%angle formed between the cane and the user/gravity vector
time = linspace(1,numel(acc_x),numel(acc_x));
phi = linspace(1,numel(acc_x),numel(acc_x));
for i=1:length(time)
val = atan(sqrt(acc_y(i)^2 + acc_z(i)^2)/(acc_x(i)));
phi(i) = val.* 180/pi;
end
end

