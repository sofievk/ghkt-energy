function m = softmin(a,b,s)
    % numerically stable softmin
    M = min(a,b);
    m = M - (1/s)*log(exp(-s*(a-M)) + exp(-s*(b-M)));
end

