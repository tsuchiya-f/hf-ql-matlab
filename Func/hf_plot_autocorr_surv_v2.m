function ret = hf_plot_autocorr_surv_v2(st_rpw, st_ctl, auto)

    ret = 0;

    intitle='PSSR2 Survey (V2)';
    n_fig=1;
    n_tile=n_fig+1;
    
    % set display layout
    fig=figure(st_ctl.hf);
    fig.Units = 'centimeters';
    fig.Position = [1.0 1.0 15.0 20.0];     %　[left bottom width height]
    tiledlayout(n_tile,1);

    % Plot auto-corr 
    nexttile(1);
    plot(auto.auto, '-o');
    title  ( [intitle ': Freq [kHz] = '  num2str(auto.freq_selected)] );
    xlabel ('data number');
    ylabel ('Auto-Corr');
    
    nexttile(2);
    semilogy(auto.f,auto.amp_i,'-o');

    [dmax,imax] = max(auto.amp_i);
    p_freq = auto.f(imax);
    title(['Peak at　' num2str(p_freq/1000,'%0.3f') 'MHz [' num2str(dmax') ']']);

    xlabel ('Frequency');
    ylabel ('Auto-Corr');
    legend('Amp I')

end
