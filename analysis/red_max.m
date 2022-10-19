% m : freq reduction
%-----------------------------------------
function data = red_max(data, mask, m)

    [mm, nn] = size(data);
    m1 = fix(mm/m);
    data_red = zeros(m1, nn);
    
    for j=1:nn
        for i=1:m1
            i1 = (i-1)*m+1;
            i2 = i*m;
            idx = find(mask(i1:i2,j) == 1);
            if numel(idx) == 0 
                data_red(i,j) = 0.0;
            else
                data_red(i,j) = max(data(idx,j));
            end
        end
    end

    data = data_red;

end
