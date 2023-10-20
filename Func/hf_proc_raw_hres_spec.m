function spec_hres = hf_proc_raw_hres_spec(st_hfa, freq, wave)

    num_sampl = st_hfa.snum + 1;  % number of samples at each frequency step
    %num_steps = st_hfa.step + 1;  % number of frequency steps

    % sampling rate [kHz]
    sample_rate = [296.0 148.0 74.0 37.0];
    sr   = sample_rate(st_hfa.decimation+1);
    bw_eff = sr*0.75;

    [nt,nf] = size(wave.xi);
    win = window(@hann, nt);
    
    spec_hres.x = [];
    spec_hres.y = [];
    spec_hres.z = [];
    spec_hres.f = [];
    spec_hres.xlog = 0;
    spec_hres.ylog = 0;

    for i=1:nf
        xw = complex(wave.xi(:,i), wave.xq(:,i));
        yw = complex(wave.yi(:,i), wave.yq(:,i));
        zw = complex(wave.zi(:,i), wave.zq(:,i));

        xs = fft(xw .* win); xs = fftshift(xs); %xs = flip([xs(num_sampl/2+1:num_sampl) xs(1:num_sampl/2)]);
        ys = fft(yw .* win); ys = fftshift(ys); %ys = flip([ys(num_sampl/2+1:num_sampl) ys(1:num_sampl/2)]);
        zs = fft(zw .* win); zs = fftshift(zs); %zs = flip([zs(num_sampl/2+1:num_sampl) zs(1:num_sampl/2)]);

        freq_h = linspace(-sr*0.5,sr*0.5,num_sampl) + freq(i) + bw_eff * 0.5;  % [kHz]

        spec_hres.x = [spec_hres.x, NaN, transpose(20.0 * log10(abs(xs)))];
        spec_hres.y = [spec_hres.y, NaN, transpose(20.0 * log10(abs(ys)))];
        spec_hres.z = [spec_hres.z, NaN, transpose(20.0 * log10(abs(zs)))];
        spec_hres.f = [spec_hres.f, NaN, freq_h];
    end

    spec_hres.xx = spec_hres.x;
    spec_hres.yy = spec_hres.x;
    spec_hres.zz = spec_hres.y;

end
