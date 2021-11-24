function [ret, auto] = hf_proc_pssr2_surv(ver, st_aux, st_hfa, raw_data)

    ret = 0;

    % for survey data
    n_time = st_aux.n_sample; 
    n_freq = st_aux.sweep_step; 
    fs     = sample_rate(st_aux.decimation+1);  % sampling rate of decimated waveform [Hz]

    % time data [sec]
    t = zeros(1,n_time);
    for i=0:n_time-1
        t(1+i) = single(1+i)*single(st_hfa.snum+1)/single(n_time)/single(fs);
    end
    auto.t = t;

    % for survey data
    len=length(raw_data);
    len32 = n_time*n_freq*4;
    
    % interpretaion of data (4-Byte float or 12-bit MiniFloat)
    if len == len32
        % 4-Byte float
%        rdata = swapbytes(typecast(uint8(raw_data(1:len)),'single'));
%        sdata = reshape(rdata, n_time, n_freq, []);
        % convert 12-bit minifloat to 4-Byte float
        rdata16 = swapbytes(typecast(uint8(raw_data(1:len)),'uint32'));
        rdata = hf_minifloat_FP16(rdata16);
        sdata = reshape(rdata, n_time, n_freq, []);
    else
        fprintf("***** ERROR : invalid data length\n");
        pause
    end
    
    auto.auto   = sdata;
    auto.n_time = n_time;
    auto.n_freq = n_freq;

    auto.freq = st_aux.start_freq + [0:(st_aux.sweep_step-4)]*(st_aux.stop_freq - st_aux.start_freq)/(st_aux.sweep_step-4);
    
    
end
