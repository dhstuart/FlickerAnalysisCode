%-----------------------VERSION NOTES---------------------------------
% v20 - v19 didn't correctly normalize to full output. v20 fixes this
%       *removed write to excel functionality. Wasn't using this anymore

% need versatility to consider lamps that are not dimmed
% In this case, need to ouput single plot at 200Hz and in PNG format

function flicker_process_data(dim)

clc
% clear all
close all

current_path = pwd;
addpath([pwd '/func']);
addpath([pwd '/lib']);
addpath([pwd '/lib/export_fig']);

global y y2 filtered_data2 y3

warning('off','MATLAB:hg:ColorSpec_None')       %turn off warning for transparency in charts

record_lengths = [1];
frequency_choice = [];
cut_off = [60 120 200 240 300 500 1000 3000 10000  125000];
%-----------------------
plots_on = 1;
create_pivot_table = 1;
printPlot = 0;
%------------------------------

flicker_metric_array = [];
cut_off_analysis_percent_flicker = [];
cut_off_analysis_flicker_index = [];
cut_off_analysis_fund_freq = [];
amp_mod_mat = [];
flicker_index_mat = [];
fund_freq_mat = [];
SNR_limit = 30;


%% --------------- find file names and paths ----------------
% data_path = 'C:\Users\dhstuart\Documents\Energy Star Flicker Data\JST LuxPAR Flicker';
% data_path = 'C:\Users\dhstuart\Documents\Energy Star Flicker Data\test data';
% data_path = 'C:\Users\dhstuart\Documents\Energy Star Flicker Data\cree2x2';
% data_path = 'C:\Users\dhstuart\Documents\Energy Star Flicker Data\JST Cree Flicker';
data_path = uigetdir(' ','Select top directory of files to procecss');

if dim == 0
    list=dir(data_path);
    fls={list(~[list.isdir]).name};
    file_indices = ~cellfun(@isempty,regexpi(fls, '\w+(?=_light.csv)'));    %find which files are the light files
    file_cell = fls(file_indices);
    fls = fls(file_indices);
else
    [subs,fls] = subdir(data_path);
end

dum2 = 0;
%% -------------------- open and process files ------------------------

