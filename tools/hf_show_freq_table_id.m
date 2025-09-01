function f = hf_show_freq_table_id(sweep_table_id)

    switch sweep_table_id

        case 2
        % radio full
        ver = 3;
        sid = 3;
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
        ver = 3;
        sid = 3;
        st_hfa.n_band = 5;
        st_hfa.decimation   = 0;
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
        ver = 2;
        sid = 3;
        st_hfa.n_band = 5;
        st_hfa.decimation   = 0;
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

        otherwise
        ver = 0;
        fprintf('N.A. for Sweep table ID %d\n',sweep_table_id);

    end

    st_aux.sweep_table_id = 0x1f;

    if ver ~= 0

        f = hf_get_freq_table(ver, st_aux, st_hfa);
        bw = hf_get_freq_bw(st_aux, st_hfa);

        filename = 'freq_sweep_table_id' + string(sweep_table_id) + '_v'+ string(ver) +'.txt';
        fid = fopen(filename,'w');

        fprintf("   start[kHz] stop[kHz] bw[kHz]\n");
        fprintf(fid,"   start[kHz] stop[kHz] bw[kHz]\n");
        n = numel(f);
        for i=1:n
            fprintf("%3d  %8.2f  %8.2f %7.2f\n", i, f(i)-bw(i)*0.5, f(i)+bw(i)*0.5, bw(i));
            fprintf(fid, "%3d  %8.2f  %8.2f %7.2f\n", i, f(i)-bw(i)*0.5, f(i)+bw(i)*0.5, bw(i));
        end
        fclose(fid);
        fprintf("Output %s\n", filename);

    end

end
