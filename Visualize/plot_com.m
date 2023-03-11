function plot_com(z_out,p)
    com = COM_gymnast(z_out,p);
    com_x = com(1,:);
    com_y = com(2,:);
    plot(com_x,com_y);

    axis equal
    scale = (p(1) + p(2) + p(3))/1.9;
    axis([-scale scale -scale scale]);
    xlabel('x'); 
    ylabel('y');
    legend('Trajectory');
end