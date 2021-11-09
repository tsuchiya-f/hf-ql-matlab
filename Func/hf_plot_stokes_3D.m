function ret = hf_plot_stokes_3D(st_ctl, spec)

    ret = 0;
    
    % set figure size
    fig=figure(st_ctl.hf);
    fig.Units = 'centimeters';
    fig.Position = [1.0 1.0 20.0 25.0];     %　[left bottom width height]

    % set display layout
    np = 5;
    tiledlayout(np,2)

    % Spectral matrix
    xx = spec.xx;
    yy = spec.yy;
    zz = spec.zz;
    re_xy = spec.re_xy;
    im_xy = spec.im_xy;
    re_yz = spec.re_yz;
    im_yz = spec.im_yz;
    re_zx = spec.re_zx;
    im_zx = spec.im_zx;

    % 2D stokes parameters
    [Ixy, Qxy, Uxy, Vxy] = hf_proc_get_stokes(xx, yy, re_xy, im_xy);
    [dop_xy, dol_xy, doc_xy, ang_xy] = hf_proc_get_pol(Ixy, Qxy, Uxy, Vxy);
    [Iyz, Qyz, Uyz, Vyz] = hf_proc_get_stokes(yy, zz, re_yz, im_yz);
    [dop_yz, dol_yz, doc_yz, ang_yz] = hf_proc_get_pol(Iyz, Qyz, Uyz, Vyz);
    [Izx, Qzx, Uzx, Vzx] = hf_proc_get_stokes(zz, xx, re_zx, im_zx);
    [dop_zx, dol_zx, doc_zx, ang_zx] = hf_proc_get_pol(Izx, Qzx, Uzx, Vzx);
    
    % 3D stokes parameters
    I_3d = xx + yy + zz;
    Q_3d = spec.UrUr - spec.UiUi + spec.VrVr - spec.ViVi + spec.WrWr - spec.WiWi;
    U_3d = 2.0 * (spec.UrUi + spec.VrVi + spec.WrWi);
    V_3d_x = -2.0 * (spec.VrWi - spec.ViWr); 
    V_3d_y = -2.0 * (spec.VrWi - spec.ViWr); 
    V_3d_z = -2.0 * (spec.VrWi - spec.ViWr); 
    [dop_3d, dol_3d, doc_3d, ang_3d, k_lon, k_lat] = hf_proc_get_pol_3D(I_3d, Q_3d, U_3d, V_3d_x, V_3d_y, V_3d_z);
    
    % print peak values
    [~, max_ind] = max(I_3d);
    fprintf('---- parameters at amplitude peak : %6.3f --------------------------\n', spec.f(max_ind)/1e3);
    fprintf(' 3D (I Q/I U/I Vx/I Vy/I Vz/I)     : %8.2e %5.2f %5.2f %5.2f %5.2f %5.2f\n', I_3d(max_ind), Q_3d(max_ind)/I_3d(max_ind), U_3d(max_ind)/I_3d(max_ind), V_3d_x(max_ind)/I_3d(max_ind), V_3d_y(max_ind)/I_3d(max_ind), V_3d_z(max_ind)/I_3d(max_ind));
    fprintf(' 3D DoP DoL DoC Pang k_clat k_lon  : %5.2f %5.2f %5.2f %7.2f %7.2f %7.2f\n', dop_3d(max_ind), dol_3d(max_ind), doc_3d(max_ind), ang_3d(max_ind), k_lon(max_ind), k_lat(max_ind));
    fprintf('--------------------------------------------------------------------\n');
    fprintf(' XY I DoP DoL DoC Pang             : %8.2e %5.2f %5.2f %5.2f %7.2f\n', Ixy(max_ind), dop_xy(max_ind), dol_xy(max_ind), doc_xy(max_ind), ang_xy(max_ind));
    fprintf(' YZ I DoP DoL DoC Pang             : %8.2e %5.2f %5.2f %5.2f %7.2f\n', Iyz(max_ind), dop_yz(max_ind), dol_yz(max_ind), doc_yz(max_ind), ang_yz(max_ind));
    fprintf(' ZX I DoP DoL DoC Pang             : %8.2e %5.2f %5.2f %5.2f %7.2f\n', Izx(max_ind), dop_zx(max_ind), dol_zx(max_ind), doc_zx(max_ind), ang_zx(max_ind));
    fprintf('--------------------------------------------------------------------\n');
