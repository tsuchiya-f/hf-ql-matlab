function f = hf_get_freq_table(ver, st_aux, st_hfa, sid)

%-----------------------------------
%   SID for SW ver.2 & later
%-----------------------------------
%    st_ctl.sid_raw     = 0x42;
%    st_ctl.sid_full    = 0x43;
%    st_ctl.sid_burst_s = 0x44;
%    st_ctl.sid_pssr1_s = 0x45 (69);
%    st_ctl.sid_pssr2_s = 0x46;
%    st_ctl.sid_pssr3_s = 0x47;
%    st_ctl.sid_burst_r = 0x64;
%    st_ctl.sid_pssr1_r = 0x65;
%    st_ctl.sid_pssr2_r = 0x66;
%    st_ctl.sid_pssr3_r = 0x67;
% 

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
    switch sid
        case {0x65, 0x45}
            sdiv = double(int16((st_hfa.snum+1)/4*3));
            if sid == 0x45
               sdiv = sdiv/double(st_aux.rfi_param2*256 + st_aux.rfi_param3);
            end
            % band 0
            f_band = hf_get_band(st_hfa.band0_startf, st_hfa.band0_stopf, st_hfa.band0_step, sdiv, bw_eff);
            f = [f, f_band];
            if st_hfa.n_band == 1; return; end
            % band 1
            f_band = hf_get_band(st_hfa.band1_startf, st_hfa.band1_stopf, st_hfa.band1_step, sdiv, bw_eff);
            f = [f, f_band];
            if st_hfa.n_band == 2; return; end
            % band 2
            f_band = hf_get_band(st_hfa.band2_startf, st_hfa.band2_stopf, st_hfa.band2_step, sdiv, bw_eff);
            f = [f, f_band];
            if st_hfa.n_band == 3; return; end
            % band 3
            f_band = hf_get_band(st_hfa.band3_startf, st_hfa.band3_stopf, st_hfa.band3_step, sdiv, bw_eff);
            f = [f, f_band];
            if st_hfa.n_band == 4; return; end
            % band 4
            f_band = hf_get_band(st_hfa.band4_startf, st_hfa.band4_stopf, st_hfa.band4_step, sdiv, bw_eff);
            f = [f, f_band];            

        otherwise
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

    if sdiv > 0
    
        f_band = zeros(1,step * sdiv, 'double');
	    freq_step = (stopf - startf) ./  step;
        
        for i=1:step
    	    freq_mid = startf + freq_step * (i-1);
    	    freq_div = bw_eff ./ sdiv;
    	    freq_low = freq_mid - bw_eff*0.5;
            for j=1:sdiv
        	    f_band((i-1)*sdiv + j) = freq_low + freq_div*(j-1) + freq_div*0.5;
            end
        end
     
    else

        f_band = zeros(1,step ./ abs(sdiv));
	    freq_step = (stopf - startf) ./ step;

        ii = 1;
        for i=1:abs(sdiv):step
    	    freq_mid1 = startf + freq_step * (i-1);
    	    freq_mid2 = startf + freq_step * (i+abs(sdiv)-2);
            freq_mid = (freq_mid1 + freq_mid2) * 0.5;
        	f_band(ii) = freq_mid;
            ii = ii + 1;
        end

    end
    
end

%-------------------------------------------------------------------------
