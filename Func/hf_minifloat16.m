% ------------------------------------------------
% Convert 12-bit mini-float to 4-Byte float
%
% (input)
% data12 : array of 12-bit mini-float (the data length is 16bit)
%
% (return value)
% data : array of 4-Byte float
% 
% ------------------------------------------------
function [data] = hf_minifloat_FP16(data16)

    % set constants
	s_mask = 0x0800;
	e_mask = 0x07E0;
	m_mask = 0x001F;
	n_exp = 6;
	n_man = 5;
  	e_bias = bitshift(1,(n_exp - 1)) - 1;    % emax = bias = 2^(n_exp - 1) - 1

    % set temporal variables
	src_tmp = uint32(zeros(1,2));

    % source data
    len_src = numel(data16);
    
    % distnation data
    len_dst = len_src * 32 / 16;    %size [Bytes]
    data = zeros(1,len_dst);

    for i=1:len_src
		
		src_tmp(1) = bitshift( bitand( data16(i),   0xFFFF0000 ), -16);
		src_tmp(2) =           bitand( data16(i),   0x0000FFFF );

        for j=1:2
            sign = double( bitshift( bitand(src_tmp(j), uint32(s_mask) ), -(n_exp + n_man) ) );
            exp  = double( bitshift( bitand(src_tmp(j), uint32(e_mask) ), -n_man) ) - e_bias;
            man  = double( bitand( src_tmp(j), uint32(m_mask) ) );

            f_value = 1.0;
            for k=1:n_man
                i_man = single( bitand( bitshift( man, -(n_man-k) ), uint32(1) ));
                f_value = f_value + i_man * 2.0^single(-k);
            end
            f_value = f_value * 2.0^single(exp);
    	
            if sign==1
                f_value = -f_value;
            end
    	
            ii = int32((i-1)*2+j);
            data(ii) =  f_value;
        end
    end

end