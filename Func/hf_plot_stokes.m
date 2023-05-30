function ret = hf_plot_stokes(st_ctl, spec)

    ret = 0;
    
    % check data dimension
    [~,m] = size(spec.xx);
    
    % set figure size
    fig=figure(st_ctl.hf);
    fig.Units = 'centimeters';
    fig.Position = [1.0 1.0 20.0 25.0];     %　[left bottom width height]

    % set display layout
    if m==1
        np = 5;
        pol_label = ['Polarization'];
    else
        % polarization separation
        np = 6;
        pol_label = ["Linear", "RH(+)", "LH(-)"];  
        n_sum = spec.n_sum(:,1) + spec.n_sum(:,2) + spec.n_sum(:,3);
    end
    tiledlayout(np,m)

    for j=1:m

    %==========================================================================================
    xx = spec.xx(:,j);
    yy = spec.yy(:,j);
    zz = spec.zz(:,j);
    re_xy = spec.re_xy(:,j);
    im_xy = spec.im_xy(:,j);
    re_yz = spec.re_yz(:,j);
    im_yz = spec.im_yz(:,j);
    re_zx = spec.re_zx(:,j);
    im_zx = spec.im_zx(:,j);
    
    %---------------------------------
    % Plot Power spectrum (x, y, and z) 
    %---------------------------------

    % check data (negative values)
    idx_x = find(xx <= 0.0);
    idx_y = find(yy <= 0.0);
    idx_z = find(zz <= 0.0);
    if numel(idx_x) ~= 0 || numel(idx_y) ~= 0 || numel(idx_z) ~= 0 
        fprintf("***** CAUTION : negative value exist \n");
%        pause
    end
    
    nexttile(j)
    if spec.xlog == 0
        semilogy(spec.f/1e3, xx,'r', spec.f/1e3, yy,'g', spec.f/1e3, zz,'b')
    else
        loglog(spec.f/1e3, xx,'r', spec.f/1e3, yy,'g', spec.f/1e3, zz,'b')
    end

    [p_freq_MHz, p_xx_dB, p_yy_dB, p_zz_dB] = hf_proc_get_peak_power(spec.f, xx, yy, zz);
    title(['Peak: ' num2str(p_freq_MHz,'%0.2f') ' MHz'],  ['X(Red):' num2str(p_xx_dB,'%0.1f') ' Y(Green):' num2str(p_yy_dB,'%0.1f') ' Z(Blue):' num2str(p_zz_dB,'%0.1f')]);
    xlabel ('Frequency [MHz]');
    ylabel (st_ctl.power_unit);
    if isfield(st_ctl, 'xlim'); xlim(st_ctl.xlim); end
    if isfield(st_ctl, 'ylim'); ylim(st_ctl.ylim); end
        
    % 2D stokes parameters
    [Ixy, Qxy, Uxy, Vxy] = hf_proc_get_stokes(xx, yy, re_xy, im_xy);
    [dop_xy, dol_xy, doc_xy, ang_xy] = hf_proc_get_pol(Ixy, Qxy, Uxy, Vxy);
    [Iyz, Qyz, Uyz, Vyz] = hf_proc_get_stokes(yy, zz, re_yz, im_yz);
    [dop_yz, dol_yz, doc_yz, ang_yz] = hf_proc_get_pol(Iyz, Qyz, Uyz, Vyz);
    [Izx, Qzx, Uzx, Vzx] = hf_proc_get_stokes(zz, xx, re_zx, im_zx);
    [dop_zx, dol_zx, doc_zx, ang_zx] = hf_proc_get_pol(Izx, Qzx, Uzx, Vzx);

    % print peak values
    I_sum = Ixy + Iyz + Izx;
    [~, max_ind] = max(I_sum);
    fprintf('---- parameters at amplitude peak : %6.3f --------------------------\n', spec.f(max_ind)/1e3);
    fprintf(' XY I DoP DoL DoC Pang               : %8.2e %5.2f %5.2f %5.2f %7.2f\n', Ixy(max_ind), dop_xy(max_ind), dol_xy(max_ind), doc_xy(max_ind), ang_xy(max_ind));
    fprintf(' YZ I DoP DoL DoC Pang               : %8.2e %5.2f %5.2f %5.2f %7.2f\n', Iyz(max_ind), dop_yz(max_ind), dol_yz(max_ind), doc_yz(max_ind), ang_yz(max_ind));
    fprintf(' ZX I DoP DoL DoC Pang               : %8.2e %5.2f %5.2f %5.2f %7.2f\n', Izx(max_ind), dop_zx(max_ind), dol_zx(max_ind), doc_zx(max_ind), ang_zx(max_ind));
    fprintf('--------------------------------------------------------------------\n');
    
    fprintf('--------------------------------------------------------------------\n');
    fprintf(' Freq Pxx Pyy Pzz (I DoP DoL DoC Pang)_xy (I DoP DoL DoC Pang)_yz (I DoP DoL DoC Pang)_zx\n');
    fprintf('%0.3f %0.2f %0.1f %0.1f %8.2e %8.2e %8.2e %5.2f %5.2f %5.2f %5.2f %5.2f %5.2f %5.2f %5.2f %5.2f %7.2f %7.2f %7.2f\n', ...
        p_freq_MHz, p_xx_dB, p_yy_dB, p_zz_dB, ...
        Ixy(max_ind), Iyz(max_ind), Izx(max_ind), ...
        dop_xy(max_ind), dop_yz(max_ind), dop_zx(max_ind), ...
        dol_xy(max_ind), dol_yz(max_ind), dol_zx(max_ind), ...
        doc_xy(max_ind), doc_yz(max_ind), doc_zx(max_ind), ...
        ang_xy(max_ind), ang_yz(max_ind), ang_zx(max_ind));
