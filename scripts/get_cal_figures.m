%
% get one spectrum from the system test daat
%
%---------------------------------------------------------
% test list & status
%
% a. May 2021 / SCPFM PTR RPWI	 	[See slide2]
% 	Post integration FFT in Friedrichshafen
% 	Covers installed, no ground wires -> High impedance expected.
% b. June-July 2021 / SC TBTV 	 	[See slide3]
% 	TBTV at ESTEC
% 	No covers, no grounding wires -> High impedance expected.
% c.  Nov. 2021 / SCPFM PTR RPWI delta	[See slide4]
% 	Toulouse, after LP-PWI FM and SCM FS integration
% 	No covers, no grounding wires. -> High impedance expected.
% d. Apr. 2022 / EMC-R (no slide)
% 	EMC-R in Toulouse, inside the Mistral EMC chamber
% 	No covers, no grounding wires.	No HF Cal data (only SCIENCE mode)
% e. July 2022 / The post EMC-R/vibe FFT	[See slide5]
% 	FFT in Toulouse, inside the Pascal D clean room
% 	No covers, grounding wires installed (confirmed) -> Low impedance expected.
% f.  Aug. 2022 / HF FFT rerun on 2022-08-24 	[See slide6]
%	Airbus
%	Covers installed, no grounding wires. -> High impedance expected.
%---------------------------------------------------------

function get_cal_figures()

%---------------------------------
% a. May 2021 / SCPFM PTR RPWI
%---------------------------------
% day 3
m.label= 'May2021-SCPFM-PTR-RPWI-Day3';
m.src_dir = "C:\share\Linux\RESULTS\20210531_SCPFM_PTR_RPWI_2_complete\2021_05_11T05_17_29_pomi159_ded31615_RT_RPWI_DAY_3\USER\CFDP\RETRIEVAL\";
%m.dst_dir = "C:\share\Linux\RESULTS\report_20210531_SCPFM_PTR_RPWI_2_complete\DAY_3\";
m.dst_dir = "C:\share\Linux\RESULTS\CAL_system-test\";
m.data_file = "xid32776";
m.data_no = 13;
write_csv_fig_data(m)

% day 5
m.label= 'May2021-SCPFM-PTR-RPWI-Day5';
m.src_dir = "C:\share\Linux\RESULTS\20210531_SCPFM_PTR_RPWI_2_complete\2021_05_17T04_32_56_pomi159_ded31615_RT_RPWI_FFT_DAY5\USER\CFDP\RETRIEVAL\";
%m.dst_dir = "C:\share\Linux\RESULTS\report_20210531_SCPFM_PTR_RPWI_2_complete\DAY_5\";
m.dst_dir = "C:\share\Linux\RESULTS\CAL_system-test\";
m.data_file = "xid32775";
m.data_no = 17;
write_csv_fig_data(m)

%---------------------------------
% b. June-July 2021 / SC TBTV
%---------------------------------
% cold FFT
m.label= 'June-July2021-SC-TBTV_Phase11-ColdFFT';
m.src_dir = "C:\Users\tsuch\Dropbox\JUICE_Data\SCTBTV-July-2021-Complete-bulkExport\SCTBTV_Phase11\CFDP_RPWI_S53_P11_2\";
m.dst_dir = "C:\share\Linux\RESULTS\CAL_system-test\";
%m.dst_dir = "C:\share\Linux\RESULTS\report_SCTBTV\Phase11\";
m.data_file = "xid32833";
m.data_no = 14;
write_csv_fig_data(m)

% hot FFT
m.label= 'June-July2021-SC-TBTV_Phase13-HotFFT';
m.src_dir = "C:\Users\tsuch\Dropbox\JUICE_Data\SCTBTV-July-2021-Complete-bulkExport\SCTBTV_Phase13\RPWI_CFDP_S66_P13\";
%m.dst_dir = "C:\share\Linux\RESULTS\report_SCTBTV\Phase13\";
m.dst_dir = "C:\share\Linux\RESULTS\CAL_system-test\";
m.data_file = "xid32846";
m.data_no = 14;
write_csv_fig_data(m)

%---------------------------------
% c.  Nov. 2021 / SCPFM PTR RPWI delta
%---------------------------------
m.label= 'Nov2021-SCPFM-PTR-RPWI-delta';
m.src_dir  = "C:\share\Linux\RESULTS\20211201-SCPFM_PTR_RPWI_delta\CFDP_RPWI_SCM_TEST\2021_11_25T21_11_18_pomi159_ded31614_RT_RPWI_FFT_SCM\USER\CFDP\RETRIEVAL\";
%m.dst_dir = "C:\share\Linux\RESULTS\report_SCPFM_PTR_RPWI_delta\RPWI_SCM_TEST\";
m.dst_dir = "C:\share\Linux\RESULTS\CAL_system-test\";
m.data_file = "xid32772";
m.data_no = 13;
write_csv_fig_data(m)

%---------------------------------
% e. July 2022 / The post EMC-R/vibe FFT
%---------------------------------
m.label= 'July2022-SCPFM-RPWI-30c';
m.src_dir = "C:\share\Linux\RESULTS\SCPFM_RPWI_30c\CFDP\RETRIEVAL\";
%m.dst_dir = "C:\share\Linux\RESULTS\report_SCPFM_RPWI_30c\";
m.dst_dir = "C:\share\Linux\RESULTS\CAL_system-test\";
m.data_file = "xid32778";
m.data_no = 18;
write_csv_fig_data(m)

%---------------------------------
% f.  Aug. 2022 / HF FFT rerun on 2022-08-24 
%---------------------------------
m.label= 'Aug2022-HF-FFT-rerun';
m.src_dir = "C:\share\Linux\RESULTS\20220824_HF-FFT-rerun\CFDP_RPWI\";
%m.dst_dir = "C:\share\Linux\RESULTS\report_20220824_HF-FFT-rerun\";
m.dst_dir = "C:\share\Linux\RESULTS\CAL_system-test\";
m.data_file = "xid32793";
m.data_no = 12;
write_csv_fig_data(m)

end

function write_csv_fig_data(m)

    file_path = append(m.src_dir, m.data_file, '.mat');
    load (file_path);
    fig=plot(freq,x_pow(:,m.data_no),"r",freq,y_pow(:,m.data_no),"g",freq,z_pow(:,m.data_no),"b");
    title(append(m.label, ' ', m.data_file, 'No.', string(m.data_no)))
    xlabel('Frquency [kHz]')
    ylabel('Power at ADC input [dBm]')
    legend('Ch-X','Ch-Y','Ch-Z')

    fig_name = append(m.dst_dir,m.label,'_',m.data_file,'.fig');
    savefig(fig_name)
    csv_name = append(m.dst_dir,m.label,'_',m.data_file,'.csv');
    mat = [transpose(freq) x_pow(:,m.data_no) y_pow(:,m.data_no) z_pow(:,m.data_no)];
    writematrix(mat,csv_name)

%    png_name = append(m.dst_dir,m.label,'_',m.data_file,'.png');
%    saveas(fig, png_name, 'png')

end

