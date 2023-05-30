function  [ret, spec] = hf_proc_raw_ver1_corrected(ver, st_ctl, st_aux, st_hfa, raw_data)

    %------------------------------------
    % create data pool as global
    global data_pool
    persistent n;
    
    if isempty(n)
        n = 1;
        data_pool = [];
    end
    %------------------------------------

    ret = 0;
    
    % freqneucy table
    spec.f = hf_get_freq_table(ver, st_aux, st_hfa);
    fprintf('freq[1]: %f / freq[%d]: %f / %d\n', spec.f(1), numel(spec.f), spec.f(numel(spec.f)), st_hfa.step + 1);

    % put data to the data pool
    data_pool = vertcat(data_pool, raw_data);

    num_sampl = st_hfa.snum + 1;  % number of samples at each frequency step
    num_steps = st_hfa.step + 1;  % number of frequency steps

    % correction of wrong setting in the system test script
    if num_sampl == 32
        num_sampl = 50; 
        num_pool  = 118;  % 50 + 50 + (50-32) 
    end

    % expected data size
    n_exp = num_pool * num_steps * 16;

    % check data size
    cur_size = size(data_pool);
    if cur_size < n_exp
        ret = -1;
        return;
    end

    % permanent error
    i_mod = mod(cur_size, 64);
    if i_mod ~= 0
        data_pool = [];
        ret = -1;
        return;
    end
        
    % search sweep start position
    rawData = swapbytes(typecast(uint8(data_pool),'int16'));
    rawData = reshape(typecast(int32(rawData),'uint32'), 8, []);
    swp = bitshift(bitand( 1024,rawData(8,:)),-10);     % 1bit  0000 0100 0000 0000  0x0400=1024

    n_start = sum(swp);
    [~, idx] = sort(swp,'descend');
    for i=1:n_start-1
        if idx(i+1)-idx(i) == num_sampl * num_steps
            i_start = (idx(i) - 1) * 16 + 1;
            i_end   = i_start + num_sampl * num_steps * 16 - 1;
            break;
        end
    end
    
    raw_data_in = data_pool(i_start:i_end);
    data_pool = data_pool(i_end+1:cur_size);

    rawData = swapbytes(typecast(uint8(raw_data_in),'int16'));
    rawData = reshape(typecast(int32(rawData),'uint32'), 8, []);
    xq = reshape( double(typecast(bitor(bitshift(rawData(1,:),4), bitshift(bitand(   15,rawData(7,:)),  0)),'int32')), [num_sampl, num_steps]);
    yq = reshape( double(typecast(bitor(bitshift(rawData(3,:),4), bitshift(bitand( 3840,rawData(7,:)), -8)),'int32')), [num_sampl, num_steps]);
    zq = reshape( double(typecast(bitor(bitshift(rawData(5,:),4), bitshift(bitand(   15,rawData(8,:)),  0)),'int32')), [num_sampl, num_steps]);
    xi = reshape( double(typecast(bitor(bitshift(rawData(2,:),4), bitshift(bitand(  240,rawData(7,:)), -4)),'int32')), [num_sampl, num_steps]);
    yi = reshape( double(typecast(bitor(bitshift(rawData(4,:),4), bitshift(bitand(61440,rawData(7,:)),-12)),'int32')), [num_sampl, num_steps]);
    zi = reshape( double(typecast(bitor(bitshift(rawData(6,:),4), bitshift(bitand(  240,rawData(8,:)), -4)),'int32')), [num_sampl, num_steps]);

    %cnt = bitshift(bitand(  768,rawData(8,:)), -8);     % 2bit  0000 0011 0000 0000  0x0300=768
    %swp = bitshift(bitand( 1024,rawData(8,:)),-10);     % 1bit  0000 0100 0000 0000  0x0400=1024
    %dec = bitshift(bitand( 6144,rawData(8,:)),-11);     % 2bit  0001 1000 0000 0000  0x1800=6144
    %ovf = bitshift(bitand(57344,rawData(8,:)),-13);     % 3bit  1110 0000 0000 0000  0xE000=57344

    % auto correlation
%    Xabs = sqrt( mean( xq.^2+xi.^2, 1 ) );
%    Yabs = sqrt( mean( yq.^2+yi.^2, 1 ) );
%    Zabs = sqrt( mean( zq.^2+zi.^2, 1 ) );
    Xabs = transpose(sqrt( mean( xq.^2+xi.^2, 1 ) ));
    Yabs = transpose(sqrt( mean( yq.^2+yi.^2, 1 ) ));
    Zabs = transpose(sqrt( mean( zq.^2+zi.^2, 1 ) ));
    spec.x = 20 * log10( Xabs ) + st_ctl.cf;  % [dBm @ ADC input]
    spec.y = 20 * log10( Yabs ) + st_ctl.cf;  % [dBm @ ADC input]
    spec.z = 20 * log10( Zabs ) + st_ctl.cf;  % [dBm @ ADC input]
    spec.xx = spec.x;
    spec.yy = spec.y;
    spec.zz = spec.z;

    % create dummy data
    nf = numel(spec.x);
    spec.re_xy = zeros(nf,1); spec.re_xy(:,1)=NaN;
    spec.im_xy = zeros(nf,1); spec.im_xy(:,1)=NaN;
    spec.re_yz = zeros(nf,1); spec.re_yz(:,1)=NaN;
    spec.im_yz = zeros(nf,1); spec.im_yz(:,1)=NaN;
    spec.re_zx = zeros(nf,1); spec.re_zx(:,1)=NaN;
    spec.im_zx = zeros(nf,1); spec.im_zx(:,1)=NaN;

    spec.matrix = 0;
    spec.xlog = 0;
    spec.ylog = 0;

end
