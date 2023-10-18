function f = hf_show_freq_table(sid)

    switch sid

        case 3
        % radio full
        ver = 2;
        st_aux.sweep_table_id = 0x1f;
        st_hfa.n_band = 5;
        st_hfa.decimation   = 0;
        st_hfa.band0_startf = 191;
        st_hfa.band0_stopf  = 413;
        st_hfa.band0_step   = 1;
        st_hfa.band0_sdiv   = 24;
        st_hfa.band1_startf = 413;
        st_hfa.band1_stopf  = 635;
        st_hfa.band1_step   = 1;
        st_hfa.band1_sdiv   = 12;
        st_hfa.band2_startf = 635;
        st_hfa.band2_stopf  = 1079;
        st_hfa.band2_step   = 2;
        st_hfa.band2_sdiv   = 6;
        st_hfa.band3_startf = 1079;
        st_hfa.band3_stopf  = 2189;
        st_hfa.band3_step   = 5;
        st_hfa.band3_sdiv   = 3;
        st_hfa.band4_startf = 2189;
        st_hfa.band4_stopf  = 45035;
        st_hfa.band4_step   = 193;
        st_hfa.band4_sdiv   = 1;

        case 4
        % radio burst
        ver = 2;
        st_aux.sweep_table_id = 0x1f;
        st_hfa.n_band = 1;
        st_hfa.decimation   = 3;
        st_hfa.band0_startf = 80;
        st_hfa.band0_stopf  = 2096;
        st_hfa.band0_step   = 72;
        st_hfa.band0_sdiv   = 1;

        case 5
        % PSSR1
        ver = 2;
        st_aux.sweep_table_id = 0x1f;
        st_hfa.n_band = 1;
        st_hfa.decimation   = 0;
        st_hfa.band0_startf = 191;
        st_hfa.band0_stopf  = 10181;
        st_hfa.band0_step   = 45;
        st_hfa.band0_sdiv   = 96;

        case 6
        % PSSR2
        ver = 2;
        st_aux.sweep_table_id = 0x1f;
        st_hfa.n_band = 1;
        st_hfa.decimation   = 0;
        st_hfa.band0_startf = 1000;
        st_hfa.band0_stopf  = 45000;
        st_hfa.band0_step   = 45;
        st_hfa.band0_sdiv   = 1;

        otherwise
        ver = 0;
        fprintf('N.A. for SID %d\n',sid);

    end

    if ver ~= 0

        f = hf_get_freq_table(ver, st_aux, st_hfa);
        bw = hf_get_freq_bw(st_aux, st_hfa);

        filename = 'tools\freq_table_sid-' + string(sid)+'.txt';
        fid = fopen(filename,'w');

        fprintf("   start[kHz] stop[kHz] bw[kHz]\n");
        fprintf(fid,"   start[kHz] stop[kHz] bw[kHz]\n");
        n = numel(f);
        for i=1:n
            fprintf("%3d  %8.2f  %8.2f %7.2f\n", i, f(i), f(i)+bw(i), bw(i));
            fprintf(fid, "%3d  %8.2f  %8.2f %7.2f\n", i, f(i), f(i)+bw(i), bw(i));
        end
        fclose(fid);

    end

end
