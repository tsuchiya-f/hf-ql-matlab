function ret = hf_print_hf(st, st_ctl)

    persistent n;

    ret = 0;

    if isempty(n)
        n = 0;
    end
    n = n+1;
    
    fprintf('---------- HF header number of reception : %3d ----------\n', n);
    
    % skip for Ver.1 SW
    if st_ctl.ver == 1.0
        return
    end    
    
    fprintf('Number of samples %d\n', st.snum);
    fprintf('Number of steps   %d\n', st.step);
    fprintf('Decimation        %d\n', st.decimation);
    fprintf('Pol               %d\n', st.pol);

    if st.n_band == 0
        return; 
    end
    fprintf('         start stop  step rept sdiv\n');
    fprintf('Band 0 : %5d %5d %4d %4d %4d\n', st.band0_startf, st.band0_stopf, st.band0_step, st.band0_rept, st.band0_sdiv);
    if st.n_band == 1
        fprintf('---------------------------------------------------------\n');
        return; 
    end
    fprintf('Band 1 : %5d %5d %4d %4d %4d\n', st.band1_startf, st.band1_stopf, st.band1_step, st.band1_rept, st.band1_sdiv);
    if st.n_band == 2
        fprintf('---------------------------------------------------------\n');
        return; 
    end
    fprintf('Band 2 : %5d %5d %4d %4d %4d\n', st.band2_startf, st.band2_stopf, st.band2_step, st.band2_rept, st.band2_sdiv);
    if st.n_band == 3
        fprintf('---------------------------------------------------------\n');
        return;
    end
    fprintf('Band 3 : %5d %5d %4d %4d %4d\n', st.band3_startf, st.band3_stopf, st.band3_step, st.band3_rept, st.band3_sdiv);
    if st.n_band == 4
        fprintf('---------------------------------------------------------\n');
        return; 
    end
    fprintf('Band 4 : %5d %5d %4d %4d %4d\n', st.band4_startf, st.band4_stopf, st.band4_step, st.band4_rept, st.band4_sdiv);    
    
end