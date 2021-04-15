function  [ret, spec] = hf_proc_radio_full(ver, st_aux, st_hfa, raw_data)

    ret = 0;

    % frequency
    spec.f = hf_get_freq_table(ver, st_aux, st_hfa);

    nf = st_hfa.total_step;  % number of frequeucy bins 
    nk = st_hfa.meas_num;    % number of data set

    % conversion factor from ADC value to enginnering value
    cf = -104.1;    % mean power of ADC value to dBm (for rms data)

    data = swapbytes(typecast(uint8(raw_data),'single'));
    data = reshape(data, nf, nk, []);
    spec.x = 10*log10(data(:,1)) + cf;  % [dBm @ ADC input]
    spec.y = 10*log10(data(:,2)) + cf;  % [dBm @ ADC input]
    spec.z = 10*log10(data(:,3)) + cf;  % [dBm @ ADC input]
    spec.re_xy = data(:,4);
    spec.re_yz = data(:,5);
    spec.re_zx = data(:,6);
    spec.im_xy = data(:,7);
    spec.im_yz = data(:,8);
    spec.im_zx = data(:,9);

    spec.log = 0;
    spec.matrix = 1;

end
