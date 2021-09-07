function [dop,dol,doc,ang] = hf_proc_get_pol(I, Q, U, V)

    dop = sqrt(Q.*Q + U.*U + V.*V) ./ I;
    dol = sqrt(Q.*Q + U.*U) ./ I;
    doc = V ./ I;
    
    [m,n] = size(I);
    ang = zeros(m,n);
    for j=1:m
        for i=1:n
            if U(j,i) >= 0.0 && Q(j,i) >= 0.0
                ang(j,i) = 0.5 * atan(U(j,i)/Q(j,i)) * 180.0/pi;
            elseif U(j,i) <= 0.0 && Q(j,i) >= 0.0
                ang(j,i) = 0.5 * atan(U(j,i)/Q(j,i)) * 180.0/pi + 180.0;
            elseif Q(j,i) <= 0.0
                ang(j,i) = 0.5 * atan(U(j,i)/Q(j,i)) * 180.0/pi + 90.0;
            end
        end
    end

end

