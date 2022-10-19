function ret = hf_plot_autocorr(st_rpw, st_ctl, auto)

    ret = 0;

    switch st_rpw.sid
        case {st_ctl.sid_pssr2_s}
            intitle='PSSR2 Survey';
            n_fig=3;
            n_tile=n_fig+1;
        
        case {st_ctl.sid_pssr2_r}
            intitle='PSSR2 Rich';
            n_fig=3;
            n_tile=n_fig;

        case {st_ctl.sid_pssr3_s}
            intitle='PSSR3 Survey';
            n_fig=5;
            n_tile=n_fig;
    end
    n_plot=auto.n_freq/n_fig;
    
    % set display layout
    fig=figure(st_ctl.hf);
    fig.Units = 'centimeters';
    fig.Position = [1.0 1.0 15.0 20.0];     %　[left bottom width height]
    tiledlayout(n_tile,1);

    % Plot stream (x, y, and z) 
    for i=0:n_fig-1
        nexttile(mod(i,n_fig)+1);
        switch st_rpw.sid
            case {st_ctl.sid_pssr2_s}
                inauto=[auto.auto(:,n_plot*i+1), auto.auto(:,n_plot*i+2), auto.auto(:,n_plot*i+3)];
            case {st_ctl.sid_pssr2_r}
                inauto=[auto.auto(:,n_plot*i+1), auto.auto(:,n_plot*i+2), auto.auto(:,n_plot*i+3)];
            case {st_ctl.sid_pssr3_s}
                inauto=[auto.auto(:,n_plot*i+1), auto.auto(:,n_plot*i+2)];
        end
        stairs(auto.t, inauto, '-o');
        title  ( [intitle ': block from ' num2str(n_plot*i+1) ' to ' num2str(n_plot*i+n_plot)] );
        xlabel ('Time [sec]');
        ylabel ('Auto-Corr');
    end
    
    switch st_rpw.sid
        case {st_ctl.sid_pssr2_s}
         nexttile(n_fig+1);
         nf = numel(auto.freq);
        semilogy(auto.freq,auto.auto(1,1:nf),'-o');
        title  ( 'Amplitude @ lag=0' );
        xlabel ('Frequency');
        ylabel ('Auto-Corr');
    end
end
