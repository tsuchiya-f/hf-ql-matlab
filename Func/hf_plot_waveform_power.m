function ret = hf_plot_waveform_power(st_ctl, wave, spec)

    ret = 0;

    % set figure size
    fig=figure(st_ctl.hf);
    fig.Units = 'centimeters';
    fig.Position = [1.0 1.0 20.0 25.0];     %　[left bottom width height]

    % set display layout
    tiledlayout(7,1)

    % X-ch (full time span) 
    nexttile(1)
    plot(wave.t,wave.xq,'r',wave.t,wave.xi,'b')
    title('Waveform X-ch Red:Xq / Blue:Xi')
    xlabel('Time [sec]')
    ylabel('ADC input [V]')

    % X-ch (first 100 points) 
    nexttile(2)
    plot(wave.t(1:100),wave.xq(1:100),'r',wave.t(1:100),wave.xi(1:100),'b')
    title('Waveform X-ch (the first 100 points) Red:Xq / Blue:Xi')
    xlabel('Time [sec]')
    ylabel('ADC input [V]')

    % Y-ch (full time span) 
    nexttile(3)
    plot(wave.t,wave.yq,'r',wave.t,wave.yi,'b')
    title('Waveform Y-ch Red:Yq / Blue:Yi')
    xlabel('Time [sec]')
    ylabel('ADC input [V]')

    % Y-ch (first 100 points) 
    nexttile(4)
    plot(wave.t(1:100),wave.yq(1:100),'r',wave.t(1:100),wave.yi(1:100),'b')
    title('Waveform Y-ch (the first 100 points) Red:Yq / Blue:Yi')
    xlabel('Time [sec]')
    ylabel('ADC input [V]')

    % Z-ch (full time span) 
    nexttile(5)
    plot(wave.t,wave.zq,'r',wave.t,wave.zi,'b')
    title('Waveform Z-ch Red:Zq / Blue:Zi')
    xlabel('Time [sec]')
    ylabel('ADC input [V]')

    % Z-ch (first 100 points) 
    nexttile(6)
    plot(wave.t(1:100),wave.zq(1:100),'r',wave.t(1:100),wave.zi(1:100),'b')
    title('Waveform Z-ch (the first 100 points) Red:Zq / Blue:Zi')
    xlabel('Time [sec]')
    ylabel('ADC input [V]')

    % Spectra
    nexttile(7)
    if spec.log == 0
       plot(spec.f/1e6, spec.x,'r', spec.f/1e6, spec.y,'g', spec.f/1e6, spec.z,'b')
    else
       semilogy(spec.f/1e6, spec.x,'r', spec.f/1e6, spec.y,'g', spec.f/1e6, spec.z,'b')
    end
            
    [xmax,ix] = max(spec.x);
    [ymax,iy] = max(spec.y);
    [zmax,iz] = max(spec.z);
    dmax      = [xmax,ymax,zmax];
    imax      = [ix,iy,iz];
    [~,im]   = max(dmax);
    p_freq = spec.f(imax(im)) / 1e6;
    title(['Peak at　' num2str(p_freq,'%0.2f') ' MHz  Red(X)[' num2str(spec.x(imax(im)),'%0.1f') '] Green(Y)[' num2str(spec.y(imax(im)),'%0.1f') '] Blue(Z)[' num2str(spec.z(imax(im)),'%0.1f') '] dBm']);
    xlabel('Frequency [MHz]')
    ylabel (st_ctl.power_unit);

%    disp('Plot rich data')
    
end
