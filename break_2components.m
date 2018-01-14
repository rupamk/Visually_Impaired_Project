function [theta_sum_corrected, new_drift] = break_2components(theta_sum)
% separates the two components involved in \theta and depicts the variation of each independent component

%% Finding out the peaks and filter out the noisy peaks. Peaks correspond to the two corners of the edge sweep

% detecting the jumps
[pks,in]=findpeaks(theta_sum);

new_pks=[];new_in=[];
k=1;i=1;

while(i<length(in))
    new_pks(k)=pks(i);
    new_in(k)= in(i);
    [val,b]=min(theta_sum(in(i):in(i+1)));
    new_pks(k+1)=val(1);
    new_in(k+1)= in(i)+b(1)-1;
    i=i+1; k=k+2;    
end
pks =new_pks;
in = new_in;
difference_theta =zeros(1,numel(in)-1);
for i=1:numel(in)-1
difference_theta(i)=abs(pks(i+1)-pks(i));
end

% filter out the noisy peaks
k=1;
avg_val=mean(difference_theta);
for i=1:numel(difference_theta)
     if(difference_theta(i)>avg_val)
        filtered_pks(k) = difference_theta(i);
        filtered_ind(k) = i;
        k=k+1;
    end
end

%% Separating two components
theta_sum_corrected = theta_sum; %rotational component initialized to the original
start_point = 1;
drift=zeros(1,numel(filtered_ind));
new_drift=[]; % directional component

i=1;
while(i<numel(filtered_ind))    
    temp_ind=in(filtered_ind(i));
    temp_ind_next = in(filtered_ind(i) +1);
    if(i<numel(filtered_ind)-1)
    correct_upto =in(filtered_ind(i)+1);
    else
    correct_upto =numel(theta_sum);  
    end
    drift(i)= 0.5*(theta_sum(temp_ind)+theta_sum(temp_ind_next));
    new_drift=[new_drift,drift(i)*ones(1,correct_upto-start_point)];
    % the correct range is stored and the drift is subtracted to get the
    % original variation about the zero axis
    theta_sum_corrected(start_point:correct_upto) = (theta_sum(start_point:correct_upto) - drift(i)); 
    start_point = correct_upto +1;
    i=i+1;
end

end

