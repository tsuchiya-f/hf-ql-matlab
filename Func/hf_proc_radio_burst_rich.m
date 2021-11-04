function  [ret, spec] = hf_proc_radio_burst_rich(st_ctl, st_aux, st_hfa, raw_data)

    ret = 0;

    % frequency
    spec.f = hf_get_freq_table(st_ctl.ver, st_aux, st_hfa);
    
    % conversion factor from ADC value to enginnering value
    %cf = -104.1;    % mean power of ADC value to dBm (for rms data)
    cf = 0.0;
    
    % data format (size)
    nf = st_hfa.total_step;         % number of frequeucy bins

    % number of available channel
    switch st_aux.complex_sel       % number of data set
        case 0
            nk = 3;
        case 1
            nk = 9;
        case 3
            nk = 21;
    end

    % expected data length
    len = nf * nk * 4;          % (Bytes)
    len_12 = nf * nk * 16 / 8;  % (Bytes)
    
    % interpretaion of data (4-Byte float or 12-bit MiniFloat)
    raw_data8 = uint8(raw_data);
    if numel(raw_data) == len
        % 4-Byte float
        data = swapbytes(typecast(raw_data8(1:len),'single'));
    elseif numel(raw_data) == len_12
        % convert 12-bit minifloat to 4-Byte float
        data12 = swapbytes(typecast(raw_data8(1:len_12),'uint32'));
        data = hf_minifloat16(data12);
    else
        fprintf("***** ERROR : invalid data length\n");
        pause
    end

    % spectram data
    switch st_aux.complex_sel       % number of data set
        case 0
            data = reshape(data(1:nf*nk), nf, nk, []);
            spec.xx = data(:,1);
            spec.yy = data(:,2);
            spec.zz = data(:,3);
            % create dummy data
            spec.re_xy = zeros(nf,1); spec.re_xy(:,1)=NaN;
            spec.im_xy = zeros(nf,1); spec.im_xy(:,1)=NaN;
            spec.re_yz = zeros(nf,1); spec.re_yz(:,1)=NaN;
            spec.im_yz = zeros(nf,1); spec.im_yz(:,1)=NaN;
            spec.re_zx = zeros(nf,1); spec.re_zx(:,1)=NaN;
            spec.im_zx = zeros(nf,1); spec.im_zx(:,1)=NaN;

%            idx = find(spec.xx < 0.0);
%            spec.xx(idx) = NaN;
%            spec.yy(idx) = NaN;
%            spec.zz(idx) = NaN;

            % auto spectra
            spec.x = 10*log10(spec.xx) + cf;  % [dBm @ ADC input]
            spec.y = 10*log10(spec.yy) + cf;  % [dBm @ ADC input]
            spec.z = 10*log10(spec.zz) + cf;  % [dBm @ ADC input]

            spec.matrix = 0;   % power spectra only (0)
            
        case 1
            data = reshape(data(1:nf*nk), nf, nk, []);
            % spectral matrix
            spec.xx = data(:,1);
            spec.yy = data(:,2);
            spec.zz = data(:,3);
            spec.re_xy = data(:,4);
            spec.im_xy = data(:,5);
            spec.re_yz = data(:,6);
            spec.im_yz = data(:,7);
            spec.re_zx = data(:,8);
            spec.im_zx = data(:,9);

%            idx = find(spec.xx < 0.0);
%            spec.xx(idx) = NaN;
%            spec.yy(idx) = NaN;
%            spec.zz(idx) = NaN;
%            spec.re_xy(idx) = NaN;
%            spec.im_xy(idx) = NaN;
%            spec.re_yz(idx) = NaN;
%            spec.im_yz(idx) = NaN;
%            spec.re_zx(idx) = NaN;
%            spec.im_zx(idx) = NaN;

            % auto spectra
            spec.x = 10*log10(spec.xx) + cf;  % [dBm @ ADC input]
            spec.y = 10*log10(spec.yy) + cf;  % [dBm @ ADC input]
            spec.z = 10*log10(spec.zz) + cf;  % [dBm @ ADC input]

            spec.matrix = 1;   % nominal 2D spectral matrix (1)
            
        case 3
            data = reshape(data(1:nf*nk), nf, nk, []);
            % spectral matrix
            spec.UrUr = data(:,1);
            spec.UiUi = data(:,2);
            spec.VrVr = data(:,3);
            spec.ViVi = data(:,4);
            spec.WrWr = data(:,5);
            spec.WiWi = data(:,6);

            spec.UrVr = data(:,7);
            spec.VrWr = data(:,8);
            spec.WrUr = data(:,9);

            spec.UiVi = data(:,10);
            spec.ViWi = data(:,11);
            spec.WiUi = data(:,12);

            spec.UrVi = data(:,13);
            spec.UiVr = data(:,14);
            spec.VrWi = data(:,15);
            spec.ViWr = data(:,16);
            spec.WrUi = data(:,17);
            spec.WiUr = data(:,18);

            spec.UrUi = data(:,19);
            spec.VrVi = data(:,20);
            spec.WrWi = data(:,21);

%            idx = find(spec.UiUi < 0.0);
%            spec.UiUi(idx) = NaN;
%            spec.VrVr(idx) = NaN;
%            spec.ViVi(idx) = NaN;
%            spec.WrWr(idx) = NaN;
%            spec.WiWi(idx) = NaN;
%            spec.UrVr(idx) = NaN;
%            spec.VrWr(idx) = NaN;
%            spec.WrUr(idx) = NaN;
%            spec.UiVi(idx) = NaN;
%            spec.ViWi(idx) = NaN;
%            spec.WiUi(idx) = NaN;
%            spec.UrVi(idx) = NaN;
%            spec.UiVr(idx) = NaN;
%            spec.VrWi(idx) = NaN;
%            spec.ViWr(idx) = NaN;
%            spec.WrUi(idx) = NaN;
%            spec.WiUr(idx) = NaN;
%            spec.UrUi(idx) = NaN;
%            spec.VrVi(idx) = NaN;
%            spec.WrWi(idx) = NaN;

            % auto spectra
            spec.xx = spec.UrUr + spec.UiUi;
            spec.yy = spec.VrVr + spec.ViVi;
            spec.zz = spec.WrWr + spec.WiWi;
            spec.x = 10*log10(spec.UrUr + spec.UiUi) + cf;  % [dBm @ ADC input]
            spec.y = 10*log10(spec.VrVr + spec.ViVi) + cf;  % [dBm @ ADC input]
            spec.z = 10*log10(spec.WrWr + spec.WiWi) + cf;  % [dBm @ ADC input]
            spec.re_xy =   spec.UrVr + spec.UiVi;
            spec.im_xy = - spec.UrVi + spec.UiVr;
            spec.re_yz =   spec.VrWr + spec.ViWi;
            spec.im_yz = - spec.VrWi + spec.ViWr;
            spec.re_zx =   spec.WrUr + spec.WiUi;
            spec.im_zx = - spec.WrUi + spec.WiUr;

            spec.matrix = 2;   % 3D spectral matrix (2)
    end
    spec.xlog = 0;
    spec.ylog = 0;

end
