function [I, Q, U, V] = hf_proc_get_stokes(p1, p2, re, im)
    I = p1 + p2;
    Q = p1 - p2;
    U = re * 2.0;
    V = im * 2.0;
end