function f = hf_show_freq_table_id(sweep_table_id)

    switch sweep_table_id

        case 2
        % radio full
        ver = 3;
        sid = 3;
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
        % radio full
        ver = 3;
        sid = 3;
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
        % radio full
        ver = 3;
        sid = 3;
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
        st_hfa.band2_stopf  = 1407;
        st_hfa.band2_step   = 5;
        st_hfa.band2_rept   = 10;
        st_hfa.band2_sdiv   = 10;
        st_hfa.band3_startf = 1407;
        st_hfa.band3_stopf  = 2887;
        st_hfa.band3_step   = 5;
        st_hfa.band3_rept   = 10;
        st_hfa.band3_sdiv   = 10;
        st_hfa.band4_startf = 2887;
        st_hfa.band4_stopf  = 45067;
        st_hfa.band4_step   = 228;
        st_hfa.band4_rept   = 1;
        st_hfa.band4_sdiv   = -2;

        otherwise
        ver = 0;
        fprintf('N.A. for Sweep table ID %d\n',sweep_table_id);

    end

    st_aux.sweep_table_id = 0x1f;

    if ver ~= 0

        f = hf_get_freq_table(ver, st_aux, st_hfa, 0x43);
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
