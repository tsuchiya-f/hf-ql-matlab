function ret = hf_plot_autocorr(st_rpw, st_ctl, auto)

    ret = 0;
    

    switch st_rpw.sid
        case {st_ctl.sid_pssr2_s}
            intitle='PSSR2 Survey'
            n_fig=3;
        
        case {st_ctl.sid_pssr2_r}
            intitle='PSSR2 Rich'
            n_fig=3;

        case {st_ctl.sid_pssr3_s}
            intitle='PSSR3 Survey'
            n_fig=1;
    end
    
    % set display layout
    fig=figure(st_ctl.hf);
    fig.Units = 'centimeters';
    fig.Position = [1.0 1.0 15.0 20.0];     %　[left bottom width height]
    tiledlayout(n_fig,1);
    

    % Plot stream (x, y, and z) 
    for i=1:auto.n_freq/n_fig-1
        nexttile(mod(i,n_fig)+1);
        switch st_rpw.sid
            case {st_ctl.sid_pssr2_s}
                inauto=[auto.auto(:,n_fig*i+1), auto.auto(:,n_fig*i+2), auto.auto(:,n_fig*i+3)];
            case {st_ctl.sid_pssr2_r}
                inauto=[auto.auto(:,n_fig*i+1), auto.auto(:,n_fig*i+2), auto.auto(:,n_fig*i+3)];
            case {st_ctl.sid_pssr3_s}
                inauto=[auto.auto(:,n_fig*i+1)];
        end
        stairs(auto.t, inauto);
        title  ( intitle );
        xlabel ('Time [sec]');
        ylabel ('Auto-Corr');
    end
end
