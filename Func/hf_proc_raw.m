function  [ret, spec, wave] = hf_proc_raw(ver, st_aux, st_hfa, raw_data)

    ret = 0;

    % time data [msec]
    sample_rate = [296000 148000 74000 37000];
    ts   = 1000.0/sample_rate(st_hfa.decimation+1);  % sampling time of decimated waveform [msec]
    wave.t = linspace(0,st_hfa.snum,st_hfa.snum+1) * ts;
    
    % freqneucy table
    spec.f = hf_get_freq_table(ver, st_aux, st_hfa);
    fprintf('freq[1]: %f / freq[%d]: %f / %d\n', spec.f(1), numel(spec.f), spec.f(numel(spec.f)), st_hfa.step + 1);

    num_sampl = st_hfa.snum + 1;  % number of samples at each frequency step
    num_steps = st_hfa.step + 1;  % number of frequency steps
    
    % expected data size
    n_exp = num_sampl * num_steps * 16;
    if n_exp ~= size(raw_data)
        ret = -1;
        return;
    end

    rawData = swapbytes(typecast(uint8(raw_data),'int16'));
    rawData = reshape(typecast(int32(rawData),'uint32'), 8, []);

    xq = reshape( double(typecast(bitor(bitshift(rawData(1,:),4), bitshift(bitand(   15,rawData(7,:)),  0)),'int32')), [num_sampl, num_steps]);
    yq = reshape( double(typecast(bitor(bitshift(rawData(3,:),4), bitshift(bitand( 3840,rawData(7,:)), -8)),'int32')), [num_sampl, num_steps]);
    zq = reshape( double(typecast(bitor(bitshift(rawData(5,:),4), bitshift(bitand(   15,rawData(8,:)),  0)),'int32')), [num_sampl, num_steps]);
    xi = reshape( double(typecast(bitor(bitshift(rawData(2,:),4), bitshift(bitand(  240,rawData(7,:)), -4)),'int32')), [num_sampl, num_steps]);
    yi = reshape( double(typecast(bitor(bitshift(rawData(4,:),4), bitshift(bitand(61440,rawData(7,:)),-12)),'int32')), [num_sampl, num_steps]);
    zi = reshape( double(typecast(bitor(bitshift(rawData(6,:),4), bitshift(bitand(  240,rawData(8,:)), -4)),'int32')), [num_sampl, num_steps]);

    wave.xq = xq;
    wave.xi = xi;
    wave.yq = yq;
    wave.yi = yi;
    wave.zq = zq;
    wave.zi = zi;
    
    %cnt = bitshift(bitand(  768,rawData(8,:)), -8);     % 2bit  0000 0011 0000 0000  0x0300=768
    %swp = bitshift(bitand( 1024,rawData(8,:)),-10);     % 1bit  0000 0100 0000 0000  0x0400=1024
    %dec = bitshift(bitand( 6144,rawData(8,:)),-11);     % 2bit  0001 1000 0000 0000  0x1800=6144
    %ovf = bitshift(bitand(57344,rawData(8,:)),-13);     % 3bit  1110 0000 0000 0000  0xE000=57344

    % auto correlation
    Xabs = sqrt( mean( xq.^2+xi.^2, 1 ) );
    Yabs = sqrt( mean( yq.^2+yi.^2, 1 ) );
    Zabs = sqrt( mean( zq.^2+zi.^2, 1 ) );
    spec.x = 20 * ( log10( Xabs ) - log10( 1.357 * 2^17 ) ) + 0.9;
    spec.y = 20 * ( log10( Yabs ) - log10( 1.357 * 2^17 ) ) + 0.9;
    spec.z = 20 * ( log10( Zabs ) - log10( 1.357 * 2^17 ) ) + 0.9;
    spec.xx = spec.x;
    spec.yy = spec.y;
    spec.zz = spec.z;

    spec.matrix = 0;
    spec.xlog = 0;
    spec.ylog = 0;

end