%     fprintf(' XY I Q U V                        : %8.2e %8.2e %8.2e %8.2e\n', Ixy(max_ind), Q_xy(max_ind), U_xy(max_ind), V_xy(max_ind));
%     fprintf(' YZ I Q U V                        : %8.2e %8.2e %8.2e %8.2e\n', Iyz(max_ind), Q_yz(max_ind), U_yz(max_ind), V_yz(max_ind));
%     fprintf(' ZX I Q U V                        : %8.2e %8.2e %8.2e %8.2e\n', Izx(max_ind), Q_zx(max_ind), U_zx(max_ind), V_zx(max_ind));
%     fprintf('--------------------------------------------------------------------\n');

    
    %---------------------------------
    % [2D] Plot Power spectrum (x, y, and z) 
    %---------------------------------
    nexttile(1)
    if spec.xlog == 0
        semilogy(spec.f/1e3, xx,'r', spec.f/1e3, yy,'g', spec.f/1e3, zz,'b')
    else
        loglog(spec.f/1e3, xx,'r', spec.f/1e3, yy,'g', spec.f/1e3, zz,'b')
    end

    [p_freq_MHz, p_xx_dB, p_yy_dB, p_zz_dB] = hf_proc_get_peak_power(spec.f, xx, yy, zz);
    title(['Peak: ' num2str(p_freq_MHz,'%0.2f') ' MHz'],  ['X(Red):' num2str(p_xx_dB,'%0.1f') ' Y(Green):' num2str(p_yy_dB,'%0.1f') ' Z(Blue):' num2str(p_zz_dB,'%0.1f')]);
    xlabel ('Frequency [MHz]');
    ylabel ('Power [rel]');
    
    %---------------------------------
    % [2D] Plot degree of polarization (DoP) (xy, yz, and zx) 
    %---------------------------------
    nexttile(3)
    if spec.xlog == 0
        plot(spec.f/1e3, dop_xy,'r', spec.f/1e3, dop_yz,'g', spec.f/1e3, dop_zx,'b')
    else
        semilogx(spec.f/1e3, dop_xy,'r', spec.f/1e3, dop_yz,'g', spec.f/1e3, dop_zx,'b')
    end
    ylim([-0.1 1.1])
    title('Red:XY, Green:YZ, Blue:ZX');
    xlabel ('Frequency [MHz]');
    ylabel ('Degree of polarization');
    
    %---------------------------------
    % [2D] Plot polarization
    %---------------------------------
    for i=1:3
        switch i
            case 1
                label = 'XY';
                ang = ang_xy;
                dol = dol_xy;
                doc = doc_xy;
            case 2
                label = 'YZ';
                ang = ang_yz;
                dol = dol_yz;
                doc = doc_yz;
            case 3
                label = 'ZX';
                ang = ang_zx;
                dol = dol_zx;
                doc = doc_zx;
        end
        
        nexttile(5+2*(i-1))
        if spec.xlog == 0
            yyaxis left
            plot(spec.f/1e3, dol,'r.', spec.f/1e3, doc,'g.')
            ylabel ('Deg. L/C pol.');
            ylim([-1.1 1.1])
            yyaxis right
            plot(spec.f/1e3, ang,'b.')
            ylabel ('Angle of pol axis [deg]');
            ylim([-5.0 185.0])
        else
            yyaxis left
            semilogy(spec.f/1e3, dol,'r.', spec.f/1e3, doc,'g.')
            ylabel ('Deg. L/C pol.');
            ylim([-1.1 1.1])
            yyaxis right
            semilogy(spec.f/1e3, ang,'b.')
            ylabel ('Angle pol. axis [deg]');
            ylim([-5.0 185.0])
        end
        title([label ' Polarization'],'Red:DoL, Green:DoC, Blue:Ang');
        xlabel ('Frequency [MHz]');
    end

    %---------------------------------
    % [3D] Plot Power I 
    %---------------------------------
    nexttile(2)
    if spec.xlog == 0
        semilogy(spec.f/1e3, I_3d)
    else
        loglog(spec.f/1e3, I_3d)
    end
    title('3D Stokes I');
    xlabel ('Frequency [MHz]');
    ylabel ('Stokes I');
    
    %---------------------------------
    % [3D] Plot degrees of polarization 
    %---------------------------------
    nexttile(4)
    if spec.xlog == 0
        plot(spec.f/1e3, dop_3d)
    else
        semilogx(spec.f/1e3, dop_3d)
    end
    ylim([-0.1 1.1])
    title('3D degree of polarization');
    xlabel ('Frequency [MHz]');
    ylabel ('Degree of polarization');

    nexttile(6)
    if spec.xlog == 0
        yyaxis left
        plot(spec.f/1e3, dol_3d,'r.', spec.f/1e3, doc_3d,'g.')
        ylabel ('Deg. L/C pol.');
        ylim([-1.1 1.1])
        yyaxis right
        plot(spec.f/1e3, ang_3d,'b.')
        ylabel ('Angle of pol axis [deg]');
        ylim([-5.0 185.0])
    else
        yyaxis left
        semilogy(spec.f/1e3, dol_3d,'r.', spec.f/1e3, doc_3d,'g.')
        ylabel ('Deg. L/C pol.');
        ylim([-1.1 1.1])
        yyaxis right
        semilogy(spec.f/1e3, ang_3d,'b.')
        ylabel ('Angle pol. axis [deg]');
        ylim([-5.0 185.0])
    end
    title('3D Polarization','Red:DoL, Green:DoC, Blue:Ang');
    xlabel ('Frequency [MHz]');
    ylabel ('Degree of polarization');

    %---------------------------------
    % [3D] Plot DOA (k-vector) 
    %---------------------------------
    nexttile(8)
    if spec.xlog == 0
        yyaxis left
        plot(spec.f/1e3, k_lat,'r.')
        ylabel ('colatitude [deg]');
        ylim([-95.0 95.0])
        yyaxis right
        plot(spec.f/1e3, k_lon,'g.')
        ylabel ('longitude [deg]');
        ylim([-185.0 185.0])
    else
        yyaxis left
        semilogx(spec.f/1e3, k_lat,'r.')
        ylabel ('colatitude [deg]');
        ylim([-95.0 95.0])
        yyaxis right
        semilogx(spec.f/1e3, k_lon,'g.')
        ylabel ('longitude [deg]');
        ylim([-185.0 185.0])
    end
    title('3D DoA','Red:colat, Green:lon');
    xlabel ('Frequency [MHz]');

    fprintf('--------------------------------------------------------------------\n');
    fprintf(' Freq Pxx Pyy Pzz (I DoP DoL DoC Pang)_xy (I DoP DoL DoC Pang)_yz (I DoP DoL DoC Pang)_zx\n');
    fprintf('%0.3f %0.2f %0.1f %0.1f %8.2e %8.2e %8.2e %5.2f %5.2f %5.2f %5.2f %5.2f %5.2f %5.2f %5.2f %5.2f %7.2f %7.2f %7.2f\n', ...
        p_freq_MHz, p_xx_dB, p_yy_dB, p_zz_dB, ...
        Ixy(max_ind), Iyz(max_ind), Izx(max_ind), ...
        dop_xy(max_ind), dop_yz(max_ind), dop_zx(max_ind), ...
        dol_xy(max_ind), dol_yz(max_ind), dol_zx(max_ind), ...
        doc_xy(max_ind), doc_yz(max_ind), doc_zx(max_ind), ...
        ang_xy(max_ind), ang_yz(max_ind), ang_zx(max_ind));
    fprintf('--------------------------------------------------------------------\n');
    
    
    
end
