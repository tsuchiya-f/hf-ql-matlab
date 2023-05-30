function ret = hf_plot_power_1ch(st_ctl, spec)

    ret = 0;
    
    % set figure size
    fig=figure(st_ctl.hf);
    fig.Units = 'centimeters';
    fig.Position = [1.0 1.0 20.0 25.0];     %　[left bottom width height]

    % set display layout
    tiledlayout(1,1)

    % Plot Power spectrum
    if spec.xlog == 0
        if spec.ylog == 0
           plot(spec.f/1e3, spec.x,'r')
        else
           semilogy(spec.f/1e3, spec.x,'r')
        end
    else
        if spec.ylog == 0
           semilogx(spec.f/1e3, spec.x,'r')
        else
           loglog(spec.f/1e3, spec.x,'r')
        end
    end
            
    [dmax,imax] = max(spec.x);
    p_freq = spec.f(imax) / 1e3;
    title(['Peak at　' num2str(p_freq,'%0.3f') ' MHz  Red(X)[' num2str(dmax,'%0.1f') '] dBm']);
    xlabel ('Frequency [MHz]');
    ylabel (st_ctl.power_unit);
    if isfield(st_ctl, 'xlim'); xlim(st_ctl.xlim); end
    if isfield(st_ctl, 'ylim'); ylim(st_ctl.ylim); end

end
