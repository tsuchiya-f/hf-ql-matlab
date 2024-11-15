function ret = hf_plot_autocorr_rich(st_rpw, st_ctl, auto)

    ret = 0;
        
    % set display layout
    fig=figure(st_ctl.hf);
    fig.Units = 'centimeters';
    fig.Position = [1.0 1.0 30.0 20.0];     %　[left bottom width height]
    tiledlayout(3,6);

    i_loop = 16;
    n = numel(auto.t);

    % Plot stream (x, y, and z) 
    for i=1:i_loop
        nexttile;
        intitle = sprintf('Ch:%d %7.1f kHz', i, auto.freq(i));
        plot(auto.t(2:n), auto.auto(2:n,i), '-');
        title  ( intitle );
        xlabel ('Time [sec]');
        ylabel ('Auto-Corr');
    end

    nexttile;
    semilogy(auto.freq,auto.amp_i,'-o');
    semilogy(auto.freq,auto.amp_q,'-o');
    xlabel ('Frequency');
    ylabel ('Amplitude');
    legend('Amp I','Amp Q')

end
