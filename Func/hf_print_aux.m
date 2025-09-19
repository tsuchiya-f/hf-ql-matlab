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
    
    %--- common parameters ---
    % Unique ID
    fprintf('Unique ID           %04x\n', st_aux.unique_id);
    % HF header size
    fprintf('HF header size        %d\n', st_aux.hf_hdr_len);
    % Channel select
    fprintf('Channel select X/Y/Z  %d/%d/%d\n', st_aux.xch_sel, st_aux.ych_sel, st_aux.zch_sel);
    fprintf('Cal signal enable     %d\n', st_aux.cal_ena);
    fprintf('temp RWI1/RWI2/HF       %6.1f/%6.1f/%6.1f\n', st_aux.temp_rwi_a, st_aux.temp_rwi_b, st_aux.temp_hf);
 
    switch sid
        
        case {st_ctl.sid_raw, st_ctl.sid_full, st_ctl.sid_burst_r, st_ctl.sid_burst_s, st_ctl.sid_pssr1_r, st_ctl.sid_pssr1_s}
            % Sweep table ID
            fprintf('Sweep table ID        %02x\n', st_aux.sweep_table_id);
            % TLM format
            fprintf('Select Power/Complex/Rich  %d/%d/%d\n', st_aux.power_sel, st_aux.complex_sel, st_aux.rich_exist);
            fprintf('BG sub/sel/dnlink %d/%d/%d\n', st_aux.bg_subtract,st_aux.bg_select,st_aux.bg_downlink);
            fprintf('FFT window        %d\n', st_aux.fft_win);
            fprintf('RFI rejection     %d\n', st_aux.rfi_rej_sw);
            fprintf('Pol sep threshold %d\n', st_aux.pol_sep_th);
            fprintf('Pol sep select    %d\n', st_aux.pol_sel);
%            fprintf('OVF status X/Y/Z  %d/%d/%d\n', st_aux.ovf_stat_x,st_aux.ovf_stat_y,st_aux.ovf_stat_z);
            fprintf('RFI param 0/2/3/4 %d/%d/%d/%d\n', st_aux.rfi_param0, st_aux.rfi_param1, st_aux.rfi_param2, st_aux.rfi_param3);
            fprintf('Num block         %d\n', st_aux.n_block);
                            
        case {st_ctl.sid_pssr2_s, st_ctl.sid_pssr2_r}
            fprintf('FFT window        %d\n', st_aux.fft_win);
            fprintf('RFI rejection     %d\n', st_aux.rfi_rej_sw);
            fprintf('Number of lag     %d\n', st_aux.n_lag);
        
        case {st_ctl.sid_pssr3_s,  st_ctl.sid_pssr3_r}
            fprintf('Number of block   %d\n', st_aux.n_block);
            fprintf('Number of lag     %d\n', st_aux.n_lag);
            fprintf('Freq Hi       0x%04x\n', st_aux.freq_hi);
            fprintf('Freq Lo       0x%04x\n', st_aux.freq_lo);
            fprintf('Center freq (kHz) %d\n', st_aux.center_freq);
            fprintf('Send reg          %d\n', st_aux.send_reg);
            fprintf('Skip reg          %d\n', st_aux.skip_reg);
    end
    fprintf('---------------------------------------------------------\n');
   
end