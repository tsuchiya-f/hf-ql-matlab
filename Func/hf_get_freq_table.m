function f = hf_get_freq_table(ver, st_aux, st_hfa)

     % Bandwidth [kHz]
     switch st_hfa.decimation
        case 0;  bw = 296.0;
        case 1;  bw = 148.0;
        case 2;  bw = 74.0;
        case 3;  bw = 37.0;
     end
    % Effective bandwidth (75%) [kHz]
    bw_eff = bw * 0.75; 

    f = [];
    switch st_aux.sweep_table_id
        case {0x1f, 0xff}
            % band 0
            f_band = hf_get_band(st_hfa.band0_startf, st_hfa.band0_stopf, st_hfa.band0_step, st_hfa.band0_sdiv, bw_eff);
            f = [f, f_band];
            if st_hfa.n_band == 1; return; end
            % band 1
            f_band = hf_get_band(st_hfa.band1_startf, st_hfa.band1_stopf, st_hfa.band1_step, st_hfa.band1_sdiv, bw_eff);
            f = [f, f_band];
            if st_hfa.n_band == 2; return; end
            % band 2
            f_band = hf_get_band(st_hfa.band2_startf, st_hfa.band2_stopf, st_hfa.band2_step, st_hfa.band2_sdiv, bw_eff);
            f = [f, f_band];
            if st_hfa.n_band == 3; return; end
            % band 3
            f_band = hf_get_band(st_hfa.band3_startf, st_hfa.band3_stopf, st_hfa.band3_step, st_hfa.band3_sdiv, bw_eff);
            f = [f, f_band];
            if st_hfa.n_band == 4; return; end
            % band 4
            f_band = hf_get_band(st_hfa.band4_startf, st_hfa.band4_stopf, st_hfa.band4_step, st_hfa.band4_sdiv, bw_eff);
            f = [f, f_band];            
    end
    
end

%-------------------------------------------------------------------------
function f_band = hf_get_band(startf, stopf, step, sdiv, bw_eff)

    f_band = zeros(1,step * sdiv);
	freq_step = (stopf - startf) /  step;
    
	for i=1:step
    	freq_mid = startf + freq_step * (i-1);
    	freq_div = bw_eff / sdiv;
    	freq_low = freq_mid - bw_eff*0.5;
        for j=1:sdiv
        	f_band((i-1)*sdiv + j) = freq_low + freq_div*(j-1) + freq_div*0.5;
        end
    end
    
end

%-------------------------------------------------------------------------
