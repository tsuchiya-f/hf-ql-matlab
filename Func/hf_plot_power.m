function ret = hf_plot_power(spec)

    ret = 0;
    
    f = spec.f;
    x = spec.x;
    y = spec.y;
    z = spec.z;

    if spec.log == 0
       plot(f/1e6, x,'r', f/1e6, y,'g', f/1e6, z,'b')
    else
       semilogy(f/1e6, x,'r', f/1e6, y,'g', f/1e6, z,'b')
    end
            
    [xmax,ix] = max(x);
    [ymax,iy] = max(y);
    [zmax,iz] = max(z);
    dmax      = [xmax,ymax,zmax];
    imax      = [ix,iy,iz];
    [~,im]   = max(dmax);
    p_freq = f(imax(im)) / 1e6;
    title(['Peak at　' num2str(p_freq,'%0.2f') ' MHz  Red(X)[' num2str(x(imax(im)),'%0.1f') '] Green(Y)[' num2str(y(imax(im)),'%0.1f') '] Blue(Z)[' num2str(z(imax(im)),'%0.1f') '] dBm']);
    
end
