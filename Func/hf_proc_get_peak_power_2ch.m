function    [p_freq_MHz, p_xx_dB, p_yy_dB] = hf_proc_get_peak_power_2ch(f, xx, yy)
    [xmax,ix] = max(xx);
    [ymax,iy] = max(yy);
    dmax      = [xmax,ymax];
    imax      = [ix,iy];
    [~,im]   = max(dmax);
    p_freq_MHz = f(imax(im)) / 1e3;
    p_xx_dB = 10.0 * log10(xx(imax(im)));
    p_yy_dB = 10.0 * log10(yy(imax(im)));
end