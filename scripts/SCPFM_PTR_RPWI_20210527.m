%------------------------------------------------------------------------------------
% User inputs
%------------------------------------------------------------------------------------
st_ctl_in.raw_ver1_corrected = 1;
st_ctl_in.title = '20210527_SCPFM_PTR_RPWI';
%st_ctl_in.ylim = [-60 -10];

basedir_in = "C:\share\Linux\RESULTS\20210527_SCPFM_PTR_RPWI\";
basedir_out = "C:\share\Linux\RESULTS\20210527_SCPFM_PTR_RPWI\";

%indir  = ["2021_05_11T05_17_29_pomi159_ded31615_RT_RPWI_DAY_3\USER\CFDP\RETRIEVAL\"];
%outdir = ["DAY_3_\"];
%file_search_str = 'xid32776.data';

% indir  = ["2021_05_17T04_32_56_pomi159_ded31615_RT_RPWI_FFT_DAY5\USER\CFDP\RETRIEVAL\"];
% outdir = ["DAY_5\"];
% file_search_str = 'xid32774.data';

% indir  = ["2021_05_15T04_28_37_pomi159_ded31615_RT_RPWI_FFT_DAY4\USER\CFDP\RETRIEVAL\"  ...
%           "2021_05_17T04_32_56_pomi159_ded31615_RT_RPWI_FFT_DAY5\USER\CFDP\RETRIEVAL\"];
% outdir = ["DAY_4\" "DAY_5\"];
% file_search_str = '*.data';

 indir  = ["2021_05_11T05_17_29_pomi159_ded31615_RT_RPWI_DAY_3\USER\CFDP\RETRIEVAL\"  ...
           "2021_05_15T04_28_37_pomi159_ded31615_RT_RPWI_FFT_DAY4\USER\CFDP\RETRIEVAL\"  ...
           "2021_05_17T04_32_56_pomi159_ded31615_RT_RPWI_FFT_DAY5\USER\CFDP\RETRIEVAL\"];
 outdir = ["DAY_3\" "DAY_4\" "DAY_5\"];
 file_search_str = '*.data';
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

        else
            fprintf("No HF data in %s\n", file);
        end

        
    end
end
