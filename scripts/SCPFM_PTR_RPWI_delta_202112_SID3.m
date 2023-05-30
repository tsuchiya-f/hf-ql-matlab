%------------------------------------------------------------------------------------
% User inputs
%------------------------------------------------------------------------------------
st_ctl_in.raw_ver1_corrected = 1;
st_ctl_in.title = '20211201-SCPFM_PTR_RPWI_delta';
st_ctl_in.ylim = [-90 -10];
st_ctl_in.xlim = [0 45];
st_ctl_in.cf = -104.1;
st_ctl.power_unit = 'dBm@ADCin';

basedir_in  = "C:\share\Linux\RESULTS\20211201-SCPFM_PTR_RPWI_delta\";
basedir_out = "C:\share\Linux\RESULTS\report_SCPFM_PTR_RPWI_delta\";

  indir  = ["CFDP_RPWI_SCM_TEST\2021_11_25T21_11_18_pomi159_ded31614_RT_RPWI_FFT_SCM\USER\CFDP\RETRIEVAL\"];
  outdir = ["RPWI_SCM_TEST\"];
 file_search_str = 'xid32816.data';

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
            hf_ccsds_ql(ql, st_ctl_in)
        elseif ret == -1
            fprintf("Error in %s\n", file);            
        else
            fprintf("No HF data in %s\n", file);
        end

        
    end
end
