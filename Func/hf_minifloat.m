% ------------------------------------------------
% Convert 12-bit mini-float to 4-Byte float
%
% (input)
% data12 : array of 12-bit mini-float (packed on uint32)
%
% (return value)
% data : array of 4-Byte float
% 
% ------------------------------------------------
function [data] = hf_minifloat(data12)

    % set constants
	s_mask = 0x0800;
	e_mask = 0x07E0;
	m_mask = 0x001F;
	n_exp = 6;
	n_man = 5;
  	e_bias = bitshift(1,(n_exp - 1)) - 1;    % emax = bias = 2^(n_exp - 1) - 1

    % set temporal variables
	src_tmp = uint32(zeros(1,8));

    % source data
    len_src = numel(data12);
    
    % distnation data
    len_dst = len_src * 32 / 12;    %size [Bytes]
    data = zeros(1,len_dst);

    for i=1:3:len_src
		
		src_tmp(1) = bitshift( bitand( data12(i),   0xFFF00000 ), -20);
		src_tmp(2) = bitshift( bitand( data12(i),   0x000FFF00 ),  -8);
		src_tmp(3) = bitshift( bitand( data12(i),   0x000000FF ),   4) + bitshift( bitand( data12(i+1), 0xF0000000 ), -28);
		src_tmp(4) = bitshift( bitand( data12(i+1), 0x0FFF0000 ), -16);
		src_tmp(5) = bitshift( bitand( data12(i+1), 0x0000FFF0 ),  -4);
		src_tmp(6) = bitshift( bitand( data12(i+1), 0x0000000F ),   8) + bitshift( bitand( data12(i+2), 0xFF000000 ), -24);
		src_tmp(7) = bitshift( bitand( data12(i+2), 0x00FFF000 ), -12);
		src_tmp(8) =           bitand( data12(i+2), 0x00000FFF );

        for j=1:8
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
    	
            ii = int32((i-1)/3*8+j);
            data(ii) =  f_value;
        end
    end

end