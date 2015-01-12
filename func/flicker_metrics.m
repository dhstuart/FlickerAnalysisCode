function [average_level, flicker_index, percent_flicker] = flicker_metrics(t, data) 

total_area = trapz(t,data);
average_level = total_area/(t(end)-t(1));
points_above_curve = (data-average_level).*((data>average_level));
area_above_mean = trapz(t,points_above_curve);
flicker_index = area_above_mean/total_area;

maximum = max(data);

minimum = min(data);
percent_flicker = (maximum-minimum)/(maximum+minimum)*100;