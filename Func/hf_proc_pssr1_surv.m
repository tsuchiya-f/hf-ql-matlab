function  [ret, spec] = hf_proc_pssr1_surv(ver, st_aux, st_hfa, raw_data)

    ret = 0;

    % frequency
    spec.f = hf_get_freq_table(ver, st_aux, st_hfa);
    %spec.f = st_aux.start_freq + (st_aux.stop_freq - st_aux.start_freq)/(st_aux.sweep_step-1) * linspace(st_aux.sweep_step);
    % conversion factor from ADC value to enginnering value
    cf = -104.1;    % mean power of ADC value to dBm (for rms data)
    % spectram data
    data = swapbytes(typecast(uint8(raw_data),'single'));
    
    nf = st_hfa.total_step;         % number of frequeucy bins 
 
    nk = 4;
    data = reshape(data, nf, nk, []);
    spec.x = 10*log10(data(:,1)) + cf;  % [dBm @ ADC input]
    spec.y = 10*log10(data(:,3)) + cf;  % [dBm @ ADC input]
    spec.re_xy = data(:,2);
    spec.im_xy = data(:,4);

    spec.matrix = 1;

%    switch st_aux.complex_sel       % number of data set
%        case 0
%            nk = 2;
%            data = reshape(data, nf, nk, []);
%            spec.x = 10*log10(data(:,1)) + cf;  % [dBm @ ADC input]
%            spec.y = 10*log10(data(:,2)) + cf;  % [dBm @ ADC input]
%            spec.matrix = 0;
%        case 1
%            nk = 4;
%            data = reshape(data, nf, nk, []);
%            spec.x = 10*log10(data(:,1)) + cf;  % [dBm @ ADC input]
%            spec.y = 10*log10(data(:,2)) + cf;  % [dBm @ ADC input]
%            spec.re_xy = data(:,3);
%            spec.im_xy = data(:,4);
%            spec.matrix = 1;
%        case 2
%            nk = 21;
%        case 3
%            nk = 3;
%    end            

    spec.xlog = 0;
    spec.ylog = 0;

end
