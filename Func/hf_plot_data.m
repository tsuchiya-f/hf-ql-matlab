function ret = hf_plot_data(st_ctl, st_rpw, st_aux, st_hfa, st_time, raw_data)

    ret = 0;
        
    switch st_rpw.sid
       
        % Raw data (sweep data for test purpose)
        case st_ctl.sid_raw
            fprintf('SID:%02x Sweep cycle\n', st_rpw.sid);
            st_ctl.label = ['HF Config 0: Sweep cycle / Time elapsed : ' num2str(st_time.cuc_time_elapse,'%f')];
            
            if st_ctl.raw_ver1_corrected == 1
                [ret_proc, spec] = hf_proc_raw_ver1_corrected(ver, st_ctl, st_aux, st_hfa, raw_data);
                if ret_proc == 0
                    ret = hf_plot_power(st_ctl, spec);
                    ret = hf_store_save_data(st_ctl, st_aux, st_time, spec);
                    ret = hf_rpt_add_figure(st_ctl);
                elseif ret_proc < -1
                    ret = -1;
                    return;
                end
            else
                [ret, spec, wave, spec_hres] = hf_proc_raw(ver, st_ctl, st_aux, st_hfa, raw_data);
                if ret == 0
                    ret = hf_plot_waveform(st_ctl, wave);
                    ret = hf_rpt_add_figure(st_ctl);

                    ret = hf_plot_power(st_ctl, spec);
                    ret = hf_store_save_data(st_ctl, st_aux, st_time, spec);
                    ret = hf_rpt_add_figure(st_ctl);

                    st_ctl_hres.power_unit = 'relative power [dB]';
                    st_ctl_hres.n_ch=3;
                    st_ctl_hres.hf=st_ctl.hf;
                    st_ctl_hres.xlim = [min(spec_hres.f*1e-3), max(spec_hres.f*1e-3)];
                    ret = hf_plot_power(st_ctl_hres, spec_hres);
                    ret = hf_rpt_add_figure(st_ctl);
                else
                    fprintf('   ERROR in hf_proc_raw / error ID = %d\n', ret);
                end
            end
            
        % Radio full (Nominal sweep mode)
        case st_ctl.sid_full
            fprintf('SID:%02x Radio full\n', st_rpw.sid);
            st_ctl.label = ['HF Config 6: Radio full / Time elapsed : ' num2str(st_time.cuc_time_elapse,'%f')];
            [~, spec] = hf_proc_radio_full(st_ctl, st_aux, st_hfa, raw_data);
            if spec.matrix == 0
                if st_ctl.n_ch == 3
                    ret = hf_plot_power(st_ctl, spec);
                    ret = hf_store_save_data(st_ctl, st_aux, st_time, spec);
                    ret = hf_rpt_add_figure(st_ctl);
                    
                    if st_ctl.ver > 1
                        ret = hf_plot_power_floor(st_ctl, spec);
                        ret = hf_store_save_data(st_ctl, st_aux, st_time, spec);
                        ret = hf_rpt_add_figure(st_ctl);
                    end
                else
                    ret = hf_plot_power_2ch(st_ctl, spec);
                    ret = hf_store_save_data(st_ctl, st_aux, st_time, spec);
                    ret = hf_rpt_add_figure(st_ctl);
                    
                    if st_ctl.ver > 1
                        ret = hf_plot_power_floor(st_ctl, spec);
                        ret = hf_store_save_data(st_ctl, st_aux, st_time, spec);
                        ret = hf_rpt_add_figure(st_ctl);
                    end
                end
            elseif spec.matrix == 1
                if st_ctl.n_ch == 3
                    ret = hf_plot_stokes(st_ctl, spec);
                    ret = hf_store_save_data(st_ctl, st_aux, st_time, spec);
                    ret = hf_rpt_add_figure(st_ctl);
                    
                    if st_ctl.ver > 1
                        ret = hf_plot_power_floor(st_ctl, spec);
                        ret = hf_store_save_data(st_ctl, st_aux, st_time, spec);
                        ret = hf_rpt_add_figure(st_ctl);
                    end
                else
                    ret = hf_plot_stokes_2ch(st_ctl, spec);
                    ret = hf_store_save_data(st_ctl, st_aux, st_time, spec);
                    ret = hf_rpt_add_figure(st_ctl);
                    
                    if st_ctl.ver > 1
                        ret = hf_plot_power_floor(st_ctl, spec);
                        ret = hf_store_save_data(st_ctl, st_aux, st_time, spec);
                        ret = hf_rpt_add_figure(st_ctl);
                    end
                end
            else
                    ret = hf_plot_stokes_3D(st_ctl, spec);
                    ret = hf_store_save_data(st_ctl, st_aux, st_time, spec);
                    ret = hf_rpt_add_figure(st_ctl);
                    
                    if st_ctl.ver > 1
                        ret = hf_plot_power_floor(st_ctl, spec);
                        ret = hf_store_save_data(st_ctl, st_aux, st_time, spec);
                        ret = hf_rpt_add_figure(st_ctl);
                    end
            end
        
        case st_ctl.sid_burst_s   % Radio burst, survey data
            fprintf('SID:%02x Radio burst (survey data)\n', st_rpw.sid);
            st_ctl.label = ['HF Config 7: Radio burst (survey data) / Time elapsed : ' num2str(st_time.cuc_time_elapse,'%f')];
            [~, spec] = hf_proc_radio_full(st_ctl, st_aux, st_hfa, raw_data);
            if spec.matrix == 0
                ret = hf_plot_power(st_ctl, spec);
            else
                ret = hf_plot_stokes(st_ctl, spec);
            end
            %ret = hf_store_save_data(st_ctl, st_time, spec);
            ret = hf_rpt_add_figure(st_ctl);
            
        case st_ctl.sid_pssr1_s   % PSSR1, survey data
            fprintf('SID:%02x PSSR1 (survey data)\n', st_rpw.sid);
            st_ctl.label = ['HF Config 8: PSSR1 (survey data) / Time elapsed : ' num2str(st_time.cuc_time_elapse,'%f')];
            [~, spec] = hf_proc_pssr1_surv(ver, st_aux, st_hfa, raw_data);
            ret = hf_plot_power_1ch(st_ctl, spec);
            %ret = hf_store_save_data(st_ctl, st_time, spec);
            ret = hf_rpt_add_figure(st_ctl);
        
        case st_ctl.sid_pssr2_s   % PSSR2, survey data
            fprintf('SID:%02x PSSR2 (survey data)\n', st_rpw.sid);
            st_ctl.label = ['HF Config 9: PSSR2 (survey data) / Time elapsed : ' num2str(st_time.cuc_time_elapse,'%f')];
            [~, auto] = hf_proc_pssr2_surv(ver, st_aux, st_hfa, raw_data);
            ret = hf_plot_autocorr(st_rpw, st_ctl, auto);
            ret = hf_rpt_add_figure(st_ctl);

        case st_ctl.sid_pssr3_s   % PSSR3, survey data
            fprintf('SID:%02x PSSR3 (survey data)\n', st_rpw.sid);
            if st_ctl.ver > 1
                st_ctl.label = ['HF Config 10: PSSR3 (survey data) / Time elapsed : ' num2str(st_time.cuc_time_elapse,'%f')];
                [~, auto] = hf_proc_pssr3_surv(ver, st_aux, st_hfa, raw_data);
                ret = hf_plot_autocorr(st_rpw, st_ctl, auto);
                ret = hf_rpt_add_figure(st_ctl);
            else
                fprintf('---skip\n');
            end

        case st_ctl.sid_burst_r   % Radio burst, rich data
            fprintf('SID:%02x Radio burst (rich data)\n', st_rpw.sid);
            st_ctl.label = ['HF Config 7: Radio burst (rich data) / Time elapsed : ' num2str(st_time.cuc_time_elapse,'%f')];
            [~, spec] = hf_proc_radio_burst_rich(st_ctl, st_aux, st_hfa, raw_data);
            if spec.matrix == 0
                ret = hf_plot_power(st_ctl, spec);
            else
                ret = hf_plot_stokes(st_ctl, spec);
            end
            ret = hf_store_save_data(st_ctl, st_aux, st_time, spec);
            ret = hf_rpt_add_figure(st_ctl);
        
        case st_ctl.sid_pssr1_r   % PSSR1, rich data
            fprintf('SID:%02x PSSR1 (rich data)\n', st_rpw.sid);
            st_ctl.label = ['HF Config 8: PSSR1 (rich data) / Time elapsed : ' num2str(st_time.cuc_time_elapse,'%f')];
            [~, spec] = hf_proc_pssr1_rich(ver, st_aux, st_hfa, raw_data);
            ret = hf_plot_power_2ch(st_ctl, spec);
            ret = hf_store_save_data(st_ctl, st_aux, st_time, spec);
            ret = hf_rpt_add_figure(st_ctl);
            
        case st_ctl.sid_pssr2_r   % PSSR2, rich data
            fprintf('SID:%02x PSSR2 (rich data)\n', st_rpw.sid);
            st_ctl.label = ['HF Config 9: PSSR2 (rich data) / Time elapsed : ' num2str(st_time.cuc_time_elapse,'%f')];
            [~, auto] = hf_proc_pssr2_rich(ver, st_aux, st_hfa, raw_data);
