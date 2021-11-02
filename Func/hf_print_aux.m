function ret = hf_print_aux(sid, st_aux, st_ctl)

    persistent n;

    ret = 0;

    if isempty(n)
        n = 0;
    end
    n = n+1;
    
    fprintf('---------- AUX number of reception : %3d ----------------\n', n);
    
    % skip for Ver.1 SW
    if st_ctl.ver == 1.0
        return
    end
    
    switch sid
        
        % Raw data (sweep data for test purpose)
        case {st_ctl.sid_raw, st_ctl.sid_full}
            % HF header size
            fprintf('HF header size        %d\n', st_aux.hf_hdr_len);
            % Channel select
            fprintf('Channel select X/Y/Z  %d/%d/%d\n', st_aux.xch_sel, st_aux.ych_sel, st_aux.zch_sel);
            fprintf('Cal signal enable     %d\n', st_aux.cal_ena);
            % Sweep table ID
            fprintf('Sweep table ID        %02x\n', st_aux.sweep_table_id);
            % TLM format
            fprintf('Power select      %d\n', st_aux.power_sel);
            fprintf('Complex select    %d\n', st_aux.complex_sel);
            fprintf('BG sub/sel/dnlink %d/%d/%d\n', st_aux.bg_subtract,st_aux.bg_select,st_aux.bg_downlink);
            fprintf('FFT window        %d\n', st_aux.fft_win);
            fprintf('RFI rejection     %d\n', st_aux.rfi_rej_sw);
            fprintf('Pol sep threshold %d\n', st_aux.pol_sep_th);
            fprintf('Pol sep select    %d\n', st_aux.pol_sel);
            fprintf('OVF status X/Y/Z  %d/%d/%d\n', st_aux.ovf_stat_x,st_aux.ovf_stat_y,st_aux.ovf_stat_z);
            fprintf('RFI param 0/2/3/4 %d/%d/%d/%d\n', st_aux.rfi_param0, st_aux.rfi_param1, st_aux.rfi_param2, st_aux.rfi_param3);
            fprintf('temp A/B/HF       %6.1f/%6.1f/%6.1f\n', st_aux.temp_rwi_a, st_aux.temp_rwi_b, st_aux.temp_hf);
            
        case st_ctl.sid_burst_s   % Radio burst, survey data
            fprintf('temp A/B/HF       %6.1f/%6.1f/%6.1f\n', st_aux.temp_rwi_a, st_aux.temp_rwi_b, st_aux.temp_hf);
        
        case st_ctl.sid_pssr1_s   % PSSR1, survey data
            % HF header size
            fprintf('HF header size        %d\n', st_aux.hf_hdr_len);
            % Channel select
            fprintf('Channel select X/Y/Z  %d/%d/%d\n', st_aux.xch_sel, st_aux.ych_sel, st_aux.zch_sel);
            fprintf('Cal signal enable     %d\n', st_aux.cal_ena);

            fprintf('start/stop freq [kHz] %d/%d\n', st_aux.start_freq, st_aux.stop_freq);
            fprintf('sweep step            %d\n', st_aux.sweep_step);
            fprintf('temp A/B/HF       %6.1f/%6.1f/%6.1f\n', st_aux.temp_rwi_a, st_aux.temp_rwi_b, st_aux.temp_hf);
        
        case st_ctl.sid_pssr2_s   % PSSR2, survey data
            % HF header size
            fprintf('HF header size        %d\n', st_aux.hf_hdr_len);
            % Channel select
            fprintf('Channel select X/Y/Z  %d/%d/%d\n', st_aux.xch_sel, st_aux.ych_sel, st_aux.zch_sel);
            fprintf('Data number     %d\n', st_aux.n_sample);

            fprintf('start/stop freq [kHz] %d/%d\n', st_aux.start_freq, st_aux.stop_freq);
            fprintf('sweep step            %d\n', st_aux.sweep_step);
            fprintf('temp A/B/HF       %6.1f/%6.1f/%6.1f\n', st_aux.temp_rwi_a, st_aux.temp_rwi_b, st_aux.temp_hf);
        
        case st_ctl.sid_pssr2_r   % PSSR2, rich data
            % HF header size
            fprintf('HF header size        %d\n', st_aux.hf_hdr_len);
            % Channel select
            fprintf('Channel select X/Y/Z  %d/%d/%d\n', st_aux.xch_sel, st_aux.ych_sel, st_aux.zch_sel);
            fprintf('Data number     %d\n', st_aux.n_sample);

%            fprintf('start/stop freq [kHz] %d/%d\n', st_aux.start_freq, st_aux.stop_freq);
            fprintf('sweep step            %d\n', st_aux.sweep_step);
        
        case st_ctl.sid_pssr3_s   % PSSR3, survey data
            fprintf('temp A/B/HF       %6.1f/%6.1f/%6.1f\n', st_aux.temp_rwi_a, st_aux.temp_rwi_b, st_aux.temp_hf);

        case st_ctl.sid_burst_r   % Radio burst, rich data
        
        case st_ctl.sid_pssr1_r   % PSSR1, rich data
            
        case st_ctl.sid_pssr2_r   % PSSR2, rich data
        
        case st_ctl.sid_pssr3_r   % PSSR3, rich data

    end
    fprintf('---------------------------------------------------------\n');
   
end