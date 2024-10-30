function plot_freq_table

    tab_org = readmatrix('freq_table_sid-3.txt');
    tab_rv1 = readmatrix('freq_table_sid3_v3.txt');
    tab_rv2 = readmatrix('freq_table_sid3_v3.1.txt');
    ky40 = readtable('SID3-SID2_ASW3_frequency_table_plan.xlsx','Sheet','SID-3 ASW3 (40MHz)','Range','B2:F257');
    ky45 = readtable('SID3-SID2_ASW3_frequency_table_plan.xlsx','Sheet','SID-3 ASW3 (45MHz)','Range','B2:F257');

    index = tab_org(:,1);

    f_org_mid = (tab_org(:,2)+tab_org(:,3))*0.5;
    df_f_org  = tab_org(:,4) ./ f_org_mid * 100; 

    f_rv1_mid = (tab_rv1(:,2)+tab_rv1(:,3))*0.5;
    df_f_rv1  = tab_rv1(:,4) ./ f_rv1_mid * 100; 

    f_rv2_mid = (tab_rv2(:,2)+tab_rv2(:,3))*0.5;
    df_f_rv2  = tab_rv2(:,4) ./ f_rv2_mid * 100; 

    df_f_ky40  = ky40.Var5 ./ ky40.Var2 * 100; 
    df_f_ky45  = ky45.Var5 ./ ky45.Var2 * 100;

    tiledlayout(2,1)

    ax1 = nexttile; 
    semilogy(ax1, index, f_org_mid, 'k', 'LineWidth',1.5);
    hold on;
    semilogy(ax1, index, f_rv1_mid, 'r', 'LineWidth',3.0);
    semilogy(ax1, index, f_rv2_mid, 'b', 'LineWidth',1.5);
    semilogy(ax1, ky40.Var1+1, ky40.Var2, 'r--', 'LineWidth',3.0);
    semilogy(ax1, ky45.Var1+1, ky45.Var2, 'b--', 'LineWidth',1.5);
    hold off;
    legend(ax1, {'Ver.2', 'Ver.3 80k-40MHz (modify)', 'Ver.3 80k-45MHz (modify)', 'Ver.3 80k-40MHz', 'Ver.3 80k-45MHz'}, 'Location','northwest')
    xlabel(ax1, 'Index') 
    ylabel(ax1, 'Freq. [MHz]') 
    xlim(ax1, [0,256])

    ax3 = nexttile; 
    semilogx(ax3, f_org_mid, df_f_org, 'k', 'LineWidth',1.5);
    hold on;
    semilogx(ax3, f_rv1_mid, df_f_rv1, 'r', 'LineWidth',3.0);
    semilogx(ax3, f_rv2_mid, df_f_rv2, 'b', 'LineWidth',1.5);
    semilogy(ax3, ky40.Var2, df_f_ky40, 'r--', 'LineWidth',3.0);
    semilogy(ax3, ky45.Var2, df_f_ky45, 'b--', 'LineWidth',1.5);
    hold off;
    xlabel(ax3, 'Freq. [MHz]') 
    ylabel(ax3, 'dF/F [%]') 
    xlim(ax3, [0,45000])


end
