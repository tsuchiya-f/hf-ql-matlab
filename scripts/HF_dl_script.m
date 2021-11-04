%------------------------------------------------------------------------------------
% User inputs
%------------------------------------------------------------------------------------
%st_ctl_in.raw_ver1_corrected = 1;
st_ctl_in.title = '';

basedir_in  = "C:\share\Linux\juice_test\";
basedir_out = "C:\share\Linux\juice_test\";

indir  = ["20211102_radio_burst_SGin\"];
outdir = ["20211102_radio_burst_SGin\"];
file_search_str = 'HF_20211102-1540.ccs';

% indir  = ["20210927_Cgf6\"];
% outdir = ["20210927_Cgf6\DL\"];
% file_search_str = 'HF_20210927-1457.ccs';
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
