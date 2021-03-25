function ret = hf_plot_data(st_ctl, st_rpw, st_aux, st_hfa, raw_data)

    ret = 0;
        
    switch st_rpw.sid
        
        % Raw data (sweep data for test purpose)
        case st_ctl.sid_raw
            fprintf('SID:%02x Sweep cycle\n', st_rpw.sid);
            st_ctl.label = ['HF Config 0: Sweep cycle / Time elapsed : ' num2str(st_rpw.cuc_time_elapse,'%f')];
            [~, spec] = hf_proc_raw(ver, st_aux, st_hfa, raw_data);
            ret = hf_plot_power(st_ctl, spec);
            ret = hf_rpt_add_figure(st_ctl);
        
        % Radio full (Nominal sweep mode)
        case st_ctl.sid_full
            fprintf('SID:%02x Radio full\n', st_rpw.sid);
            st_ctl.label = ['HF Config 6: Radio full / Time elapsed : ' num2str(st_rpw.cuc_time_elapse,'%f')];
            [~, spec] = hf_proc_radio_full(ver, st_aux, st_hfa, raw_data);
            ret = hf_plot_power(st_ctl, spec);
            ret = hf_rpt_add_figure(st_ctl);
        
        case st_ctl.sid_burst_s   % Radio burst, survey data
            fprintf('SID:%02x Radio burst (survey data)\n', st_rpw.sid);
            st_ctl.label = ['HF Config 7: Radio burst (survey data) / Time elapsed : ' num2str(st_rpw.cuc_time_elapse,'%f')];
        
        case st_ctl.sid_pssr1_s   % PSSR1, survey data
            fprintf('SID:%02x PSSR1 (survey data)\n', st_rpw.sid);
            st_ctl.label = ['HF Config 8: PSSR1 (survey data) / Time elapsed : ' num2str(st_rpw.cuc_time_elapse,'%f')];
        
        case st_ctl.sid_pssr2_s   % PSSR2, survey data
            fprintf('SID:%02x PSSR2 (survey data)\n', st_rpw.sid);
            st_ctl.label = ['HF Config 9: PSSR2 (survey data) / Time elapsed : ' num2str(st_rpw.cuc_time_elapse,'%f')];
        
        case st_ctl.sid_pssr3_s   % PSSR3, survey data
            fprintf('SID:%02x PSSR3 (survey data)\n', st_rpw.sid);
            st_ctl.label = ['HF Config 10: PSSR3 (survey data) / Time elapsed : ' num2str(st_rpw.cuc_time_elapse,'%f')];
            [~, stream] = hf_proc_pssr3_surv(ver, st_aux, st_hfa, raw_data);
            ret = hf_plot_stream(st_ctl, stream);
            ret = hf_rpt_add_figure(st_ctl);

        case st_ctl.sid_burst_r   % Radio burst, rich data
            fprintf('SID:%02x Radio burst (rich data)\n', st_rpw.sid);
            st_ctl.label = ['HF Config 7: Radio burst (rich data) / Time elapsed : ' num2str(st_rpw.cuc_time_elapse,'%f')];
        
        case st_ctl.sid_pssr1_r   % PSSR1, rich data
            fprintf('SID:%02x PSSR1 (rich data)\n', st_rpw.sid);
            st_ctl.label = ['HF Config 8: PSSR1 (rich data) / Time elapsed : ' num2str(st_rpw.cuc_time_elapse,'%f')];
            
        case st_ctl.sid_pssr2_r   % PSSR2, rich data
            fprintf('SID:%02x PSSR2 (rich data)\n', st_rpw.sid);
            st_ctl.label = ['HF Config 9: PSSR2 (rich data) / Time elapsed : ' num2str(st_rpw.cuc_time_elapse,'%f')];
        
        case st_ctl.sid_pssr3_r   % PSSR3, rich data
            fprintf('SID:%02x PSSR3 (rich data)\n', st_rpw.sid);
            st_ctl.label = ['HF Config 10: PSSR3 (rich data) / Time elapsed : ' num2str(st_rpw.cuc_time_elapse,'%f')];
            [~, wave, spec] = hf_proc_pssr3_rich(ver, st_aux, st_hfa, raw_data);
            ret = hf_plot_waveform_power(st_ctl, wave, spec);
            ret = hf_rpt_add_figure(st_ctl);
    end

end
