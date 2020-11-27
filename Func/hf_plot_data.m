function ret = hf_plot_data(ver, st_rpw, st_aux, st_hfa, raw_data)

    ret = 0;
        
    switch st_rpw.sid
        
        case 0x42   % Raw data (sweep data for test purpose)
            fprintf('SID:%02x Sweep cycle\n', st_rpw.sid);
            [~, spec] = hf_proc_raw(ver, st_aux, st_hfa, raw_data);
            ret = hf_plot_power(spec);
        
        case 0x43   % Radio full (Nominal sweep mode)
            fprintf('SID:%02x Radio full\n', st_rpw.sid);
            [~, spec] = hf_proc_radio_full(ver, st_aux, st_hfa, raw_data);
            ret = hf_plot_power(spec);
        
        case 0x44   % Radio burst, survey data
            fprintf('SID:%02x Radio burst (survey data)\n', st_rpw.sid);
        
        case 0x45   % PSSR1, survey data
            fprintf('SID:%02x PSSR1 (survey data)\n', st_rpw.sid);
        
        case 0x46   % PSSR2, survey data
            fprintf('SID:%02x PSSR2 (survey data)\n', st_rpw.sid);
        
        case 0x47   % PSSR3, survey data
            fprintf('SID:%02x PSSR3 (survey data)\n', st_rpw.sid);
        
        case 0x74   % Radio burst, rich data
            fprintf('SID:%02x Radio burst (rich data)\n', st_rpw.sid);
        
        case 0x75   % PSSR1, rich data
            fprintf('SID:%02x PSSR1 (rich data)\n', st_rpw.sid);
            
        case 0x76   % PSSR2, rich data
            fprintf('SID:%02x PSSR2 (rich data)\n', st_rpw.sid);
        
        case 0x77   % PSSR3, rich data
            fprintf('SID:%02x PSSR3 (rich data)\n', st_rpw.sid);
            [~, wave, spec] = hf_proc_pssr3_rich(ver, st_aux, st_hfa, raw_data);
            ret = hf_plot_waveform_power(wave, spec);
%            ret = hf_plot_waveform(wave);
    end

end
