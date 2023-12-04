%This function feeds all your deltaF/F traces in dff variable through
%T_star_loop, outputting a list of TStars

T_star_temps = [];
total_dff_amps = [];

for i = 1:length(dff(1,:))
    
    T_star_temp = [];
    
    Image_Time = 1:length(Temperature);
    raw_temperature = Temperature;

    steep_points = [];             % This is the important part for finding the first 
    time_steep = [];               % sustained increase in the del_F signal.
    increasing = [];
    del_F = [];
    diff_del_F = [];
    
    %see function T_star_loop
    [T_star_temp,total_dff_amp] = T_star_loop(Image_Time,raw_temperature,dff(:,i));
    
    T_star_temps(i) = T_star_temp;
    total_dff_amps(i) = total_dff_amp;
    
end
 
average_t_star = mean(T_star_temps)
save analysis