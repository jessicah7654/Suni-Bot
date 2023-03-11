function animate(z_out, tspan, p, num_steps)
    sim_pause = 0.02;
    scale = (p(1) + p(2) + p(3))*1.2;

    skin_color = '#d4aa78';
    top_color = '#b31942';
    torso_color = '#a9a9a9';
    bottom_color = '#0a3161';

    % Prepare plot handles
    hold on
    arms = plot([0],[0],'LineWidth',5,'Color',skin_color);
    sleeves = plot([0],[0],'LineWidth',5,'Color',top_color);
    torso = plot([0],[0],'LineWidth',5,'Color',torso_color);
    legs = plot([0],[0],'LineWidth',5,'Color',skin_color);
    shorts = plot([0],[0],'LineWidth',5,'Color',bottom_color);
    feet = plot([0],[0],'LineWidth',5,'Color',skin_color);
    head = plot([0],[0],'.','MarkerSize',60,'Color',skin_color);

    rotor1 = plot([0],[0],'.','MarkerSize',30,'Color',top_color);
    rotor2 = plot([0],[0],'.','MarkerSize',30,'Color',bottom_color);

    xlabel('x')
    ylabel('y');
    h_title = title('t=0.0s');

    axis equal
    axis([-scale scale -scale scale]);
    skip_frame = 10;
    
    %Step through and update animation
    for i=1:num_steps
        if mod(i, skip_frame)
            continue
        end
        % interpolate to get state at current time.
        t = tspan(i);
        z = z_out(:,i);
        keypoints = keypoints_gymnast(z,p);

        r_shoulders = keypoints(:,1); % Vector to shoulders
        r_waist = keypoints(:,2);     % Vector to waist
        r_feet = keypoints(:,3);      % Vector to feet
        r_head = keypoints(:,4);      % Vector to head
        r_toes = keypoints(:,5);      % Vector to toes

        set(h_title,'String',  sprintf('t=%.2f',t) ); % update title    
        
        % Plot Arms
        set(arms,'XData' , [0 r_shoulders(1)] );
        set(arms,'YData' , [0 r_shoulders(2)] );   
        
        set(sleeves,'XData' , [r_shoulders(1)*0.6 r_shoulders(1)] );
        set(sleeves,'YData' , [r_shoulders(2)*0.6 r_shoulders(2)] );   

        % Plot Torso
        set(torso,'XData' , [r_shoulders(1) r_waist(1)] );
        set(torso,'YData' , [r_shoulders(2) r_waist(2)] );
                
        % Plot Legs
        set(legs,'XData' , [r_waist(1) r_feet(1)] );
        set(legs,'YData' , [r_waist(2) r_feet(2)] );
        
        short_endpoint_x = r_waist(1)+(r_feet(1)-r_waist(1))*0.4;
        short_endpoint_y = r_waist(2)+(r_feet(2)-r_waist(2))*0.4;

        set(shorts,'XData' , [r_waist(1) short_endpoint_x] );
        set(shorts,'YData' , [r_waist(2) short_endpoint_y] );

        % Plot Head
        set(head,'XData' , [r_head(1)] );
        set(head,'YData' , [r_head(2)] );

        % Plot Feet
        set(feet,'XData' , [r_feet(1) r_toes(1)] );
        set(feet,'YData' , [r_feet(2) r_toes(2)] );

        % Plot Rotor 1
        set(rotor1,'XData' , [r_shoulders(1)] );
        set(rotor1,'YData' , [r_shoulders(2)] );
        
        % Plot Rotor 1
        set(rotor2,'XData' , [r_waist(1)] );
        set(rotor2,'YData' , [r_waist(2)] );

        pause(sim_pause)
    end
end