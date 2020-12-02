function ret = hf_plot_power(st_ctl, spec)

    ret = 0;
    
    f = spec.f;
    x = spec.x;
    y = spec.y;
    z = spec.z;

    figure(st_ctl.hf)
    if spec.log == 0
       plot(f/1e3, x,'r', f/1e3, y,'g', f/1e3, z,'b')
    else
       semilogy(f/1e3, x,'r', f/1e3, y,'g', f/1e3, z,'b')
    end
            
    [xmax,ix] = max(x);
    [ymax,iy] = max(y);
    [zmax,iz] = max(z);
    dmax      = [xmax,ymax,zmax];
    imax      = [ix,iy,iz];
    [~,im]   = max(dmax);
    p_freq = f(imax(im)) / 1e3;
    title(['Peak at　' num2str(p_freq,'%0.2f') ' MHz  Red(X)[' num2str(x(imax(im)),'%0.1f') '] Green(Y)[' num2str(y(imax(im)),'%0.1f') '] Blue(Z)[' num2str(z(imax(im)),'%0.1f') '] dBm']);
    xlabel ('Frequency [MHz]');
    ylabel ('Power [dBm]');

end
