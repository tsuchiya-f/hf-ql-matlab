function ret = hf_plot_power_2ch(st_ctl, spec)

    ret = 0;
    
    % set figure size
    fig=figure(st_ctl.hf);
    fig.Units = 'centimeters';
    fig.Position = [1.0 1.0 20.0 25.0];     %　[left bottom width height]

    % set display layout
    if spec.matrix == 1
        tiledlayout(2,1)
    else
        tiledlayout(1,1)
    end

    % Plot Power spectrum (x and y) 
    nexttile(1)
    if spec.xlog == 0
        if spec.ylog == 0
           plot(spec.f/1e3, spec.x,'r', spec.f/1e3, spec.y,'g')
        else
           semilogy(spec.f/1e3, spec.x,'r', spec.f/1e3, spec.y,'g')
        end
    else
        if spec.ylog == 0
           semilogx(spec.f/1e3, spec.x,'r', spec.f/1e3, spec.y,'g')
        else
           loglog(spec.f/1e3, spec.x,'r', spec.f/1e3, spec.y,'g')
        end
    end
            
    [xmax,ix] = max(spec.x);
    [ymax,iy] = max(spec.y);
    dmax      = [xmax,ymax];
    imax      = [ix,iy];
    [~,im]   = max(dmax);
    p_freq = spec.f(imax(im)) / 1e3;
    title(['Peak at　' num2str(p_freq,'%0.3f') ' MHz  Red(X)[' num2str(spec.x(imax(im)),'%0.1f') '] Green(Y)[' num2str(spec.y(imax(im)),'%0.1f') '] dBm']);
    xlabel ('Frequency [MHz]');
    ylabel (st_ctl.power_unit);
    if isfield(st_ctl, 'xlim'); xlim(st_ctl.xlim); end
    if isfield(st_ctl, 'ylim'); ylim(st_ctl.ylim); end

    if spec.matrix == 0; return; end

    % Plot cross spectrum (xy) 
    nexttile(2)
    if spec.xlog == 0
        if spec.ylog == 0
            plot(spec.f/1e3, spec.re_xy,'ro', spec.f/1e3, spec.im_xy,'bo')
        else
            semilogy(spec.f/1e3, spec.re_xy,'ro', spec.f/1e3, spec.im_xy,'bo')
        end
    else
        if spec.ylog == 0
            semilogx(spec.f/1e3, spec.re_xy,'ro', spec.f/1e3, spec.im_xy,'bo')
        else
            loglog(spec.f/1e3, spec.re_xy,'ro', spec.f/1e3, spec.im_xy,'bo')
        end
    end
    xlabel ('Frequency [MHz]');
    ylabel ('XY');
    if isfield(st_ctl, 'xlim'); xlim(st_ctl.xlim); end
    if isfield(st_ctl, 'ylim'); ylim(st_ctl.ylim); end

end
