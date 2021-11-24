function    [p_freq_MHz, p_xx_dB, p_yy_dB, p_zz_dB] = hf_proc_get_peak_power(f, xx, yy, zz)
    [xmax,ix] = max(xx);
    [ymax,iy] = max(yy);
    [zmax,iz] = max(zz);
    dmax      = [xmax,ymax,zmax];
    imax      = [ix,iy,iz];
    [~,im]   = max(dmax);
    p_freq_MHz = f(imax(im)) / 1e3;
    p_xx_dB = 10.0 * log10(xx(imax(im)));
    p_yy_dB = 10.0 * log10(yy(imax(im)));
    p_zz_dB = 10.0 * log10(zz(imax(im)));
end