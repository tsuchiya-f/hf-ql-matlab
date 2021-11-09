% [ret, freq_rfi] = hf_find_RFI('C:\share\Linux\juice_test\20210926_PSSR1_wo_RFIrejection\HF_20210926-1526.mat');

function [ret, freq_rfi] = hf_find_RFI(mat_file)

    ret = 0;
    load(mat_file);
    
    n = numel(freq);
    
    sp = sp_x + sp_y + sp_z;
    
    n_width = 20;
    
    med_value = zeros(1,n);
    for i=1:n
        i1 = max([1 i - n_width / 2]);
        i2 = min([n i + n_width / 2]);
        kernel = sp(i1:i2);
        med_value(i) = median(kernel);
    end

    cor_value = sp;
    diff = sp - med_value;
    thl = 25.0;
    freq_rfi = [];
    for i=1:n
        if diff(i) > thl
            cor_value(i) = NaN; 
            freq_rfi = [freq_rfi freq(i)];
        end
    end    
    
    tiledlayout(2,1)

    nexttile(1)
    plot(freq/1000, sp, 'r', freq/1000, med_value, 'b');
    nexttile(2)
    plot(freq/1000, sp, 'r', freq/1000, cor_value, 'b');

%     [~,name,~] = fileparts(mat_file);
%     dir_out = 'C:\Users\tsuch\Documents\MATLAB\hf_ql_matlab\tools\';
%     file_out = append(dir_out,name,'_RFI_freq.mat');
%     fprintf("%s\n",file_out);
%     save(file_out, 'freq_rfi');

end