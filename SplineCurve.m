function u = SplineCurve(ctrl_pt, t, tf)
    time_pts = linspace(0,tf,length(ctrl_pt));
    u = spline(time_pts,ctrl_pt,t);
end