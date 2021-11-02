function  [ret, spec] = hf_proc_pssr1_surv(ver, st_aux, st_hfa, raw_data)

    ret = 0;

    % frequency
    spec.f = single(st_aux.start_freq + (st_aux.stop_freq - st_aux.start_freq)/(st_aux.sweep_step-1) * [0:st_aux.sweep_step-1]);
    % conversion factor from ADC value to enginnering value
    % cf = -104.1;    % mean power of ADC value to dBm (for rms data)
    cf = 0.0;

    nf = st_aux.sweep_step;         % number of frequeucy bins 
    nk = 1;

    % expected data length
    len = nf * nk * 4;          % (Bytes)
    len_12 = nf * nk * 16 / 8;  % (Bytes)
    
    % interpretaion of data (4-Byte float or 12-bit MiniFloat)
    raw_data8 = uint8(raw_data);
    if numel(raw_data) == len
        % 4-Byte float
        data = swapbytes(typecast(raw_data8(1:len),'single'));
        data = reshape(data, nf, nk, []);
    elseif numel(raw_data) == len_12
        % convert 12-bit minifloat to 4-Byte float
        data12 = swapbytes(typecast(raw_data8(1:len_12),'uint32'));
        data = hf_minifloat16(data12);
    else
        fprintf("***** ERROR : invalid data length\n");
        pause
    end
    
    % spectram data
    spec.x = 10*log10(data) + cf;  % [dBm @ ADC input]
    spec.y = zeros(nf,1);
    spec.z = zeros(nf,1);

    spec.matrix = 0;

    spec.xlog = 0;
    spec.ylog = 0;

end
