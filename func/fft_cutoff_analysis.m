%fft_cutoff_analysis.m
function [filtered_data, fund_freq, amp_mod SNR] = fft_cutoff_analysis(data, dt, cut_off, use_low_pass_filter)
global hspd1 hspd2 y2 conjugate y filtered_data2 y3



fs = 1/dt;
x=data;

m  = length(x);          % Window length
n = pow2(nextpow2(m));  % Transform length  (results in wrong freq for inverse)
n=m;    %correct freq for inverse
y = fft(x,n);           % DFT


df = 1/(dt*n);
energy_x = sum(x.*conj(x) * dt);
energy_y = sum(y*dt.*conj(y*dt) * df);

f = (0:n-1)*(fs/n);     % Frequency range
power = y.*conj(y)/n;   % Power of the DF

% y_temp = y(1:end/2);
% y4 = [y_temp ;fliplr(y_temp)];

% cut_off = 125000;
f_index = find(f>cut_off);
if isempty(f_index)
    f_index = cut_off;
else
    f_index = f_index(1);
end
% y2 = [y4(1:f_index); zeros(length(y4)-f_index,1)];
y2 = [y(1:f_index); zeros(length(y)-f_index,1)];
len = length(y2);
% for i = 1:len
%     conjugate(i) = y2(i) - conj(y2(mod(len-i+1,len)+1));
% end
power2 = y2.*conj(y2)/n;   % Power of the DF
energy_y2 = sum(y2*dt.*conj(y2*dt) * df);
factor = energy_y2/energy_y;



filtered_data = ifft(y2,n,'symmetric');
temp = flipud(y2(2:(end/2)+1));
y3 = [y2(1:end/2); conj(temp)];
filtered_data2 = ifft(y3,n);


%----own fft code------
% temp_t = linspace(0,4*pi,1024); temp_data = cos(2*temp_t);
% y = fft(temp_data,length(temp_data));
% N = length(y);
% test_ifft = zeros(N,1);
% for i = 0:N-1
%     for k = 0:N/2
%         if k == 0
%             rex = real(y(k+1))/(N);
%         elseif k == N/2
%             rex = real(y(k+1))/(N);
%         else
%             rex = real(y(k+1))/(N/2);
%         end
%         imx = -imag(y(k+1))/(N/2);
%         test_ifft(i+1) = test_ifft(i+1) + rex*cos(2*pi*k*i/N) + imx*sin(2*pi*k*i/N);
%
%     end
% %     if mod(i,1000) == 0
% %         disp(i)
% %     end
% end
% filtered_data = ifft(y,N,'symmetric');
% figure;plot(temp_t,temp_data,temp_t,test_ifft,'bs', temp_t, filtered_data, 'r+')


if use_low_pass_filter == 1
    %     nFs = 3125000;
    nFs = 125000;
    
    %-------- low pass filter IIR butterworth-------
    nlowpass = cut_off;
    nlowpass/(double(nFs))*.9999
    %     [b,a] = butter(1,nlowpass/(double(nFs)/2),'low'); %(3rd order(arbitrary) butterworth low pass filter (original)
    [b,a] = butter(1,nlowpass/(double(nFs))*.9999,'low'); %(3rd order(arbitrary) butterworth low pass filter
    
    sig = filtfilt(b,a,data); %zero phase digital filtering (both forward and backward directions)
    filtered_data = sig;
    %
    
    %--------FIR low pass filter -----------
    
    %     % n = 129;
    %     % f = [0 0.3 0.5 0.7 0.9 1];
    %     % a = [0 0.5 0 1 0];
    %     % up = [0.005 0.51 0.03 1.02 0.05];
    %     % lo = [-0.005 0.49 -0.03 0.98 -0.05];
    %     % h = fircls(n,f,a,up,lo);
    %     wn = cut_off/nFs;
    %     h=fir1(round(3.3/(cut_off/nFs*1.1)),wn);    %first coefficient is order of filter. for hanning window = 3.3/normalized transition width
    %     filtered_data = filter(h,1,data);
end

filtered_data(filtered_data<0)=0;       %make all negative values zero



noise_level = 1e-5;

% if cut_off== 3124950
% if cut_off== 125000
%     figure
%     % % % semilogy(f(1:end/2),power2(1:end/2))
%     % semilogy(f,power2)
%     
%     semilogx(f(1:end/2),10*log10(power2(1:end/2)))
% %     semilogx(f(1:end/2),power2(1:end/2))
%     
% %     plot(f(1:end/2),10*log10(power2(1:end/2)))
%     
%     line([.1 f(end/2)], [10*log10(noise_level) 10*log10(noise_level)], 'Color', 'r')
%     line([.1 f(end/2)], [10*log10(noise_level)+30 10*log10(noise_level)+30], 'Color', 'g')
%     axis([1 1e5 -100 20])
% %     %
% %     % xlabel('Frequency (Hz)')
% %     % ylabel('Power')
% %     % title('{\bf Periodogram}')
% %     figure
% %     Hs=spectrum.periodogram;
% %     % % hspd2 =
% %     psd(Hs,x,'Fs',fs);
% %     % % amp_mod = (maxi-mini)/(maxi+mini)
% end

t = 0:dt:n*dt-dt;
[power3, power3i]=sort(power2(1:end), 'descend');   %exclude DC (freq=0)
% [temp, temp_index] = max(power2(2:end));    %exclude DC (freq=0)
% [temp, temp_index] = max(power2);    %exclude DC (freq=0)


fund_freq = f(power3i(2));
fund_freq_level = power3(1);


% fund_freq = f(power3i(2));
dum=1;
while fund_freq > 125000/2*.95
    dum = dum+1;
    fund_freq = f(power3i(dum));
    fund_freq_level = power3(dum);
end

% fund_freq
% fund_freq_level
% power2(1)
SNR = 10*log10(fund_freq_level/noise_level);


% % dum
% % power3(1:6)
% f(power3i(1:6))



% figure
% plot(t,x)
% hold on
% plot(t,filtered_data,'g')


len = length(filtered_data);
maxf = max(filtered_data(round(len*.25):round(len*.75)));
minf = min(filtered_data(round(len*.25):round(len*.75)));
amp_mod = (maxf-minf)/(maxf+minf);