function ret = hf_plot_waveform(st_ctl, wave)

    tm = wave.t;
    xi = wave.xi;
    xq = wave.xq;
    yi = wave.yi;
    yq = wave.yq;
    zi = wave.zi;
    zq = wave.zq;
    swp = wave.swp;
    
    ret = 0;
    fig=figure(st_ctl.hf);
    fig.Units = 'centimeters';
    fig.Position = [1.0 1.0 20.0 25.0];     %　[left bottom width height]
    
    % set display layout
    tiledlayout(4,1)

    nexttile(1)
    plot(tm,xq,'r',tm,xi,'b')
    title('Waveform X-ch Red:Xq,Blue:Xi')
    xlabel('Time [sec]')
    ylabel('ADC input [relative V]')

    nexttile(2)
    plot(tm,yq,'r',tm,yi,'b')
    title('Waveform Y-ch Red:Yq,Blue:Yi')
    xlabel('Time [sec]')
    ylabel('ADC input [relative V]')

    nexttile(3)
    plot(tm,zq,'r',tm,zi,'b')
    title('Waveform Z-ch Red:Zq,Blue:Zi')
    xlabel('Time [sec]')
    ylabel('ADC input [relative V]')

    nexttile(4)
    plot(tm,swp,'r*')
    title('Sweep start')
    xlabel('Time [sec]')
    ylabel('Flag')

    disp('Plot rich data')
    
end
