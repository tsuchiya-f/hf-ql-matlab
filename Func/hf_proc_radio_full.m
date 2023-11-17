function  [ret, spec] = hf_proc_radio_full(st_ctl, st_aux, st_hfa, raw_data)

    ret = 0;

    % frequency
    spec.f = hf_get_freq_table(st_ctl.ver, st_aux, st_hfa);
    
    % conversion factor from ADC value to enginnering value
    cf = st_ctl.cf;    % mean power of ADC value to dBm (for rms data)
    
    % data format (size)
    nf = st_hfa.total_step;         % number of frequeucy bins

    % number of available channel
    n_ch = st_ctl.n_ch;
    switch n_ch
        %------------
        % 3-ch mode
        %------------
        case 3
        switch st_aux.complex_sel       % number of data set
            case 0
                nk = 3 + double(st_aux.bg_downlink);
            case 1
                nk = 9 + double(st_aux.bg_downlink);
            case 2
                nk = 27 + double(st_aux.bg_downlink);
            case 3
                nk = 21 + double(st_aux.bg_downlink);
        end
        %------------
        % 2-ch mode
        %------------
        case 2
        switch st_aux.complex_sel       % number of data set
            case 0
                nk = 2 + double(st_aux.bg_downlink);
            case 1
                nk = 4 + double(st_aux.bg_downlink);
            case 2
                nk = 12 + double(st_aux.bg_downlink);
        end
    end

    % expected data length
    len = nf * nk * 4;          % (Bytes)
    len_12 = nf * nk * 16 / 8;  % (Bytes)
    len_sum = nf * 2 * 3;           % (Bytes)
    if st_aux.complex_sel == 2
        len_total = len + len_sum;
        len_total_12 = len_12 + len_sum;
    else
        len_total = len;
        len_total_12 = len_12;
    end    
    
    % interpretaion of data (4-Byte float or 12-bit MiniFloat)
    raw_data8 = uint8(raw_data);
    if numel(raw_data) == len_total
        % 4-Byte float
        data = swapbytes(typecast(raw_data8(1:len),'single'));
        if st_aux.complex_sel == 2
            n_sum = swapbytes(typecast(raw_data8(len+1:len_total),'uint16'));
            n_sum = reshape(n_sum, nf, 3, []);
        end
    elseif numel(raw_data) == len_total_12
        % convert 12-bit minifloat to 4-Byte float
        data12 = swapbytes(typecast(raw_data8(1:len_12),'uint32'));
        data = hf_minifloat16(data12);
        if st_aux.complex_sel == 2
            n_sum = swapbytes(typecast(raw_data8(len_12+1:len_total_12),'uint16'));
            n_sum = reshape(n_sum, nf, 3, []);
        end
    else
        fprintf("***** ERROR : invalid data length\n");
        pause
    end

    %  for SW ver.1
    if st_ctl.ver == 1
        
        data = reshape(data(1:nf*nk), nf, nk, []);
        % spectral matrix
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
        
        % auto spectra
        spec.x = 10*log10(spec.xx) + cf;  % [dBm @ ADC input]
        spec.y = 10*log10(spec.yy) + cf;  % [dBm @ ADC input]
        spec.z = 10*log10(spec.zz) + cf;  % [dBm @ ADC input]
        spec.xx = spec.x;
        spec.yy = spec.y;
        spec.zz = spec.z;
        
        spec.matrix = 0;
        spec.xlog = 0;
        spec.ylog = 0;
        
        return
    end
    
    % spectram data
    switch n_ch
        %------------
        % 3-ch mode
        %------------
        case 3
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

                idx = find(spec.xx < 0.0);
                spec.xx(idx) = NaN;
                spec.yy(idx) = NaN;
                spec.zz(idx) = NaN;

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

                idx = find(spec.xx < 0.0);
                spec.xx(idx) = NaN;
                spec.yy(idx) = NaN;
                spec.zz(idx) = NaN;
                spec.re_xy(idx) = NaN;
                spec.im_xy(idx) = NaN;
                spec.re_yz(idx) = NaN;
                spec.im_yz(idx) = NaN;
                spec.re_zx(idx) = NaN;
                spec.im_zx(idx) = NaN;

                % auto spectra
                spec.x = 10*log10(spec.xx) + cf;  % [dBm @ ADC input]
                spec.y = 10*log10(spec.yy) + cf;  % [dBm @ ADC input]
                spec.z = 10*log10(spec.zz) + cf;  % [dBm @ ADC input]

                spec.matrix = 1;   % nominal 2D spectral matrix (1)
            
             case 2
                data = reshape(data(1:nf*nk), nf, nk, []);
                spec.x     = zeros(nf,3);
                spec.y     = zeros(nf,3);
                spec.z     = zeros(nf,3);
                spec.xx    = zeros(nf,3);
                spec.yy    = zeros(nf,3);
                spec.zz    = zeros(nf,3);
                spec.re_xy = zeros(nf,3);
                spec.im_xy = zeros(nf,3);
                spec.re_yz = zeros(nf,3);
                spec.im_yz = zeros(nf,3);
                spec.re_zx = zeros(nf,3);
                spec.im_zx = zeros(nf,3);

                % --- number of sum ---
                spec.n_sum = n_sum;
                % --- no-pol ---
                % spectral matrix
                spec.xx(:,1)    = data(:,1);
                spec.yy(:,1)    = data(:,2);
                spec.zz(:,1)    = data(:,3);
                spec.re_xy(:,1) = data(:,4);
                spec.im_xy(:,1) = data(:,5);
                spec.re_yz(:,1) = data(:,6);
                spec.im_yz(:,1) = data(:,7);
                spec.re_zx(:,1) = data(:,8);
                spec.im_zx(:,1) = data(:,9);
                % auto spectra
                spec.x(:,1) = 10*log10(spec.xx(:,1)) + cf;  % [dBm @ ADC input]
                spec.y(:,1) = 10*log10(spec.yy(:,1)) + cf;  % [dBm @ ADC input]
                spec.z(:,1) = 10*log10(spec.zz(:,1)) + cf;  % [dBm @ ADC input]
                
                % --- positive pol ---
                % spectral matrix
                spec.xx(:,2)    = data(:,10);
                spec.yy(:,2)    = data(:,11);
                spec.zz(:,2)    = data(:,12);
                spec.re_xy(:,2) = data(:,13);
                spec.im_xy(:,2) = data(:,14);
                spec.re_yz(:,2) = data(:,15);
                spec.im_yz(:,2) = data(:,16);
                spec.re_zx(:,2) = data(:,17);
                spec.im_zx(:,2) = data(:,18);
                % auto spectra
                spec.x(:,2) = 10*log10(spec.xx(:,2)) + cf;  % [dBm @ ADC input]
                spec.y(:,2) = 10*log10(spec.yy(:,2)) + cf;  % [dBm @ ADC input]
                spec.z(:,2) = 10*log10(spec.zz(:,2)) + cf;  % [dBm @ ADC input]
                % --- negative pol ---
                % spectral matrix
                spec.xx(:,3)    = data(:,19);
                spec.yy(:,3)    = data(:,20);
                spec.zz(:,3)    = data(:,21);
                spec.re_xy(:,3) = data(:,22);
                spec.im_xy(:,3) = data(:,23);
                spec.re_yz(:,3) = data(:,24);
                spec.im_yz(:,3) = data(:,25);
                spec.re_zx(:,3) = data(:,26);
                spec.im_zx(:,3) = data(:,27);
                
                % auto spectra
                spec.x(:,3) = 10*log10(spec.xx(:,3)) + cf;  % [dBm @ ADC input]
                spec.y(:,3) = 10*log10(spec.yy(:,3)) + cf;  % [dBm @ ADC input]
                spec.z(:,3) = 10*log10(spec.zz(:,3)) + cf;  % [dBm @ ADC input]
                
                % set NAN value to invalid data
                for i=1:3
                    idx = find(spec.xx(:,i) < 1.0);
                    spec.xx(idx,i) = NaN;
                    spec.yy(idx,i) = NaN;
                    spec.zz(idx,i) = NaN;
                    spec.re_xy(idx,i) = NaN;
                    spec.im_xy(idx,i) = NaN;
                    spec.re_yz(idx,i) = NaN;
                    spec.im_yz(idx,i) = NaN;
                    spec.re_zx(idx,i) = NaN;
                    spec.im_zx(idx,i) = NaN;
                    spec.x(idx,i) = NaN;
                    spec.y(idx,i) = NaN;
                    spec.z(idx,i) = NaN;
                end

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

                idx = find(spec.UiUi < 0.0);
                spec.UiUi(idx) = NaN;
                spec.VrVr(idx) = NaN;
                spec.ViVi(idx) = NaN;
                spec.WrWr(idx) = NaN;
                spec.WiWi(idx) = NaN;
                spec.UrVr(idx) = NaN;
                spec.VrWr(idx) = NaN;
                spec.WrUr(idx) = NaN;
                spec.UiVi(idx) = NaN;
                spec.ViWi(idx) = NaN;
                spec.WiUi(idx) = NaN;
                spec.UrVi(idx) = NaN;
                spec.UiVr(idx) = NaN;
                spec.VrWi(idx) = NaN;
                spec.ViWr(idx) = NaN;
                spec.WrUi(idx) = NaN;
                spec.WiUr(idx) = NaN;
                spec.UrUi(idx) = NaN;
                spec.VrVi(idx) = NaN;
                spec.WrWi(idx) = NaN;

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
        
        %------------
        % 2-ch mode (here, x=ch1, y=ch2)
        %------------
        case 2
        switch st_aux.complex_sel       % number of data set
            case 0
                data = reshape(data(1:nf*nk), nf, nk, []);
                spec.xx = data(:,1);
                spec.yy = data(:,2);
                % auto spectra
                spec.x = 10*log10(spec.xx) + cf;  % [dBm @ ADC input]
                spec.y = 10*log10(spec.yy) + cf;  % [dBm @ ADC input]

               % create dummy data
                spec.zz = zeros(nf,1);   spec.zz(:,1)=NaN;
                spec.z = zeros(nf,1);    spec.z(:,1)=NaN;
                spec.re_xy = zeros(nf,1); spec.re_xy(:,1)=NaN;
                spec.im_xy = zeros(nf,1); spec.im_xy(:,1)=NaN;
                spec.re_yz = zeros(nf,1); spec.re_yz(:,1)=NaN;
                spec.im_yz = zeros(nf,1); spec.im_yz(:,1)=NaN;
                spec.re_zx = zeros(nf,1); spec.re_zx(:,1)=NaN;
                spec.im_zx = zeros(nf,1); spec.im_zx(:,1)=NaN;

                spec.matrix = 0;
            
            case 1
                data = reshape(data(1:nf*nk), nf, nk, []);
                % spectral matrix
                spec.xx = data(:,1);
                spec.yy = data(:,2);
                spec.re_xy = data(:,3);
                spec.im_xy = data(:,4);
                % auto spectra
                spec.x = 10*log10(spec.xx) + cf;  % [dBm @ ADC input]
                spec.y = 10*log10(spec.yy) + cf;  % [dBm @ ADC input]

               % create dummy data
                spec.zz = zeros(nf,1);   spec.zz(:,1)=NaN;
                spec.z = zeros(nf,1);    spec.z(:,1)=NaN;
                spec.re_yz = zeros(nf,1); spec.re_yz(:,1)=NaN;
                spec.im_yz = zeros(nf,1); spec.im_yz(:,1)=NaN;
                spec.re_zx = zeros(nf,1); spec.re_zx(:,1)=NaN;
                spec.im_zx = zeros(nf,1); spec.im_zx(:,1)=NaN;

                spec.matrix = 1;
            
             case 2
                data = reshape(data(1:nf*nk), nf, nk, []);
                spec.x     = zeros(nf,3);
                spec.y     = zeros(nf,3);
                spec.z     = zeros(nf,3);   % dummy
                spec.xx    = zeros(nf,3);
                spec.yy    = zeros(nf,3);
                spec.zz    = zeros(nf,3);   % dummy
                spec.re_xy = zeros(nf,3);
                spec.im_xy = zeros(nf,3);
                spec.re_yz = zeros(nf,3);   % dummy
                spec.im_yz = zeros(nf,3);   % dummy
                spec.re_zx = zeros(nf,3);   % dummy
                spec.im_zx = zeros(nf,3);   % dummy
                % --- number of sum ---
                spec.n_sum = n_sum;
                % --- no-pol ---
                % spectral matrix
                spec.xx(:,1)    = data(:,1);
                spec.yy(:,1)    = data(:,2);
                spec.re_xy(:,1) = data(:,3);
                spec.im_xy(:,1) = data(:,4);
                % auto spectra
                spec.x(:,1) = 10*log10(spec.xx(:,1)) + cf;  % [dBm @ ADC input]
                spec.y(:,1) = 10*log10(spec.yy(:,1)) + cf;  % [dBm @ ADC input]
                % --- positive pol ---
                % spectral matrix
                spec.xx(:,2)    = data(:,5);
                spec.yy(:,2)    = data(:,6);
                spec.re_xy(:,2) = data(:,7);
                spec.im_xy(:,2) = data(:,8);
                % auto spectra
                spec.x(:,2) = 10*log10(spec.xx(:,2)) + cf;  % [dBm @ ADC input]
                spec.y(:,2) = 10*log10(spec.yy(:,2)) + cf;  % [dBm @ ADC input]
                % --- negative pol ---
                % spectral matrix
                spec.xx(:,3)    = data(:,9);
                spec.yy(:,3)    = data(:,10);
                spec.re_xy(:,3) = data(:,11);
                spec.im_xy(:,3) = data(:,12);

                % auto spectra
                spec.x(:,3) = 10*log10(spec.xx(:,3)) + cf;  % [dBm @ ADC input]
                spec.y(:,3) = 10*log10(spec.yy(:,3)) + cf;  % [dBm @ ADC input]
          
                % set NAN value to invalid data
                for i=1:3
                    idx = find(spec.xx(:,i) < 0.0);
                    spec.xx(idx,i) = NaN;
                    spec.yy(idx,i) = NaN;
                    spec.re_xy(idx,i) = NaN;
                    spec.im_xy(idx,i) = NaN;
                    spec.x(idx,i) = NaN;
                    spec.y(idx,i) = NaN;
                end
                
                spec.matrix = 1;

        end      
        
    end
    
    %------------
    % common for 2 & 3-ch mode
    %------------
    % noise floor
    n_ofs = nk - st_aux.bg_downlink;
    switch st_aux.bg_downlink
        case 1
            spec.noise_floor_x = data(:,n_ofs+1);
            spec.noise_floor_y = data(:,n_ofs+1);
            spec.noise_floor_z = data(:,n_ofs+1);
        case 2
            spec.noise_floor_x = data(:,n_ofs+1);
            spec.noise_floor_y = data(:,n_ofs+2);
            spec.noise_floor_z = zeros(nf,1); spec.noise_floor_z(:,1)=NaN;
        case 3
            spec.noise_floor_x = data(:,n_ofs+1);
            spec.noise_floor_y = data(:,n_ofs+2);
            spec.noise_floor_z = data(:,n_ofs+3);
    end    
    spec.xlog = 0;
    spec.ylog = 0;

end
