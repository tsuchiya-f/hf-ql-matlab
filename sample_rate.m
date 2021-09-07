function ret = sample_rate(decimation)
    ret =0;
    switch decimation
        
        case 1
            ret=296e+3; 
        case 2
            ret=296e+3/2; 
        case 3
            ret=296e+3/4; 
        case 4
            ret=296e+3/8; 
    end
    
end