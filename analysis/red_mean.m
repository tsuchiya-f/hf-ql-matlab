% m : freq reduction
%-----------------------------------------
function data = red_mean(data, mask, m)

    [mm, nn] = size(data);
    m1 = fix(mm/m);
    data_red = zeros(m1, nn);
    
    for j=1:nn
        for i=1:m1
            i1 = (i-1)*m+1;
            i2 = i*m;
            idx = find(mask(i1:i2,j) == 1) + (i-1)*m;
            if numel(idx) == 0 
                data_red(i,j) = 0.0;
            else
                data_red(i,j) = mean(data(idx,j));
            end
        end
    end

    data = data_red;

end


% % m : freq reduction
% % n:  time reduction
% %-----------------------------------------
% function data = red_max(data, mask, m, n)
% 
%     [mm, nn] = size(data);
%     m1 = fix(mm/(m*2+1));
%     n1 = fix(nn/(n*2+1));
%     data_red = zeros(m1, n1);
%     
%     for i=1:m*2+1:mm-m
%         ii = fix((i-1)/(m*2+1))+1;
%         for j=1:n*2+1:nn-n
%             jj = fix((j-1)/(n*2+1))+1;
%             data_red(ii,jj) = max(data(i:i+m,j:j+n));
%         end
%     end
% 
%     data = data_red;
% 
% end