%     fprintf('--------------------------------------------------------------------\n');
%     fprintf(' Freq Pxx Pyy Pzz   Ixy Iyz Izx   Qxy Qyz Qzx   Uxy Uyz Uzx   Vxy Vyz Vzx\n');
%     fprintf('%0.3f %0.2f %0.2f %0.2f   %8.2e %8.2e %8.2e   %5.2f %5.2f %5.2f   %5.2f %5.2f %5.2f   %5.2f %5.2f %5.2f\n', ...
%         p_freq_MHz, p_xx_dB, p_yy_dB, p_zz_dB, ...
%         Ixy(max_ind), Iyz(max_ind), Izx(max_ind), ...
%         Qxy(max_ind)/Ixy(max_ind), Qyz(max_ind)/Iyz(max_ind), Qzx(max_ind)/Izx(max_ind), ...
%         Uxy(max_ind)/Ixy(max_ind), Uyz(max_ind)/Iyz(max_ind), Uzx(max_ind)/Izx(max_ind), ...
%         Vxy(max_ind)/Ixy(max_ind), Vyz(max_ind)/Iyz(max_ind), Vzx(max_ind)/Izx(max_ind));
    fprintf('--------------------------------------------------------------------\n');
    
    %---------------------------------
    % Plot degree of polarization (DoP) (xy, yz, and zx) 
    %---------------------------------
    nexttile(j+m)
    if spec.xlog == 0
        plot(spec.f/1e3, dop_xy,'r', spec.f/1e3, dop_yz,'g', spec.f/1e3, dop_zx,'b')
    else
        semilogx(spec.f/1e3, dop_xy,'r', spec.f/1e3, dop_yz,'g', spec.f/1e3, dop_zx,'b')
    end
    ylim([-0.1 1.1])
    title(pol_label(j), 'Red:XY, Green:YZ, Blue:ZX');
    xlabel ('Frequency [MHz]');
    ylabel ('Degree of polarization');
    if isfield(st_ctl, 'xlim'); xlim(st_ctl.xlim); end
    
    %---------------------------------
    % Plot polarization
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
        nexttile(j+m*(i+1))
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
        if isfield(st_ctl, 'xlim'); xlim(st_ctl.xlim); end
%        legend('DoL','DoC','Angle')

    end

    %---------------------------------
    % Plot number of sum
    %---------------------------------
    if m == 3
        nexttile(j+m*5)
        if spec.xlog == 0
            plot(spec.f/1e3, n_sum, 'r-', spec.f/1e3, spec.n_sum(:,j), 'b-')
        else
            semilogx(spec.f/1e3, n_sum, 'r-', spec.f/1e3, spec.n_sum(:,j), 'b-')
        end
        xlabel ('Frequency [MHz]');
        ylabel ('Number of Sum');
        if isfield(st_ctl, 'xlim'); xlim(st_ctl.xlim); end
    end
    
    %==========================================================================================
    end


end
