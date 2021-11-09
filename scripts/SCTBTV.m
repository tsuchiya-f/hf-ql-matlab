%------------------------------------------------------------------------------------
% User inputs
%------------------------------------------------------------------------------------
st_ctl_in.raw_ver1_corrected = 1;
st_ctl_in.title = 'SCTBTV';
%st_ctl_in.ylim = [-60 -10];

basedir_in = "C:\Users\tsuch\Dropbox\JUICE_Data\SCTBTV-July-2021-Complete-bulkExport\";
basedir_out = "C:\share\Linux\RESULTS\SCTBTV\";

 indir  = [ ...
           "SCTBTV_Phase3\RPWI_CFDP_PH3\" ...
           "SCTBTV_Phase5\CFDP_S22_P4_P5_RPWI\" ...
           "SCTBTV_Phase11\CFDP_RPWI_S53_P11_2\" ...
           "SCTBTV_Phase12\RIME_CFDP_S59_P12\" ...     % No HF data
           "SCTBTV_Phase13\RPWI_CFDP_S66_P13\"];
 outdir = ["Phase3\" "Phase5\" "Phase11\" "Phase12\" "Phase13\"];
% indir  = ["SCTBTV_Phase12\RIME_CFDP_S59_P12\"];
% outdir = ["Phase12\"];
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
