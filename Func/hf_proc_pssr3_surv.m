function [ret, auto] = hf_proc_pssr3_surv(st_ctl, st_aux, st_hfa, raw_data)
    ret = 0;

    n_time = st_aux.n_lag; 
    n_freq = st_aux.n_block; 
    fs     = sample_rate(st_hfa.decimation+1);  % sampling rate of decimated waveform [Hz]
    n_time_raw=st_hfa.snum;

    % time data [sec]
    t = zeros(1,n_time);
    for i=0:n_time-1
        t(1+i) = single(1+i)*single(n_time_raw+1)/single(n_time)/single(fs);
    end
    auto.t = t;

    % for survey data
    len=length(raw_data);
    rdata16 = swapbytes(typecast(uint8(raw_data(1:len)),'uint32'));
    rdata = hf_minifloat_FP16(rdata16);
    rdata(1:n_freq) = rdata(1:n_freq) * st_ctl.level_bias_pssr2;
    sdata = reshape(rdata(n_freq+1:n_freq+n_time*n_freq), n_time, n_freq, []);
    
    auto.auto   = sdata;
    auto.n_time = n_time;
    auto.n_freq = n_freq;
    auto.freq = 1:n_freq;                       % block No.
    auto.amp_i  = rdata(1:n_freq);              % rms amplitude of I waveform

end
