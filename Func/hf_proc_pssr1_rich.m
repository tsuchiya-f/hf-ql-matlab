function  [ret, spec] = hf_proc_pssr1_rich(ver, st_aux, st_hfa, raw_data)

    ret = 0;

    % frequency
    spec.f = hf_get_freq_table(ver, st_aux, st_hfa);
    %spec.f = st_aux.start_freq + (st_aux.stop_freq - st_aux.start_freq)/(st_aux.sweep_step-1) * linspace(st_aux.sweep_step);
    % conversion factor from ADC value to enginnering value
    % cf = -104.1;    % mean power of ADC value to dBm (for rms data)
    cf = 0.0;
    % spectram data
    data = swapbytes(typecast(uint8(raw_data),'single'));
    
    nf = st_hfa.total_step;         % number of frequeucy bins 

    % number of available channel (only 2ch mode for PSSR1)
    switch st_aux.complex_sel       % number of data set
        case 0
            nk = 2;
        case 1
            nk = 4;
    end

    % expected data length
    len = nf * nk * 4;          % (Bytes)
    len_12 = nf * nk * 16 / 8;  % (Bytes)
    len_total = len;
    len_total_12 = len_12;
    
    % interpretaion of data (4-Byte float or 12-bit MiniFloat)
    raw_data8 = uint8(raw_data);
    if numel(raw_data) == len_total
        % 4-Byte float
        data = swapbytes(typecast(raw_data8(1:len),'single'));
    elseif numel(raw_data) == len_total_12
        % convert 12-bit minifloat to 4-Byte float
        data12 = swapbytes(typecast(raw_data8(1:len_12),'uint32'));
        data = hf_minifloat16(data12);
    else
        fprintf("***** ERROR : invalid data length\n");
        pause
    end

    data = reshape(data, nf, nk, []);
    
    % spectral matrix
    spec.xx = data(:,1);
    spec.yy = data(:,2);
    % create dummy data
    spec.zz    = zeros(nf,1); spec.zz(:,1)=NaN;
    spec.z     = zeros(nf,1); spec.z(:,1)=NaN;
    spec.re_xy = zeros(nf,1); spec.re_xy(:,1)=NaN;
    spec.im_xy = zeros(nf,1); spec.im_xy(:,1)=NaN;
    spec.re_yz = zeros(nf,1); spec.re_yz(:,1)=NaN;
    spec.im_yz = zeros(nf,1); spec.im_yz(:,1)=NaN;
    spec.re_zx = zeros(nf,1); spec.re_zx(:,1)=NaN;
    spec.im_zx = zeros(nf,1); spec.im_zx(:,1)=NaN;
        
    % auto spectra
    spec.x = 10*log10(spec.xx) + cf;  % [dBm @ ADC input]
    spec.y = 10*log10(spec.yy) + cf;  % [dBm @ ADC input]   
    switch st_aux.complex_sel       % number of data set
        case 1
            spec.re_xy = data(:,3);
            spec.im_xy = data(:,4);
    end

    spec.matrix = 1;       

    spec.xlog = 0;
    spec.ylog = 0;

end
