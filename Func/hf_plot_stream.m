function ret = hf_plot_stream(st_ctl, stream)

    ret = 0;
    
    fig=figure(st_ctl.hf);
    fig.Units = 'centimeters';
    fig.Position = [1.0 1.0 15.0 11.0];     %　[left bottom width height]

    % set display layout
    tiledlayout(1,1)

    % Plot stream (x, y, and z) 
    plot(stream.tm, stream.x,'r', stream.tm, stream.y,'g', stream.tm, stream.z,'b')            
    xlabel ('Time [sec]');
    ylabel ('Power [dBm]');

end
