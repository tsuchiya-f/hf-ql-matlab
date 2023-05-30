%------------------------------------------------------------------------------------
% User inputs
%------------------------------------------------------------------------------------
st_ctl_in.raw_ver1_corrected = 1;
st_ctl_in.title = 'Mission_Test_GCO500';
st_ctl_in.xlim = [0 45];
st_ctl_in.ylim = [-90 -10];
st_ctl_in.cf = -104.1;
st_ctl.power_unit = 'dBm@ADCin';

basedir_in = "C:\share\Linux\RESULTS\20221115_Mission_Test_GCO500_Sciops\bulkExport_2022_11_15T05_55_36_leal197_ded31615_RT_SCOP_020_run3\SCOP_020_CFDP_files\";
basedir_out = "C:\share\Linux\RESULTS\report_20221115_Mission_Test_GCO500\";

% indir  = ["CFDP_04_RT_EMC_AC_SC2RIME\CFDP\RETRIEVAL\" "RPWI_NCR\"];
% outdir = ["Phase4\"  "RPWI_NCR\"];
 indir  = ["1RPR\", "2RPR\"];
 outdir = ["1RPR\", "2RPR\"];
file_search_str = "*.data";
%------------------------------------------------------------------------------------

ql=0;
st_ctl_in.timeout=5;

n_dir = numel(indir);
for j=1: n_dir

    tdir = append(basedir_out, outdir(j)); 
    mkdir(tdir)

    s = dir(append(basedir_in, indir(j), file_search_str));
    n_file = numel(s);

    for i=1: n_file

        file = s(i).name;

        infile = append(basedir_in, indir(j), file);
        outfile = append(basedir_out, outdir(j), file, '.hf.ccsds');
        [ret, st_ctl] = hf_get_packet(infile, outfile);

        if ret == 1 
            fprintf("HF data in %s\n", file);
%            fprintf("   SW ver : %d\n", st_ctl.ver);
            fprintf("   number of HF packet      : %d\n",st_ctl.n_pkt);
            fprintf("   number of HF data [Byte] : %d\n",st_ctl.out_sz);

            st_ctl_in.dir_in = append(basedir_in, indir(j));
            st_ctl_in.dir_out = append(basedir_out, outdir(j));
            st_ctl_in.file_in = file;
            [st_ctl_in] = hf_ccsds_ql(ql, st_ctl_in);

        else
            fprintf("No HF data in %s\n", file);
        end

        
    end
end
