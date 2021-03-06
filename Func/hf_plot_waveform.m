function ret = hf_plot_waveform(wave)

    tm = wave.t;
    xi = wave.xi;
    xq = wave.xq;
    yi = wave.yi;
    yq = wave.yq;
    zi = wave.zi;
    zq = wave.zq;
    
    ret = 0;
    figure(st_ctl.hf)
    
    % set display layout
    tiledlayout(3,1)

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

    disp('Plot rich data')
    
end
