function ret = hf_plot_power(st_ctl, spec)

    ret = 0;
    
    % set figure size
    fig=figure(st_ctl.hf);
    fig.Units = 'centimeters';
    fig.Position = [1.0 1.0 20.0 25.0];     %　[left bottom width height]

    % set display layout
    tiledlayout(4,1)

    % Plot Power spectrum (x, y, and z) 
    nexttile(1)
%    switch st_ctl.n_ch
%        case 3
            if spec.xlog == 0
                plot(spec.f/1e3, spec.x,'r', spec.f/1e3, spec.y,'g', spec.f/1e3, spec.z,'b')
            else
                semilogx(spec.f/1e3, spec.x,'r', spec.f/1e3, spec.y,'g', spec.f/1e3, spec.z,'b')
            end

            [xmax,ix] = max(spec.x);
            [ymax,iy] = max(spec.y);
            [zmax,iz] = max(spec.z);
            dmax      = [xmax,ymax,zmax];
            imax      = [ix,iy,iz];
            [~,im]   = max(dmax);
            p_freq = spec.f(imax(im)) / 1e3;
            title(['Peak at　' num2str(p_freq,'%0.2f') ' MHz  Red(X)[' num2str(spec.x(imax(im)),'%0.1f') '] Green(Y)[' num2str(spec.y(imax(im)),'%0.1f') '] Blue(Z)[' num2str(spec.z(imax(im)),'%0.1f') '] dBm']);
%         case 2    
%             if spec.xlog == 0
%                 plot(spec.f/1e3, spec.x,'r', spec.f/1e3, spec.y,'g')
%             else
%                 semilogx(spec.f/1e3, spec.x,'r', spec.f/1e3, spec.y,'g')
%             end
% 
%             [xmax,ix] = max(spec.x);
%             [ymax,iy] = max(spec.y);
%             dmax      = [xmax,ymax];
%             imax      = [ix,iy];
%             [~,im]   = max(dmax);
%             p_freq = spec.f(imax(im)) / 1e3;
%             title(['Peak at　' num2str(p_freq,'%0.2f') ' MHz  Red(Ch1)[' num2str(spec.x(imax(im)),'%0.1f') '] Green(Ch2)[' num2str(spec.y(imax(im)),'%0.1f') ']']);
%     end
    xlabel ('Frequency [MHz]');
    ylabel (st_ctl.power_unit);
    if isfield(st_ctl, 'xlim'); xlim(st_ctl.xlim); end
    if isfield(st_ctl, 'ylim'); ylim(st_ctl.ylim); end

    % Plot power of each channel
    for i=1:st_ctl.n_ch

        switch i
            case 1
                if st_ctl.n_ch == 3; label='X'; else; label='Ch1'; end  
                data = spec.xx;
            case 2
                if st_ctl.n_ch == 3; label='Y'; else; label='Ch2'; end  
                data = spec.yy;
            case 3
                label='Z';
                data = spec.zz;
        end
        
        nexttile(i+1)

        if spec.xlog == 0
            if spec.ylog == 0
                plot(spec.f/1e3, data)
            else
                semilogy(spec.f/1e3, data)
            end
        else
            if spec.ylog == 0
                semilogx(spec.f/1e3, data)
            else
                loglog(spec.f/1e3, data)
            end
        end
        
        xlabel ('Frequency [MHz]');
        ylabel (label);
        if isfield(st_ctl, 'xlim'); xlim(st_ctl.xlim); end
        if isfield(st_ctl, 'ylim'); ylim(st_ctl.ylim); end
    end

end
