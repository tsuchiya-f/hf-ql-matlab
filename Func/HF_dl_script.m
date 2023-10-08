%------------------------------------------------------------------------------------
% ex)
%   % set user path first
%   addpath('C:\Users\tsuch\Documents\MATLAB\hf_ql_matlab')
%   addpath('C:\Users\tsuch\Documents\MATLAB\hf_ql_matlab\Func\')
%
%   input_file = 'C:\share\Linux\doc\juice\ccsds\system_test\20210531_SCPFM_PTR_RPWI_2\20210531_SCPFM_PTR_RPWI_2_day3_xid32770.data.hf.ccsds'
%   outdir = 'C:\share\Linux\doc\juice\ccsds\system_test\ql\'
%
%   ret = HF_dl_script(input_file, outdir)
%

function ret = HF_dl_script(input_file, outdir)

    %------------------------------------------------------------------------------------
    % User inputs
    %------------------------------------------------------------------------------------
    st_ctl_in.raw_ver1_corrected = 0;
    st_ctl_in.title = '';
    %------------------------------------------------------------------------------------
    
    ql=0;
    st_ctl_in.timeout=5;
    
    [indir_,infile_,inext_] = fileparts(input_file);

    indir = append(indir_, filesep);
    outext='.hf.ccsds';

    if ~exist('outdir', 'var') 
        outdir = indir_; 
    end
    mkdir(outdir)
    
    infile = append(infile_, inext_);
    output_file = append(outdir, infile, outext);
    [ret_data, st_ctl] = hf_get_packet(input_file, output_file);
    
    if ret_data == 1 
        fprintf("HF data in %s\n", infile);
%        fprintf("   SW ver : %d\n", st_ctl.ver);
        fprintf("   number of HF packet      : %d\n",st_ctl.n_pkt);
        fprintf("   number of HF data [Byte] : %d\n",st_ctl.out_sz);
    
        st_ctl_in.dir_in  = indir;
        st_ctl_in.dir_out = outdir;
        st_ctl_in.file_in = infile;
        hf_ccsds_ql(ql, st_ctl_in);
    else
        fprintf("No HF data in %s\n", infile);
    end

    ret = ret_data;

end
