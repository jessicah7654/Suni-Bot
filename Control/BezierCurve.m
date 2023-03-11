function u = BezierCurve(ctrl_pt, t)

n = length(ctrl_pt)-1;
u = 0;
    for i = 0:n
        u = u + nchoosek(n,i) * (1-t)^(n-i) * t^i * ctrl_pt(i+1);
    end
end


