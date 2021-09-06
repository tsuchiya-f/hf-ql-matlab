function [ret, auto] = hf_proc_pssr2_surv(ver, st_aux, st_hfa, raw_data)

    ret = 0;

    % for survey data
    n_time = st_aux.n_sample; 
    n_freq = st_aux.sweep_step; 
    fs     = sample_rate(st_aux.decimation+1);  % sampling rate of decimated waveform [Hz]

    % time data [sec]
    t = zeros(1,n_time);
    for i=0:n_time-1
        t(1+i) = (1+i)*(st_hfa.snum+1)/n_time/fs;
    end
    auto.t = t;

    % data type conversion from uint8 to single (32bit-float)
    rdata = swapbytes(typecast(uint8(raw_data),'single'));

    % for survey data
    sdata = reshape(rdata, n_time, []);

    
    auto.auto   = sdata;
    auto.n_time = n_time;
    auto.n_freq = n_freq;
    if length(sdata(1,:)) ~= n_freq 
        sdata = reshape(rdata, n_time, n_freq);

end
