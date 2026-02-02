function st_hfa = hf_add_freq_table(table_id, st_hfa)

    if table_id == 0xFF || table_id == 0x1F
        return;
    end


    switch table_id

        case 2
        % radio full (new table for FSW ver3, 20kHz-45MHz)
        st_hfa.n_band = 5;
        st_hfa.decimation   = 0;
        st_hfa.band0_startf = 112;
        st_hfa.band0_stopf  = 482;
        st_hfa.band0_step   = 2;
        st_hfa.band0_rept   = 30;
        st_hfa.band0_sdiv   = 40;
        st_hfa.band1_startf = 482;
        st_hfa.band1_stopf  = 2147;
        st_hfa.band1_step   = 9;
        st_hfa.band1_rept   = 7;
        st_hfa.band1_sdiv   = 8;
        st_hfa.band2_startf = 2147;
        st_hfa.band2_stopf  = 3812;
        st_hfa.band2_step   = 9;
        st_hfa.band2_rept   = 4;
        st_hfa.band2_sdiv   = 4;
        st_hfa.band3_startf = 3812;
        st_hfa.band3_stopf  = 31562;
        st_hfa.band3_step   = 150;
        st_hfa.band3_rept   = 1;
        st_hfa.band3_sdiv   = -3;
        st_hfa.band4_startf = 31562;
        st_hfa.band4_stopf  = 44882;
        st_hfa.band4_step   = 72;
        st_hfa.band4_rept   = 1;
        st_hfa.band4_sdiv   = -4;

        case 1
        % radio full (new table for FSW ver3, 20kHz-40MHz)
        st_hfa.n_band = 5;
        st_hfa.decimation   = 0;
        st_hfa.band0_startf = 112;
        st_hfa.band0_stopf  = 482;
        st_hfa.band0_step   = 2;
        st_hfa.band0_rept   = 24;
        st_hfa.band0_sdiv   = 40;
        st_hfa.band1_startf = 482;
        st_hfa.band1_stopf  = 2332;
        st_hfa.band1_step   = 10;
        st_hfa.band1_rept   = 8;
        st_hfa.band1_sdiv   = 8;
        st_hfa.band2_startf = 2332;
        st_hfa.band2_stopf  = 3627;
        st_hfa.band2_step   = 7;
        st_hfa.band2_rept   = 8;
        st_hfa.band2_sdiv   = 4;
        st_hfa.band3_startf = 3627;
        st_hfa.band3_stopf  = 17317;
        st_hfa.band3_step   = 74;
        st_hfa.band3_rept   = 1;
        st_hfa.band3_sdiv   = -2;
        st_hfa.band4_startf = 17317;
        st_hfa.band4_stopf  = 40257;
        st_hfa.band4_step   = 124;
        st_hfa.band4_rept   = 1;
        st_hfa.band4_sdiv   = -4;

        case 0
        % radio full (new table for FSW ver2, 20kHz-45MHz)
        st_hfa.n_band = 5;
        st_hfa.decimation   = 0;
        st_hfa.band0_startf = 112;
        st_hfa.band0_stopf  = 297;
        st_hfa.band0_step   = 1;
        st_hfa.band0_rept   = 40;
        st_hfa.band0_sdiv   = 40;
        st_hfa.band1_startf = 297;
        st_hfa.band1_stopf  = 482;
        st_hfa.band1_step   = 1;
        st_hfa.band1_rept   = 20;
        st_hfa.band1_sdiv   = 20;
        st_hfa.band2_startf = 482;
        st_hfa.band2_stopf  = 1222;
        st_hfa.band2_step   = 4;
        st_hfa.band2_rept   = 10;
        st_hfa.band2_sdiv   = 10;
        st_hfa.band3_startf = 1222;
        st_hfa.band3_stopf  = 3257;
        st_hfa.band3_step   = 11;
        st_hfa.band3_rept   = 4;
        st_hfa.band3_sdiv   = 4;
        st_hfa.band4_startf = 3257;
        st_hfa.band4_stopf  = 44697;
        st_hfa.band4_step   = 224;
        st_hfa.band4_rept   = 1;
        st_hfa.band4_sdiv   = -2;

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
