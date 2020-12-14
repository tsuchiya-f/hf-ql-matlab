function ret = hf_plot_power(st_ctl, spec)

    ret = 0;
    
    % set figure size
    fig=figure(st_ctl.hf);
    fig.Units = 'centimeters';
    fig.Position = [1.0 1.0 20.0 25.0];     %　[left bottom width height]

    % set display layout
    if spec.matrix == 1
        tiledlayout(4,1)
    else
        tiledlayout(1,1)
    end

    % Plot Power spectrum (x, y, and z) 
    nexttile(1)
    if spec.log == 0
       plot(spec.f/1e3, spec.x,'r', spec.f/1e3, spec.y,'g', spec.f/1e3, spec.z,'b')
    else
       semilogy(spec.f/1e3, spec.x,'r', spec.f/1e3, spec.y,'g', spec.f/1e3, spec.z,'b')
    end
            
    [xmax,ix] = max(spec.x);
    [ymax,iy] = max(spec.y);
    [zmax,iz] = max(spec.z);
    dmax      = [xmax,ymax,zmax];
    imax      = [ix,iy,iz];
    [~,im]   = max(dmax);
    p_freq = spec.f(imax(im)) / 1e3;
    title(['Peak at　' num2str(p_freq,'%0.2f') ' MHz  Red(X)[' num2str(spec.x(imax(im)),'%0.1f') '] Green(Y)[' num2str(spec.y(imax(im)),'%0.1f') '] Blue(Z)[' num2str(spec.z(imax(im)),'%0.1f') '] dBm']);
    xlabel ('Frequency [MHz]');
    ylabel ('Power [dBm]');

    if spec.matrix == 0; return; end

    % Plot cross spectrum (xy) 
    nexttile(2)
    if spec.log == 0
       plot(spec.f/1e3, spec.re_xy,'ro', spec.f/1e3, spec.im_xy,'bo')
    else
       semilogy(spec.f/1e3, spec.re_xy,'ro', spec.f/1e3, spec.im_xy,'bo')
    end
    xlabel ('Frequency [MHz]');
    ylabel ('XY');

    % Plot cross spectrum (yz) 
    nexttile(3)
    if spec.log == 0
       plot(spec.f/1e3, spec.re_yz,'ro', spec.f/1e3, spec.im_yz,'bo')
    else
       semilogy(spec.f/1e3, spec.re_yz,'ro', spec.f/1e3, spec.im_yz,'bo')
    end
    xlabel ('Frequency [MHz]');
    ylabel ('YX');

    % Plot cross spectrum (zx) 
    nexttile(4)
    if spec.log == 0
       plot(spec.f/1e3, spec.re_zx,'ro', spec.f/1e3, spec.im_zx,'bo')
    else
       semilogy(spec.f/1e3, spec.re_zx,'ro', spec.f/1e3, spec.im_zx,'bo')
    end
    xlabel ('Frequency [MHz]');
    ylabel ('ZX');

end