%            ret = hf_plot_autocorr(st_rpw, st_ctl, auto);
            ret = hf_plot_autocorr_rich(st_rpw, st_ctl, auto);
            ret = hf_rpt_add_figure(st_ctl);
        
        case st_ctl.sid_pssr3_r  % PSSR3, rich data
            fprintf('SID:%02x PSSR3 (rich data)\n', st_rpw.sid);
            if st_ctl.ver > 1
                st_ctl.label = ['HF Config 10: PSSR3 (rich data) / Time elapsed : ' num2str(st_time.cuc_time_elapse,'%f')];
                [~, wave, spec] = hf_proc_pssr3_rich(ver, st_aux, st_hfa, raw_data);
                ret = hf_plot_waveform_power(st_ctl, wave, spec);
                ret = hf_rpt_add_figure(st_ctl);
            else
                fprintf('---skip\n');
            end

        case sid_pssr3_r_v1  % PSSR3, rich data V1
            fprintf('SID:%02x PSSR3_v1 (rich data)\n', st_rpw.sid);
            if st_ctl.ver > 1
                st_ctl.label = ['HF Config 10: PSSR3 (rich data) V1 / Time elapsed : ' num2str(st_time.cuc_time_elapse,'%f')];
                [~, wave, spec] = hf_proc_pssr3_rich(ver, st_aux, st_hfa, raw_data);
                ret = hf_plot_waveform_power(st_ctl, wave, spec);
                ret = hf_rpt_add_figure(st_ctl);
            else
                fprintf('---skip\n');
            end

        otherwise
            fprintf('***Error - SID:%02x\n', st_rpw.sid);
           
    end
    
end
