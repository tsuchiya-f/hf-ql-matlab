function  [ret, spec] = hf_proc_radio_full(ver, st_aux, st_hfa, raw_data)

    ret = 0;

    % frequency
    spec.f = hf_get_freq_table(ver, st_aux, st_hfa);
    % conversion factor from ADC value to enginnering value
    cf = -104.1;    % mean power of ADC value to dBm (for rms data)
    
    % data format (size)
    nf = st_hfa.total_step;         % number of frequeucy bins 
    switch st_aux.complex_sel       % number of data set
        case 0
            nk = 3;
        case 1
            nk = 9;
        case 2
            nk = 21;
%        case 3
%            nk = 3;
    end            

    % expected data length
    len = nf * nk * 4; % (Bytes)
    
    % interpretaion of data (4-Byte float or 12-bit MiniFloat)
    if numel(raw_data) == len
        % 4-Byte float
        data = swapbytes(typecast(uint8(raw_data),'single'));
    else
        % convert 12-bit minifloat to 4-Byte float
        data12 = swapbytes(typecast(uint8(raw_data),'uint32'));
        data = hf_minifloat(data12);
    end
    
    % spectram data
    switch st_aux.complex_sel       % number of data set
        case 0
            data = reshape(data(1:nf*nk), nf, nk, []);
            spec.x = 10*log10(data(:,1)) + cf;  % [dBm @ ADC input]
            spec.y = 10*log10(data(:,2)) + cf;  % [dBm @ ADC input]
            spec.z = 10*log10(data(:,3)) + cf;  % [dBm @ ADC input]
            spec.matrix = 0;
        case 1
            data = reshape(data(1:nf*nk), nf, nk, []);
            spec.x = 10*log10(data(:,1)) + cf;  % [dBm @ ADC input]
            spec.y = 10*log10(data(:,2)) + cf;  % [dBm @ ADC input]
            spec.z = 10*log10(data(:,3)) + cf;  % [dBm @ ADC input]
            spec.re_xy = data(:,4);
            spec.re_yz = data(:,5);
            spec.re_zx = data(:,6);
            spec.im_xy = data(:,7);
            spec.im_yz = data(:,8);
            spec.im_zx = data(:,9);
            spec.matrix = 1;
         case 2
            data = reshape(data(1:nf*nk), nf, nk, []);
            % no-pol
            spec.x = 10*log10(data(:,1)) + cf;  % [dBm @ ADC input]
            spec.y = 10*log10(data(:,2)) + cf;  % [dBm @ ADC input]
            spec.z = 10*log10(data(:,3)) + cf;  % [dBm @ ADC input]
            spec.re_xy = data(:,4);
            spec.re_yz = data(:,5);
            spec.re_zx = data(:,6);
            spec.im_xy = data(:,7);
            spec.im_yz = data(:,8);
            spec.im_zx = data(:,9);
            % positive pol
            spec.x_p = 10*log10(data(:,10)) + cf;  % [dBm @ ADC input]
            spec.y_p = 10*log10(data(:,11)) + cf;  % [dBm @ ADC input]
            spec.z_p = 10*log10(data(:,12)) + cf;  % [dBm @ ADC input]
            spec.re_xy_p = data(:,13);
            spec.re_yz_p = data(:,14);
            spec.re_zx_p = data(:,15);
            spec.im_xy_p = data(:,16);
            spec.im_yz_p = data(:,17);
            spec.im_zx_p = data(:,18);
            % negative pol
            spec.x_n = 10*log10(data(:,19)) + cf;  % [dBm @ ADC input]
            spec.y_n = 10*log10(data(:,20)) + cf;  % [dBm @ ADC input]
            spec.z_n = 10*log10(data(:,21)) + cf;  % [dBm @ ADC input]
            spec.re_xy_n = data(:,22);
            spec.re_yz_n = data(:,23);
            spec.re_zx_n = data(:,24);
            spec.im_xy_n = data(:,25);
            spec.im_yz_n = data(:,26);
            spec.im_zx_n = data(:,27);

            spec.matrix = 1;
%        case 3
    end            

    spec.xlog = 1;
    spec.ylog = 0;

end
