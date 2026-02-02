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
        intitle = sprintf('Ch:%d %7.1f kHz', i, auto.f(i));
        %plot(auto.t(2:n), auto.auto(2:n,i), '-');
        plot(auto.t(1:n), auto.auto(1:n,i), '-');
        title  ( intitle );
        xlabel ('data number');
%        xlabel ('Time [sec]');
        ylabel ('Auto-Corr');
    end

    nexttile;
    semilogy(auto.amp_i,'-o');
    xlabel ('Freq bin');
    ylabel ('Amplitude');
    legend('Amp I')
    [dmax,imax] = max(auto.amp_i);
    p_freq = auto.f(imax);
    title(['Peak at　' num2str(p_freq/1000,'%0.3f') 'MHz [' num2str(dmax') ']']);

end
