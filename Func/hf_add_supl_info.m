function [st_aux, st_hfa] = hf_add_supl_info(st_aux, st_hfa, st_rpw, st_ctl)

    switch st_rpw.sid
        case st_ctl.sid_raw   % Raw data (sweep data for test purpose)
%             st_hfa.snum = 31;
%             st_hfa.step = 511;
%             st_hfa.decimation = 1;
%             st_hfa.sample_rate = 148e3;        
%             st_hfa.n_band = 1;
%             st_hfa.band0_startf = 80;       % kHz
%             st_hfa.band0_stopf  = 45000;    % kHz
%             st_hfa.band0_step   = 512;
%             st_hfa.band0_rept   = 1;
%             st_hfa.band0_sdiv   = 1;
% 
%             st_aux.sweep_table_id  = 0xFF;
%             st_aux.xch_sel     = 1;
%             st_aux.ych_sel     = 1;
%             st_aux.zch_sel     = 1;

        case st_ctl.sid_full   % Radio full (Nominal sweep mode)
%             st_hfa.snum = 383;
%             st_hfa.step = 257;
%             st_hfa.decimation = 0;        
%             st_hfa.sample_rate = 296e3;        
%             st_hfa.n_band = 1;
%             st_hfa.band0_startf = 80;       % kHz
%             st_hfa.band0_stopf  = 45000;    % kHz
%             st_hfa.band0_step   = 255;
%             st_hfa.band0_rept   = 1;
%             st_hfa.band0_sdiv   = 1;
% 
            st_hfa.meas_num = 9;            % number of measurements

%             st_aux.sweep_table_id  = 0xFF;
%             st_aux.xch_sel     = 1;
%             st_aux.ych_sel     = 1;
%             st_aux.zch_sel     = 1;
 
        case {st_ctl.sid_pssr3_s, st_ctl.sid_pssr3_r}   % PSSR3
%             st_hfa.feed = 26;
%             st_hfa.skip = 154;
%             st_hfa.block_num = 10;
%             st_hfa.decimation = 0;        
%             st_hfa.sample_rate = 296e3;        
% 
%             st_aux.xch_sel     = 1;
%             st_aux.ych_sel     = 1;
%             st_aux.zch_sel     = 1;
    end
    
end
