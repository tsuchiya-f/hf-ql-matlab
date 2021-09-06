function ret = hf_plot_autocorr(st_ctl, auto)

    ret = 0;
    
    fig=figure(st_ctl.hf);
    fig.Units = 'centimeters';
    fig.Position = [1.0 1.0 15.0 11.0];     %　[left bottom width height]

    n_fig=6;
    % set display layout
    tiledlayout(n_fig,1);
    

    % Plot stream (x, y, and z) 
	nexttile(1);
    stairs(auto.t, auto.auto(:,1), 'r');

    i_fig=0;
%    for i=1:auto.n_freq 
%         if mod(i_fig,n_fig) == 0
%             nexttile(i_fig/n_fig);
%             xlabel ('Time [sec]');
%             ylabel ('Auto-Corr');
%         end
%        stairs(auto.t, auto.auto(:,i));
%        i_fig = i_fig+ 1;
%    end
end
