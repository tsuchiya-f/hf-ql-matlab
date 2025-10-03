function st_hfa = hf_add_freq_table(table_id, st_hfa)

    if table_id == 0xFF || table_id == 0x1F
        return;
    end


    switch table_id

        case 2
        % radio full
        st_hfa.n_band = 5;
        st_hfa.decimation   = 0;
        st_hfa.band0_startf = 131;
        st_hfa.band0_stopf  = 575;
        st_hfa.band0_step   = 2;
        st_hfa.band0_rept   = 24;
        st_hfa.band0_sdiv   = 48;
        st_hfa.band1_startf = 575;
        st_hfa.band1_stopf  = 2129;
        st_hfa.band1_step   = 7;
        st_hfa.band1_rept   = 8;
        st_hfa.band1_sdiv   = 12;
        st_hfa.band2_startf = 2129;
        st_hfa.band2_stopf  = 3683;
        st_hfa.band2_step   = 7;
        st_hfa.band2_rept   = 2;
        st_hfa.band2_sdiv   = 3;
        st_hfa.band3_startf = 3683;
        st_hfa.band3_stopf  = 26327;
        st_hfa.band3_step   = 102;
        st_hfa.band3_rept   = 1;
        st_hfa.band3_sdiv   = -3;
        st_hfa.band4_startf = 26327;
        st_hfa.band4_stopf  = 44975;
        st_hfa.band4_step   = 84;
        st_hfa.band4_rept   = 1;
        st_hfa.band4_sdiv   = -4;

        case 1
        % radio full
        st_hfa.n_band = 5;
        st_hfa.band0_startf = 131;
        st_hfa.band0_stopf  = 575;
        st_hfa.band0_step   = 2;
        st_hfa.band0_rept   = 32;
        st_hfa.band0_sdiv   = 48;
        st_hfa.band1_startf = 575;
        st_hfa.band1_stopf  = 2129;
        st_hfa.band1_step   = 7;
        st_hfa.band1_rept   = 8;
        st_hfa.band1_sdiv   = 12;
        st_hfa.band2_startf = 2129;
        st_hfa.band2_stopf  = 3683;
        st_hfa.band2_step   = 7;
        st_hfa.band2_rept   = 2;
        st_hfa.band2_sdiv   = 3;
        st_hfa.band3_startf = 3683;
        st_hfa.band3_stopf  = 16115;
        st_hfa.band3_step   = 56;
        st_hfa.band3_rept   = 1;
        st_hfa.band3_sdiv   = -2;
        st_hfa.band4_startf = 16115;
        st_hfa.band4_stopf  = 40091;
        st_hfa.band4_step   = 108;
        st_hfa.band4_rept   = 1;
        st_hfa.band4_sdiv   = -4;

        case 0
        % radio full
        st_hfa.n_band = 5;
        st_hfa.band0_startf = 131;
        st_hfa.band0_stopf  = 353;
        st_hfa.band0_step   = 1;
        st_hfa.band0_rept   = 16;
        st_hfa.band0_sdiv   = 24;
        st_hfa.band1_startf = 353;
        st_hfa.band1_stopf  = 575;
        st_hfa.band1_step   = 1;
        st_hfa.band1_rept   = 8;
        st_hfa.band1_sdiv   = 12;
        st_hfa.band2_startf = 575;
        st_hfa.band2_stopf  = 1019;
        st_hfa.band2_step   = 2;
        st_hfa.band2_rept   = 4;
        st_hfa.band2_sdiv   = 6;
        st_hfa.band3_startf = 1019;
        st_hfa.band3_stopf  = 2129;
        st_hfa.band3_step   = 5;
        st_hfa.band3_rept   = 2;
        st_hfa.band3_sdiv   = 3;
        st_hfa.band4_startf = 2129;
        st_hfa.band4_stopf  = 44975;
        st_hfa.band4_step   = 193;
        st_hfa.band4_rept   = 1;
        st_hfa.band4_sdiv   = 1;

    end


    st_hfa.total_step = 0;

    if st_hfa.n_band > 0
        if st_hfa.band0_sdiv >= 0
            st_hfa.total_step   = st_hfa.total_step + st_hfa.band0_step * st_hfa.band0_sdiv;
        else
            st_hfa.total_step   = st_hfa.total_step + st_hfa.band0_step ./ abs(st_hfa.band0_sdiv);
        end
    else
        return;
    end
        
    if st_hfa.n_band > 1
        if st_hfa.band1_sdiv >= 0
            st_hfa.total_step   = st_hfa.total_step + st_hfa.band1_step * st_hfa.band1_sdiv;
        else
            st_hfa.total_step   = st_hfa.total_step + st_hfa.band1_step ./ abs(st_hfa.band1_sdiv);
        end
    else
        return;
    end

    if st_hfa.n_band > 2
        if st_hfa.band2_sdiv >= 0
            st_hfa.total_step   = st_hfa.total_step + st_hfa.band2_step * st_hfa.band2_sdiv;
        else
            st_hfa.total_step   = st_hfa.total_step + st_hfa.band2_step ./ abs(st_hfa.band2_sdiv);
        end
    else
        return;
    end

    if st_hfa.n_band > 3
        if st_hfa.band3_sdiv >= 0
            st_hfa.total_step   = st_hfa.total_step + st_hfa.band3_step * st_hfa.band3_sdiv;
        else
            st_hfa.total_step   = st_hfa.total_step + st_hfa.band3_step ./ abs(st_hfa.band3_sdiv);
        end
    else
        return;
    end

    if st_hfa.n_band > 4
        if st_hfa.band4_sdiv >= 0
            st_hfa.total_step   = st_hfa.total_step + st_hfa.band4_step * st_hfa.band4_sdiv;
        else
            st_hfa.total_step   = st_hfa.total_step + st_hfa.band4_step ./ abs(st_hfa.band4_sdiv);
        end
    else
        return;
    end


end
