function  [ret, spec] = hf_proc_radio_full(ver, st_aux, st_hfa, raw_data)

    ret = 0;

    % frequency
    spec.f = hf_get_freq_table(ver, st_aux, st_hfa);

    nf = 255;  % number of frequeucy bins (fixed to be 255 for EM) 
    nk = 9;    % number of data set (fixed to be 9 for EM)

    % conversion factor from ADC value to enginnering value
    cf = -104.1;    % mean power of ADC value to dBm (for rms data)

    data = swapbytes(typecast(uint8(raw_data),'single'));
    data = 10*log10(reshape(data, nf, nk, [])) + cf;  % [dBm @ ADC input]
    spec.x = data(:,1);
    spec.y = data(:,2);
    spec.z = data(:,3);

    spec.log = 0;

end
