function [ret, stream] = hf_proc_pssr3_surv(ver, st_aux, st_hfa, raw_data)

    ret = 0;

    % for survey data
    tint = st_aux.interval;         % time iterval of data points [msec]
    nb   = fix(st_aux.n_data);      % number of block in one packet

    % conversion factor from ADC value to enginnering value
    cf = -104.1;    % mean power of ADC value to dBm

    % time data
    % for survey data (rms value) [sec]
    stream.tm = (0:nb-1) * tint * 1e-3;

    % for survey data
    sdata = reshape(raw_data, nb, []);
    sdata = 10.0*log10(sdata) + cf;  %[dBm]

    stream.x = sdata(:,1);
    stream.y = sdata(:,2);
    stream.z = sdata(:,3);
    
    stream.matrix = 1;

end
