function [dop, dol, doc, ang, k_lon, k_lat] = hf_proc_get_pol_3D(I, Q, U, Vx, Vy, Vz)

    V_mag = sqrt(Vx.*Vx + Vy.*Vy + Vz.*Vz);
    dop = sqrt(Q.*Q + U.*U + V_mag.*V_mag) ./ I;
    dol = sqrt(Q.*Q + U.*U) ./ I;
    doc = V_mag ./ I;
    
    n = numel(I);
    ang = zeros(n);
    for i=1:n
        if U(i) >= 0.0 && Q(i) >= 0.0
            ang(i) = 0.5 * atan(U(i)/Q(i)) * 180.0/pi;
        elseif U(i) <= 0.0 && Q(i) >= 0.0
            ang(i) = 0.5 * atan(U(i)/Q(i)) * 180.0/pi + 180.0;
        elseif Q(i) <= 0.0
            ang(i) = 0.5 * atan(U(i)/Q(i)) * 180.0/pi + 90.0;
        end
    end

    k_lat = asin(Vz/sqrt(Vx.*Vx + Vy.*Vy)) * 180.0 / pi;
    k_lon = atan2(Vy, Vx) * 180.0 / pi;

end

