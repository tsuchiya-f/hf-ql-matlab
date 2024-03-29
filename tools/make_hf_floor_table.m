% ----------------------------------------------------------------------------------------------
% file_in = 'C:\share\Linux\juice_test\20210928_Cfg6_complex_1\HF_20210928-1557.mat';
% make_hf_floor_table(file_in);
% ----------------------------------------------------------------------------------------------

function [] = make_hf_floor_table(file_in)

% output file name
file_out="C:\Users\tsuch\Documents\MATLAB\hf_ql_matlab\tools\HF_Table_Floor.t";
fprintf("%s\n",file_out);

% table size
n_ent = 256;               % [Bytes]

% load source data (dynamic spectra of x-, y-, z-ch power from radio full mode 
% time : time data
% freq : freequency data
% x_pow, y_pow, z_pow : dynamic spectra of x-, y-, z-ch power [dB]
load(file_in);

% find noise floor spectra
floor_x = median(x_pow,2);
floor_y = median(y_pow,2);
floor_z = median(z_pow,2);

% generate table
mag   = 2;
floor_x = floor_x * mag;
floor_y = floor_y * mag;
floor_z = floor_z * mag;

% check value
ind_x = find(floor_x > 255);
ind_y = find(floor_y > 255);
ind_z = find(floor_z > 255);
max_val = max([floor_x floor_y floor_z]);
n_err = numel([ind_x ind_y ind_z]);
if n_err > 0
    fprintf("Error. There are values whch exceed 255 : %d.\n", max_val);
    return;
end

% output table
fid = fopen(file_out,'w');

[~,name,ext] = fileparts(file_in);
fprintf(fid, "// --------------------------------------------------\n");
fprintf(fid, "// Soure file : %s%s\n", name, ext);    
fprintf(fid, "// --------------------------------------------------\n");
fprintf(fid, "// This table is generated by make_hf_floor_table.m\n");
fprintf(fid, "//  number of entry : %d x 3 compoments\n",n_ent);
fprintf(fid, "//  unit [dB * %d]\n", mag);
fprintf(fid, "// -------------------------------------------------\n");
fprintf(fid, "\n");
fprintf(fid, "const unsigned char hfTableFloor[3][HF_TABLE_FLOOR_ENT] = {\n");
fprintf(fid, "{\n");
for i=1:n_ent
    fprintf(fid, " 0x%02x",int8(floor_x(i)));
    if i ~= n_ent
        fprintf(fid, ",");        
    end
    if mod(i,16) == 0
        fprintf(fid, "\n");
    end
end
fprintf(fid, "},\n");
fprintf(fid, "{\n");
for i=1:n_ent
    fprintf(fid, " 0x%02x",int8(floor_y(i)));
    if i ~= n_ent
        fprintf(fid, ",");        
    end
    if mod(i,16) == 0
        fprintf(fid, "\n");
    end
end
fprintf(fid, "},\n");
fprintf(fid, "{\n");
for i=1:n_ent
    fprintf(fid, " 0x%02x",int8(floor_z(i)));
    if i ~= n_ent
        fprintf(fid, ",");        
    end
    if mod(i,16) == 0
        fprintf(fid, "\n");
    end
end
fprintf(fid, "}\n");
fprintf(fid, "};\n");

fclose(fid);

plot(freq,int8(floor_x),'r',freq,int8(floor_y),'g',freq,int8(floor_z),'b');


end


