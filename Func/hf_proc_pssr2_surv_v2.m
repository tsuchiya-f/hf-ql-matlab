function [ret, auto] = hf_proc_pssr2_surv_v2(st_ctl, st_aux, st_hfa, raw_data)

    ret = 0;

    % for survey data
    n_time = st_aux.n_lag; 
    n_freq = st_hfa.total_step; 
    fs     = sample_rate(st_hfa.decimation+1);  % sampling rate of decimated waveform [Hz]

    % time data [sec]
    t = zeros(1,n_time);
    for i=0:n_time-1
        t(1+i) = single(1+i)*single(st_hfa.snum+1)/single(n_time)/single(fs);
    end
    auto.t = t;

    % for survey data [Bytes]
    len=length(raw_data);
    len32 = n_time*4 + n_freq*4;
    
    % interpretaion of data (4-Byte float or 12-bit MiniFloat)
    fprintf("Data Len: %d, Expexted Len:%d\n", len, len32);
    fprintf("ntime: %d, nfreq:%d\n", n_time, n_freq);    
    if len == len32
        % convert 16-bit minifloat to 4-Byte float
        rdata16 = swapbytes(typecast(uint8(raw_data(1:len)),'uint32'));
        rdata = hf_minifloat_FP16(rdata16);
        rdata(1:n_freq) = rdata(1:n_freq) * st_ctl.level_bias_pssr2;
        sdata = reshape(rdata(n_freq+1:n_freq+n_time), n_time, 1, []);
    else
        fprintf("***** ERROR : invalid data length %d (%d expected)\n", len, len32);
        pause
    end
    
    auto.amp_i  = rdata(1:n_freq);              % rms amplitude of I waveform
    auto.auto   = sdata;                        % Auto-correlation coefficient
    auto.n_time = n_time;
    auto.n_freq = n_freq;

    % frequency
    sid = 0x46;
    auto.f = hf_get_freq_table(0, st_aux, st_hfa, sid);
    if st_aux.rfi_param0 == 1
        auto.freq_selected = auto.f(st_aux.rfi_param1+1);
    else
        [~, imax] = max(auto.amp_i);
        auto.freq_selected = auto.f(imax);
    end
    
end
