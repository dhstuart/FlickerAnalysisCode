%find the percent flicker for each individual wavelength

function [out] = percent_flicker_variation(t,data, fund_freq)

nFs = 1/(t(2)-t(1));
if fund_freq < 60
    fund_freq = 300;
end
% fund_freq = 300;
nlowpass = fund_freq*1.15;

if max(data)>.008
    [b,a] = butter(1,nlowpass/(double(nFs))*.9999,'low'); %(3rd order(arbitrary) butterworth low pass filter
    
    lpf_data2 = filtfilt(b,a,data(:,1)); %get rid of noise so can find crossings  with zero phase digital filtering (both forward and backward directions)
    lpf_data2 = lpf_data2';
    
    midPoint = mean(lpf_data2);
    crossings = crossing2(t,lpf_data2,midPoint);
    % for i = 1:length(crossings)-1
    %     localMax(i) = max(data(crossings(i):crossings(i+1)));
    %     localMin(i) = min(data(crossings(i):crossings(i+1)));
    % end
    dum = 0;
%     length(crossings)
    for i = 1:2:length(crossings)-2
        dum = dum+1;
        localMax2(dum) = max(data(crossings(i):crossings(i+2)));
        localMin2(dum) = min(data(crossings(i):crossings(i+2)));
        local_percent_flicker(dum) = (localMax2(dum)-localMin2(dum))/(localMax2(dum)+localMin2(dum))*100;
    end
    
    % ----------------compare percent flicker for number of cycles averaged over ----------
    for i = 1:length(localMax2)
        temp_max(i) = max(localMax2(1:i));
        temp_min = min(localMin2(1:i));
        max_percent_flicker(i) =  (temp_max(i)-temp_min)/(temp_max(i)+temp_min)*100;
        avg_percent_flicker(i) = mean(local_percent_flicker(1:i));
    end
   
    
    mean_max = mean(localMax2);
    mean_min = mean(localMin2);
    mean_metrics = (mean_max-mean_min)/(mean_max+mean_min)*100;
%         out = [max_percent_flicker; avg_percent_flicker];
    out = [max_percent_flicker(end) avg_percent_flicker(end) mean_max];
else
    percent_flicker_max = (max(data)-min(data))/(max(data)+min(data))*100;
    if isnan(percent_flicker_max)
        percent_flicker_max = 100;
    end
    out = [percent_flicker_max percent_flicker_max max(data)];
end
% out = [local_percent_flicker;localMax2; temp_max];
% figure
% hold on
% plot(max_percent_flicker,'r')
% plot(avg_percent_flicker,'b')
% legend('max','avg')
% d_filtered_data = diff(filtered_data2);
% index = find(d_filtered_data(crossings)>0);
