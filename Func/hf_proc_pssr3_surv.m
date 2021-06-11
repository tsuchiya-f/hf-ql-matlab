function [ret, stream] = hf_proc_pssr3_surv(ver, st_aux, st_hfa, raw_data)

    ret = 0;

    % for survey data
    fs   = st_hfa.sample_rate;  % sampling rate of decimated waveform [Hz]
    feed = st_hfa.feed;         % number of feed frames in one block
    skip = st_hfa.skip;         % number of skip frames in one block
    nb   = st_hfa.block_num;    % number of block in one packet

    ns   = 128;                 % number of data sample in one frame (fixed)

    % conversion factor from ADC value to enginnering value
    cf = -104.1;    % mean power of ADC value to dBm

    % time data
    % for survey data (rms value) [sec]
    stream.tm = linspace(0,nb-1,nb)*(feed+skip)*ns/fs;

    % for survey data
    sdata = reshape(raw_data, nb, []);
    sdata = 10.0*log10(sdata) + cf;  %[dBm]

    stream.x = sdata(:,1);
    stream.y = sdata(:,2);
    stream.z = sdata(:,3);
    
    stream.matrix = 1;

end
