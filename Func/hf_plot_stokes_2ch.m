function ret = hf_plot_stokes_2ch(st_ctl, spec)

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
        pol_label = "Polarization";
    else
        np = 6;
        pol_label = ["Linear", "RH(+)", "LH(-)"];        
        n_sum = spec.n_sum(:,1) + spec.n_sum(:,2) + spec.n_sum(:,3);
    end
    tiledlayout(np,m)

    for j=1:m

        %==========================================================================================
        xx = spec.xx(:,j);
        yy = spec.yy(:,j);
        re_xy = spec.re_xy(:,j);
        im_xy = spec.im_xy(:,j);

        %---------------------------------
        % Plot Power spectrum (Ch1 and Ch2) 
        %---------------------------------
        nexttile(j)
        if spec.xlog == 0
            if isfield(spec,'noise_floor') 
                semilogy(spec.f/1e3, xx,'r', spec.f/1e3, yy,'g', spec.f/1e3, spec.noise_floor,'k')
            else
                semilogy(spec.f/1e3, xx,'r', spec.f/1e3, yy,'g')
            end
        else
            if isfield(spec,'noise_floor') 
                loglog(spec.f/1e3, xx,'r', spec.f/1e3, yy,'g', spec.f/1e3, spec.noise_floor,'k')
            else
                loglog(spec.f/1e3, xx,'r', spec.f/1e3, yy,'g')
            end
        end

        [p_freq_MHz, p_xx_dB, p_yy_dB] = hf_proc_get_peak_power_2ch(spec.f, xx, yy);
        title(['Peak: ' num2str(p_freq_MHz,'%0.2f') ' MHz'],  ['Ch1(Red):' num2str(p_xx_dB,'%0.1f') ' Ch2(Green):' num2str(p_yy_dB,'%0.1f')]);
        xlabel ('Frequency [MHz]');
        ylabel (st_ctl.power_unit);

        % 2D stokes parameters
        [Ixy, Qxy, Uxy, Vxy] = hf_proc_get_stokes(xx, yy, re_xy, im_xy);
        [dop_xy, dol_xy, doc_xy, ang_xy] = hf_proc_get_pol(Ixy, Qxy, Uxy, Vxy);

        %---------------------------------
        % Plot degree of polarization (DoP) 
        %---------------------------------
        nexttile(j+m)
        if spec.xlog == 0
            plot(spec.f/1e3, dop_xy)
        else
            semilogx(spec.f/1e3, dop_xy)
        end
        ylim([-0.1 1.1])
        title(pol_label(j));
        xlabel ('Frequency [MHz]');
        ylabel ('Degree of polarization');
    
        %---------------------------------
        % Plot degree of linear polarization
        %---------------------------------
        nexttile(j+m*2)
        if spec.xlog == 0
            plot(spec.f/1e3, dol_xy,'.')
        else
            semilogy(spec.f/1e3, dol_xy,'.')
        end
        ylim([-0.1 1.1])
        xlabel ('Frequency [MHz]');
        ylabel ('Deg. linear pol.');

        %---------------------------------
        % Plot degree of circular polarization
        %---------------------------------
        nexttile(j+m*3)
        if spec.xlog == 0
            plot(spec.f/1e3, doc_xy,'.')
        else
            semilogy(spec.f/1e3, doc_xy,'.')
        end
        ylim([-1.1 1.1])
        xlabel ('Frequency [MHz]');
        ylabel ('Deg. circular pol.');

        %---------------------------------
        % Plot polarization angle
        %---------------------------------
        nexttile(j+m*4)
        if spec.xlog == 0
            plot(spec.f/1e3, ang_xy,'b.')
        else
            semilogy(spec.f/1e3, ang_xy,'b.')
        end
        ylim([-5.0 185.0])
        xlabel ('Frequency [MHz]');
        ylabel ('Angle of pol axis [deg]');
       
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
    %        ylim([-0.1 1.1])
            xlabel ('Frequency [MHz]');
            ylabel ('Number of Sum');
        end
        %==========================================================================================
    end


end
