%------------------------------------------------------------------------------------------------
% Calculate CUC time from time information in the data field header and
% RPWI header
% see https://spis.irfu.se/mw/matlab_utilities/-/blob/dp_plot_201026/plot_sid_timing.m#L63-93
%------------------------------------------------------------------------------------------------
function [st_time, st_ctl] = hf_get_time_info(st_ctl, st_sec, st_rpw)

    cuc_time_coarse = bitshift( bitand(st_sec.time, 0x7FFFFFFF0000), -16);
    cuc_time_fine   = bitand(st_sec.time, 0x00000000FFFF);
    delta_time_coarse = bitshift( bitand(st_rpw.delta_time, 0xFFFF0000), -16);
    delta_time_fine   = bitand(st_rpw.delta_time, 0x0000FFFF);

    if st_ctl.ver == 1
        % Correction of HF time information for RPWI Ver.1 SW
        % see https://spis.irfu.se/mw/matlab_utilities/-/blob/dp_plot_201026/plot_sid_timing.m#L247-272
        fine =  bitshift(uint32(delta_time_fine),8);
        coarse = int32(cuc_time_coarse) - int32( delta_time_coarse);

        coarse = bitcmp(coarse);
        tmp = ((12500000-1)-fine);
        sec = double(coarse)+(double(tmp))*1.0/(double(12500000));
        samp_time = (sec+0.);
        samp_time_sec  = fix(samp_time);
        samp_time_frac = ((samp_time-samp_time_sec)*16777216.0);
        cucc = uint32(samp_time_sec);
        cucf = bitand(bitshift(uint32(samp_time_frac),-8),uint32(0xFFFF));

        % Replace the wrong values
        cuc_time = double(cucc) + double(cucf)/ 65536;

        delta_time_coarse = int32(cuc_time_coarse) - int32(bitand(uint32(cuc_time),0x7FFFFFFF,'uint32'));
        delta_time_fine = cucf;
    end
    
    % CUC time in second
    st_time.cuc_time_pkg = double(cuc_time_coarse) + double(cuc_time_fine) / 2^16;
    st_time.cuc_time_obs = double(cuc_time_coarse) - double(delta_time_coarse) + double(delta_time_fine)/ 2^16;

    % 
    if st_ctl.first_packet == 1
        st_ctl.first_packet = 0;
        st_ctl.cuc_time_offset = st_time.cuc_time_obs;
    end
    st_time.cuc_time_elapse = st_time.cuc_time_obs - st_ctl.cuc_time_offset;
    
    fprintf('obs time: %d / elapse: %d\n', st_time.cuc_time_obs, st_time.cuc_time_elapse);
    
    julday = st_time.cuc_time_obs / 3600.0 / 24.0 + juliandate( datetime('1970-01-01 00:00:00') );
    st_time.obs_date = datetime(julday, 'ConvertFrom', 'juliandate');
    
end
