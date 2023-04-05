%------------------------------------------------------------------------------------
% User inputs
%------------------------------------------------------------------------------------
st_ctl_in.raw_ver1_corrected = 1;
st_ctl_in.title = 'Mission_Test_CSW3.2.1_SCOP020';
st_ctl_in.ylim = [-90 -10];
st_ctl_in.xlim = [0 45];
st_ctl_in.cf = -104.1;

basedir_in = "E:\JUICE\system_test\20230113_Mission_Test_CSW3.2.1_SCOP020\bulkExport_2023_01_13T23_19_10_leal197_ded31615_RT_SCOP_020_RUN2\2023_01_13T23_19_10_leal197_ded31615_RT_SCOP_020_RUN2\FILES\PUBLISHED\GNDFSROOT\";
basedir_out = "C:\share\Linux\RESULTS\report_20230113_Mission_Test_CSW3.2.1_SCOP020\";

 indir  = [ ...
           "1RPR\" ...
           "1RPI\" ...
           "2RPR\" ...
           "2RPI\" ...
           ];
 outdir = [ ...
           "1RPR\" ...
           "1PWI\" ...
           "2RPR\" ...
           "2PWI\" ...
           ];
file_search_str = [ ...
    "*" "*" "*" "*" ...
    ];
%------------------------------------------------------------------------------------

ql=0;
st_ctl_in.timeout=5;

n_dir = numel(indir);
for j=1: n_dir

    tdir = append(basedir_out, outdir(j)); 
    mkdir(tdir)

    s = dir(append(basedir_in, indir(j), file_search_str(j)));
    n_file = numel(s);

    for i=1: n_file

        if s(i).bytes > 0

            file = s(i).name;

            infile = append(basedir_in, indir(j), file);
            outfile = append(basedir_out, outdir(j), file, '.hf.ccsds');
            [ret, st_ctl] = hf_get_packet(infile, outfile);

            if ret == 1 
                fprintf("HF data in %s\n", file);
%                fprintf("   SW ver : %d\n", st_ctl.ver);
                fprintf("   number of HF packet      : %d\n",st_ctl.n_pkt);
                fprintf("   number of HF data [Byte] : %d\n",st_ctl.out_sz);

                st_ctl_in.dir_in = append(basedir_in, indir(j));
                st_ctl_in.dir_out = append(basedir_out, outdir(j));
                st_ctl_in.file_in = file;
                [st_ctl_in] = hf_ccsds_ql(ql, st_ctl_in);

            else
                fprintf("No HF data in %s\n", file);
            end
        else
            fprintf("No HF data in %s\n", s(i).name);
        end
        
    end
end
