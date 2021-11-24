% in_file = 'C:\share\Linux\RESULTS\20210527_SCPFM_PTR_RPWI\2021_05_11T05_17_29_pomi159_ded31615_RT_RPWI_DAY_3\USER\CFDP\RETRIEVAL\xid32777.mat';
% out_file = 'C:\share\Linux\RESULTS\20210527_SCPFM_PTR_RPWI\2021_05_11T05_17_29_pomi159_ded31615_RT_RPWI_DAY_3\USER\CFDP\RETRIEVAL\xid32777.csv';
% no = 1;
% ret = hf_conv_mat2csv(in_file, out_file, no);

% in_file = 'C:\share\Linux\RESULTS\20210527_SCPFM_PTR_RPWI\2021_05_17T04_32_56_pomi159_ded31615_RT_RPWI_FFT_DAY5\USER\CFDP\RETRIEVAL\xid32776.mat';
% out_file = 'C:\share\Linux\RESULTS\20210527_SCPFM_PTR_RPWI\2021_05_17T04_32_56_pomi159_ded31615_RT_RPWI_FFT_DAY5\USER\CFDP\RETRIEVAL\xid32776.csv';
% no = 1;
% ret = hf_conv_mat2csv(in_file, out_file, no);

%
function ret = hf_conv_mat2csv(in_file, out_file, no)

    ret = 0;
    load(in_file);
    
    n = numel(freq);
    
    i1 = 1 + n * (no-1);
    i2 = n * no;
    
    str_lab = {'freq[kHz]','Pout X[dBm]','Pout Y[dBm]','Pout Z[dBm]'};
    data1    = [freq;x_pow(i1:i2);y_pow(i1:i2);z_pow(i1:i2)]';
    data = [str_lab;num2cell(data1)];
    lab = sprintf('Measured data %d',no);
    xlswrite(out_file,data,lab);


end