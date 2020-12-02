function [st_aux, st_hfa] = hf_add_hdr_ver1(st_aux, st_hfa, sid)

    switch sid
        case 0x42   % Raw data (sweep data for test purpose)
            st_hfa.snum = 31;
            st_hfa.step = 511;
            st_hfa.decimation = 1;        
            st_hfa.n_band = 1;
            st_hfa.band0_startf = 80;       % kHz
            st_hfa.band0_stopf  = 45000;    % kHz
            st_hfa.band0_step   = 512;
            st_hfa.band0_rept   = 1;
            st_hfa.band0_sdiv   = 1;

            st_aux.sweep_table_id  = 0xFF;
            st_aux.xch_sel     = 1;
            st_aux.ych_sel     = 1;
            st_aux.zch_sel     = 1;

        case 0x43   % Radio full (Nominal sweep mode)
            st_hfa.snum = 383;
            st_hfa.step = 257;
            st_hfa.decimation = 0;        
            st_hfa.n_band = 1;
            st_hfa.band0_startf = 80;       % kHz
            st_hfa.band0_stopf  = 45000;    % kHz
            st_hfa.band0_step   = 255;
            st_hfa.band0_rept   = 1;
            st_hfa.band0_sdiv   = 1;

            st_aux.sweep_table_id  = 0xFF;
            st_aux.xch_sel     = 1;
            st_aux.ych_sel     = 1;
            st_aux.zch_sel     = 1;

        case 0x47   % PSSR3, survey data
        case 0x77   % PSSR3, rich data
    end
    
end
