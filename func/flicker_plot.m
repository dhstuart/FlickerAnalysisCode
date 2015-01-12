% flicker_plot.m
function flicker_plot(t, data, name, metrics)

SNR_limit = 30;
% if dim ==0
    figure
%     freqIndex = 3; %200 hz
% else
%     figure('Position', [1 1 1920*.9 1080*.9])       %set window size to little smaller than HD
%     freqIndex = 1:length(cut_off)-2;
% end
% for freq = freqIndex
%     if dim == 1
%         subplot(2,4,freq)
%     end
    hold all
    plot(t-t(1),data,'Color',[0 0 1]); %plot middle of data to avoid plotting edge effects
    line([0 t(end)-t(1)],[metrics.averageLevel metrics.averageLevel],'LineStyle','--', 'Color', 'r')
    xlabel('Time (s)')
    ylabel('Normalized Potential (V/V)')
    title(name)
%     title(sprintf('%s, Dimmer: %s at %d%%, Filter at %d Hz', model, dimmer_type, dim_level, cut_off(freq)), 'FontSize', 10)
    
    filt_fund_freq = sprintf('%0.0f',metrics.fundFreqFilt);
    unfilt_fund_freq = sprintf('%0.0f',metrics.fundFreqUnfilt);
%     if metrics.SNRFilt <SNR_limit
%         filt_fund_freq = [filt_fund_freq '*'];
%     end
%     if metrics.SNRUnfilt < SNR_limit
%         unfilt_fund_freq = [unfilt_fund_freq '*'];
%     end
    
    hold on
%     if dim == 0
        axis square
%         fill([0 0 0.026 0.026],[1.05 1.35 1.35 1.05], 'w')% %use this for original flicker data
                fill([0 0 0.018 0.018],[1.05 1.35 1.35 1.05], 'w')% %use this for original flicker data

        text(0.0003,1.20,{sprintf('percent flicker %0.2f',metrics.percentFlicker) sprintf('flicker index %0.2f',metrics.flickerIndex) ['filt. fund. freq. ' filt_fund_freq] ['unfilt. fund. freq. ' unfilt_fund_freq]}, 'FontSize', 12) % original flicker data
                            axis([0, .04, 0, 1.35]);
%     else
%         fill([0 0 0.026 0.026],[.92 1.2 1.2 .92], 'w')% %use this for original flicker data
%         text(0.0003,1.06,{sprintf('percent flicker %0.2f',percent_flicker_fft(freq)) sprintf('flicker index %0.2f',flicker_index_fft(freq)) ['filt. fund. freq. ' filt_fund_freq] ['unfilt. fund. freq. ' unfilt_fund_freq]}, 'FontSize', 12) % original flicker data
%         %                     axis([0, .04, 0, 1.2]);
%     end
    
    grid on
    hold off
% end

end
