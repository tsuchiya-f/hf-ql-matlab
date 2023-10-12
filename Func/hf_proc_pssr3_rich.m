function [ret, wave, spec] = hf_proc_pssr3_rich(ver, st_aux, st_hfa, raw_data)

    ret = 0;
    sample_rate = [296000 148000 74000 37000];

    % for rich data
    fs   = sample_rate(st_aux.decimation+1);  % sampling rate of decimated waveform [Hz]
    feed = st_aux.send_reg;     % number of feed frames in one block
    skip = st_aux.skip_reg;     % number of skip frames in one block
    nb   = st_aux.n_block;      % number of block in one packet

    ns   = 128;                 % number of data sample in one frame (fixed)
    num_sampl = feed * ns;      % number of data sample in one block

    % conversion factor from ADC value to enginnering value
    cw = 1.46/2^20;             % ADC value to Volt

    % -------------------------------------------
    % rich data (waveform)
    % -------------------------------------------
    
    % waveform data
    rdata = swapbytes(typecast(uint8(raw_data),'int16'));
    rdata = reshape(typecast(int32(rdata),'uint32'), 8, []);

    % decode waveform data
    wave.xq = double(typecast(bitor(bitshift(rdata(1,:),4), bitshift(bitand(   15,rdata(7,:)),  0)),'int32'));
    wave.yq = double(typecast(bitor(bitshift(rdata(3,:),4), bitshift(bitand( 3840,rdata(7,:)), -8)),'int32'));
    wave.zq = double(typecast(bitor(bitshift(rdata(5,:),4), bitshift(bitand(   15,rdata(8,:)),  0)),'int32'));
    wave.xi = double(typecast(bitor(bitshift(rdata(2,:),4), bitshift(bitand(  240,rdata(7,:)), -4)),'int32'));
    wave.yi = double(typecast(bitor(bitshift(rdata(4,:),4), bitshift(bitand(61440,rdata(7,:)),-12)),'int32'));
    wave.zi = double(typecast(bitor(bitshift(rdata(6,:),4), bitshift(bitand(  240,rdata(8,:)), -4)),'int32'));

    % convert to enginering value
    wave.xq = wave.xq * cw; % [Volt]
    wave.yq = wave.yq * cw;
    wave.zq = wave.zq * cw;
    wave.xi = wave.xi * cw;
    wave.yi = wave.yi * cw;
    wave.zi = wave.zi * cw;

    %nb  = numel(wave.xq)/num_sampl;      % number of block in one packet

    % time data [sec]
    t = zeros(1,feed*ns*nb);
    for i=0:nb-1
        t(1+feed*ns*i:feed*ns*(i+1)) = (feed+skip)*ns*i/fs + (1:feed*ns)/fs;
    end
    wave.t = t;

    spec.f = linspace(-fs*0.5,fs*0.5,feed*ns);
    % waveform to spectrum
    x = reshape(complex(wave.xi,wave.xq),[num_sampl,nb]);
    y = reshape(complex(wave.yi,wave.yq),[num_sampl,nb]);
    z = reshape(complex(wave.zi,wave.zq),[num_sampl,nb]);
    spec.x = abs(fft(x));
    spec.y = abs(fft(y));
    spec.z = abs(fft(z));
    spec.x = [spec.x(num_sampl/2+1:num_sampl) spec.x(1:num_sampl/2)];
    spec.y = [spec.y(num_sampl/2+1:num_sampl) spec.y(1:num_sampl/2)];
    spec.z = [spec.z(num_sampl/2+1:num_sampl) spec.z(1:num_sampl/2)];
%    spec.x = flip([spec.x(num_sampl/2+1:num_sampl) spec.x(1:num_sampl/2)]);
%    spec.y = flip([spec.y(num_sampl/2+1:num_sampl) spec.y(1:num_sampl/2)]);
%    spec.z = flip([spec.z(num_sampl/2+1:num_sampl) spec.z(1:num_sampl/2)]);
    
    spec.log = 1;

end
