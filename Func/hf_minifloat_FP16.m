% ------------------------------------------------
% Convert 16-bit mini-float to 4-Byte float
%
% (input)
% data12 : array of 16-bit mini-floa
%
% (return value)
% data : array of 4-Byte float
% 
% ------------------------------------------------
function [data] = hf_minifloat_FP16(data16)

    % set constants
	s_mask = 0x8000;
	e_mask = 0x7C00;
	m_mask = 0x03FF;
	n_exp = 5;
	n_man = 10;
  	e_bias = bitshift(1,(n_exp - 1)) - 1;    % emax = bias = 2^(n_exp - 1) - 1

    % source data
    len_src = numel(data16);
    
    % distnation data
    len_dst = len_src;    %size [Bytes]
    data = zeros(1,len_dst);

    for i=1:len_src
		
        sign = double( bitshift( bitand(data16(i), uint32(s_mask) ), -(n_exp + n_man) ) );
        exp  = double( bitshift( bitand(data16(i), uint32(e_mask) ), -n_man) ) - e_bias;
        man  = double( bitand( data16(i), uint32(m_mask) ) );

        f_value = 1.0;
        for k=1:n_man
            i_man = single( bitand( bitshift( man, -(n_man-k) ), uint32(1) ));
            f_value = f_value + i_man * 2.0^single(-k);
        end
        f_value = f_value * 2.0^single(exp);
    	
        if sign==1
            f_value = -f_value;
        end
    	
        data(i) =  f_value;
    end

end