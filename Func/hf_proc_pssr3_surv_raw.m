function [ret, auto, wave, spec] = hf_proc_pssr3_surv_raw(st_ctl, st_aux, st_hfa, raw_data)
    ret = 0;

    len=length(raw_data);

    % -------------------------------------------
    % amplitude data
    % -------------------------------------------
    n_freq = st_aux.n_block; 

    % for amplitude data
    len_amp = n_freq * 2;
    amp_data16 = swapbytes(typecast(uint8(raw_data(1:len_amp)),'uint32'));
    amp_data = hf_minifloat_FP16(amp_data16) * st_ctl.level_bias_pssr2;

    auto.n_freq = n_freq;
    auto.freq = 1:n_freq;                       % block No.
    auto.amp_i  = amp_data(1:n_freq);           % rms amplitude of I waveform
    auto.amp_q  = amp_data(n_freq+1:n_freq*2);  % rms amplitude of Q waveform

    % -------------------------------------------
    % raw waveform data
    % -------------------------------------------    
    sample_rate = [296000 148000 74000 37000];

    fs   = sample_rate(st_hfa.decimation+1);  % sampling rate of decimated waveform [Hz]
    block_sel = st_aux.send_reg;     % number of feed frames in one block
    n_frame = st_aux.n_lag;      % number of block in one packet

    ns   = 128;                 % number of data sample in one frame (fixed)
    num_sampl = n_frame * ns;      % number of data sample

    % conversion factor from ADC value to enginnering value
    cw = 1.46/2^20;             % ADC value to Volt

    % waveform data
    rdata = swapbytes(typecast(uint8(raw_data(len_amp+1:len)),'int16'));
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
    t = linspace(0,num_sampl/fs,num_sampl);
    wave.t = t;

    spec.f = linspace(-fs*0.5,fs*0.5,num_sampl);
    % waveform to spectrum
    x = complex(wave.xi,wave.xq);
    y = complex(wave.yi,wave.yq);
    z = complex(wave.zi,wave.zq);
    spec.x = abs(fft(x));
    spec.y = abs(fft(y));
    spec.z = abs(fft(z));
    spec.x = [spec.x(num_sampl/2+1:num_sampl) spec.x(1:num_sampl/2)];
    spec.y = [spec.y(num_sampl/2+1:num_sampl) spec.y(1:num_sampl/2)];
    spec.z = [spec.z(num_sampl/2+1:num_sampl) spec.z(1:num_sampl/2)];
    
    spec.log = 1;

end
