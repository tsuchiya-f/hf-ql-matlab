function hf_plot_ft(st_ctl)

    global st_data_spec

    % set figure size
    fig=figure(st_ctl.hf);
    fig.Units = 'centimeters';
    fig.Position = [1.0 1.0 20.0 25.0];     %　[left bottom width height]

    tiledlayout(4,1)

    freq = st_data_spec.f(1,:);
    x_pow = transpose(st_data_spec.x);
    y_pow = transpose(st_data_spec.y);
    z_pow = transpose(st_data_spec.z);
    time = st_data_spec.t;
        
    c_min = min([x_pow y_pow z_pow],[],'all');
    c_max = max([x_pow y_pow z_pow],[],'all');
    clims = [c_min, c_max];
    
    nexttile(1)
    imagesc(time, freq, x_pow, clims)
%    imagesc(time, freq, x_pow)
    colorbar
    
    nexttile(2)
    imagesc(time, freq, y_pow, clims)
%    imagesc(time, freq, y_pow)
    colorbar
    
    nexttile(3)
    imagesc(time, freq, z_pow, clims)
%    imagesc(time, freq, z_pow)
    colorbar

    nexttile(4)
    sp_x = mean(x_pow,2);
    sp_y = mean(y_pow,2);
    sp_z = mean(z_pow,2);
    plot(freq/1000, sp_x, 'r', freq/1000, sp_y, 'g', freq/1000, sp_z, 'b');
    title('Mean spectra Red:X Green:Y Blue:Z');
    xlabel ('Frequency [MHz]');
    ylabel ('Power [rel]');
    ylim([-90,0]);

end