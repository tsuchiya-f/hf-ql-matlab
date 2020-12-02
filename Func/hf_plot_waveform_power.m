function ret = hf_plot_waveform_power(st_ctl, wave, spec)

    tm = wave.t;
    xi = wave.xi;
    xq = wave.xq;
    yi = wave.yi;
    yq = wave.yq;
    zi = wave.zi;
    zq = wave.zq;
    
    f = spec.f;
    x = spec.x;
    y = spec.y;
    z = spec.z;
    
    ret = 0;
    figure(st_ctl.hf)
    
    % set display layout
    tiledlayout(4,1)

    nexttile(1)
    plot(tm,xq,'r',tm,xi,'b')
    title('Waveform X-ch Red:Xq,Blue:Xi')
    xlabel('Time [sec]')
    ylabel('ADC input [V]')

    nexttile(2)
    plot(tm,yq,'r',tm,yi,'b')
    title('Waveform Y-ch Red:Yq,Blue:Yi')
    xlabel('Time [sec]')
    ylabel('ADC input [V]')

    nexttile(3)
    plot(tm,zq,'r',tm,zi,'b')
    title('Waveform Z-ch Red:Zq,Blue:Zi')
    xlabel('Time [sec]')
    ylabel('ADC input [V]')

    nexttile(4)
    if spec.log == 0
       plot(f/1e6, x,'r', f/1e6, y,'g', f/1e6, z,'b')
    else
       semilogy(f/1e6, x,'r', f/1e6, y,'g', f/1e6, z,'b')
    end
            
    [xmax,ix] = max(x);
    [ymax,iy] = max(y);
    [zmax,iz] = max(z);
    dmax      = [xmax,ymax,zmax];
    imax      = [ix,iy,iz];
    [~,im]   = max(dmax);
    p_freq = f(imax(im)) / 1e6;
    title(['Peak at　' num2str(p_freq,'%0.2f') ' MHz  Red(X)[' num2str(x(imax(im)),'%0.1f') '] Green(Y)[' num2str(y(imax(im)),'%0.1f') '] Blue(Z)[' num2str(z(imax(im)),'%0.1f') '] dBm']);

    disp('Plot rich data')
    
end
