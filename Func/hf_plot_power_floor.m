function ret = hf_plot_power_floor(st_ctl, spec)

    ret = 0;
    
    % check data dimension
    [~,m] = size(spec.xx);
    
    % set figure size
    fig=figure(st_ctl.hf);
    fig.Units = 'centimeters';
    fig.Position = [1.0 1.0 20.0 25.0];     %　[left bottom width height]

    % set display layout
    if m==1
        np = 3;
        pol_label = ["Power spectrum", "Power spectrum", "Power spectrum"];
    else
        % polarization separation
        np = 4;
        pol_label = ["Linear", "RH(+)", "LH(-)"];  
        n_sum = spec.n_sum(:,1) + spec.n_sum(:,2) + spec.n_sum(:,3);
    end
    tiledlayout(np,3)

    for j=1:m

    %==========================================================================================
    xx = spec.xx(:,j);
    yy = spec.yy(:,j);
    zz = spec.zz(:,j);
    
    %---------------------------------
    % Plot Power spectrum (x) 
    %---------------------------------    
    nexttile(j)
    if spec.xlog == 0
        if isfield(spec,'noise_floor_x') 
            semilogy(spec.f/1e3, xx,'r', spec.f/1e3, spec.noise_floor_x,'k')
        else
            semilogy(spec.f/1e3, xx,'r')
        end
    else
        if isfield(spec,'noise_floor_x') 
            loglog(spec.f/1e3, xx,'r', spec.f/1e3, spec.noise_floor_x,'k')
        else
            loglog(spec.f/1e3, xx,'r')
        end
    end
    title({pol_label(j);'X: Red, noise floor: BK'});
    xlabel ('Frequency [MHz]');
    ylabel ('Power [rel]');
    if isfield(st_ctl, 'xlim'); xlim(st_ctl.xlim); end
    if isfield(st_ctl, 'ylim'); ylim(st_ctl.ylim); end

    %---------------------------------
    % Plot Power spectrum (y) 
    %---------------------------------    
    nexttile (j+3)
    if spec.xlog == 0
        if isfield(spec,'noise_floor_y') 
            semilogy(spec.f/1e3, yy,'g', spec.f/1e3, spec.noise_floor_y,'k')
        else
            semilogy(spec.f/1e3, yy,'g')
        end
    else
        if isfield(spec,'noise_floor_y') 
            loglog(spec.f/1e3, yy,'g', spec.f/1e3, spec.noise_floor_y,'k')
        else
            loglog(spec.f/1e3, yy,'g')
        end
    end
    title('Y: Green, noise floor: BK');
    xlabel ('Frequency [MHz]');
    ylabel ('Power [rel]');
    if isfield(st_ctl, 'xlim'); xlim(st_ctl.xlim); end
    if isfield(st_ctl, 'ylim'); ylim(st_ctl.ylim); end

    %---------------------------------
    % Plot Power spectrum (z) 
    %---------------------------------    
    nexttile (j+6)
    if spec.xlog == 0
        if isfield(spec,'noise_floor_z') 
            semilogy(spec.f/1e3, zz,'b', spec.f/1e3, spec.noise_floor_z,'k')
        else
            semilogy(spec.f/1e3, zz,'b')
        end
    else
        if isfield(spec,'noise_floor_z') 
            loglog(spec.f/1e3, zz,'b', spec.f/1e3, spec.noise_floor_z,'k')
        else
            loglog(spec.f/1e3, zz,'g')
        end
    end
    title('Z: Blue, noise floor: BK');
    xlabel ('Frequency [MHz]');
    ylabel ('Power [rel]');
    if isfield(st_ctl, 'xlim'); xlim(st_ctl.xlim); end
    if isfield(st_ctl, 'ylim'); ylim(st_ctl.ylim); end

    %---------------------------------
    % Plot number of sum
    %---------------------------------
    if m == 3
        nexttile(j+9)
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