for i= 1:length(fls)
    norm_level = 0;
    
    if dim == 0
        itterateOver = 1;
    else
        file_indices = ~cellfun(@isempty,regexpi(fls{i}, '\w+(?=_light.csv)'));    %find which files are the light files
        file_cell = fls{i}(file_indices);                       %only consider "light" files
        itterateOver = size(file_cell,2):-1:1;     %start at 100% dim for normalization and step down
    end
    
    disp('----------------------------------------------------')
    for j = itterateOver
        if dim == 0
            pathOpen = [data_path '\' file_cell{i}];
        else
            pathOpen = [subs{i} '\' file_cell{j}];
        end
        
        fid1 = fopen(pathOpen);
        temp = textscan(fid1,'%s','delimiter','\n');
        fclose(fid1);
        temp2 = regexpi(temp{1,1},',','split');
        temp3=vertcat(temp2{3:end});
        header_titles = temp2{1};
        header_data = temp2{2};
        data = cellfun(@str2num,temp3);
        
        %------- collect data from header -------------
        dt = str2num(header_data{strcmp(header_titles,'dt')});
        model = header_data{strcmp(header_titles,'model')};
        dim_level = str2num(header_data{strcmp(header_titles,'dim level')});
        dimmer_type = header_data{strcmp(header_titles,'dimmer type')};
        
        disp(['MODEL: ' model '     DIMMER TYPE: ' dimmer_type '     DIM LEVEL: ' num2str(dim_level)])
        subplot_index = 1;
        
        t = 0:dt:dt*(length(data)-1);
        norm_index = length(cut_off)-1;%-8;
        norm_loop = 1;
        
        for freq =[norm_index 1:length(cut_off)]
            
            [filtered_data{freq}, fund_freq(freq), amp_mod(freq) SNR(freq)] = fft_cutoff_analysis(data, dt, cut_off(freq),0);   %last argument is method, 0 is fft/ifft
            
            filtered_data_intwav{freq} = filtered_data{freq};
            t_filtered_data_intwav{freq} = t;
            
            if norm_level == 0 && freq == norm_index
                norm_level = max(filtered_data_intwav{freq});
                norm_loop = 0;
            elseif norm_loop == 1
                norm_loop = 0;
            elseif norm_loop == 0;
                
                [average_level_fft(freq)  flicker_index_fft(freq) percent_flicker_fft(freq)] = flicker_metrics(t_filtered_data_intwav{freq}, filtered_data_intwav{freq}/norm_level);
                %                     local_percent_flicker{model_index,dim_level_index,freq,:} = percent_flicker_variation(t,filtered_data{freq});
%                 out = percent_flicker_variation(t,filtered_data{freq},fund_freq(freq));
                
                dum2 = dum2+1;
                a(dum2).model = model;
                a(dum2).dim_level = dim_level;
                a(dum2).duration = t(end)-t(1)+dt;
                a(dum2).dt = dt;
                a(dum2).dimming_hardware = dimmer_type;
                a(dum2).cutoff = cut_off(freq);
                a(dum2).fundamental_frequency = fund_freq(freq);
%                 a(dum2).percent_flicker_max = out(1);
%                 a(dum2).percent_flicker_avg = out(2);
                a(dum2).percent_flicker = percent_flicker_fft(freq);
                a(dum2).flicker_index = flicker_index_fft(freq);
%                 a(dum2).max = out(3)/norm_level;
            end
        end
        
        %% ---------------------------------------- PLOTS -----------------------------------------------
        if plots_on ==1
            if dim ==0
                figure
                freqIndex = 3; %200 hz
            else
                figure('Position', [1 1 1920*.9 1080*.9])       %set window size to little smaller than HD
                freqIndex = 1:length(cut_off)-2;
            end
            for freq = freqIndex
                if dim == 1
                    subplot(2,4,freq)
                end
                hold all
                plot(t_filtered_data_intwav{freq}-t_filtered_data_intwav{freq}(1),filtered_data_intwav{freq}/norm_level,'Color',[0 0 1])
                line([0 t_filtered_data_intwav{freq}(end)-t_filtered_data_intwav{freq}(1)],[average_level_fft(freq) average_level_fft(freq)],'LineStyle','--', 'Color', 'r')
                xlabel('time (s)')
                ylabel('normalized potential (v/v)')
                title(sprintf('%s, Dimmer: %s at %d%%, Filter at %d Hz', model, dimmer_type, dim_level, cut_off(freq)), 'FontSize', 10)
                
                filt_fund_freq = sprintf('%0.0f',fund_freq(freq));
                unfilt_fund_freq = sprintf('%0.0f',fund_freq(10));
                if SNR(freq) <SNR_limit
                    filt_fund_freq = [filt_fund_freq '*'];
                end
                if SNR(10) < SNR_limit
                    unfilt_fund_freq = [unfilt_fund_freq '*'];
                end
                
                hold on
                if dim == 0
                    axis square
                    fill([0 0 0.026 0.026],[1.05 1.35 1.35 1.05], 'w')% %use this for original flicker data
                    text(0.0003,1.20,{sprintf('percent flicker %0.2f',percent_flicker_fft(freq)) sprintf('flicker index %0.2f',flicker_index_fft(freq)) ['filt. fund. freq. ' filt_fund_freq] ['unfilt. fund. freq. ' unfilt_fund_freq]}, 'FontSize', 12) % original flicker data
%                     axis([0, .04, 0, 1.35]);
                else
                    fill([0 0 0.026 0.026],[.92 1.2 1.2 .92], 'w')% %use this for original flicker data
                    text(0.0003,1.06,{sprintf('percent flicker %0.2f',percent_flicker_fft(freq)) sprintf('flicker index %0.2f',flicker_index_fft(freq)) ['filt. fund. freq. ' filt_fund_freq] ['unfilt. fund. freq. ' unfilt_fund_freq]}, 'FontSize', 12) % original flicker data
%                     axis([0, .04, 0, 1.2]);
                end
                
                grid on
                hold off
            end
            if printPlot == 1
                cd(data_path)
                if dim == 0
                    opts = struct('height', 9/2.54, 'width',  9/2.54);
                    set(gcf,'Color','none');
                    export_fig(gcf,sprintf('%s_%s_%03d.png',model, dimmer_type, dim_level),opts);
                    
                else
                    export_fig(gcf,sprintf('%s_%s_%03d.png',model, dimmer_type, dim_level));
                end
                   close(gcf)
            end
        end
    end
end
%% -----------creat pivot table----------
if create_pivot_table == 1
    cd(data_path)
    header = fieldnames(a(1))';
    outputForPivotTable = [header ;struct2cell(a')'];
    cell2csv(sprintf('%s_%s_%03d_for_pivot.csv',model, dimmer_type, dim_level),outputForPivotTable)
end
