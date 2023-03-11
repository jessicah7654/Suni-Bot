function p = model_parameters()
    % Parameters
    l_arms = 89/1000;
    l_torso = 39.5/1000;
    l_legs = 109/1000;

    com_arms = 73.85/1000; 
    com_torso = 30.47/1000; 
    com_legs = 77/1000;
    
    m_arms = 243.16/1000; 
    m_torso = 232.33/1000; 
    m_legs = 103.81/1000; 

    I_arms = 13199.2/(1000^3); 
    I_torso = 50013.02/(1000^3); 
    I_legs = 12900.79/(1000^3);

    g = 9.8; 
 
    p = [l_arms; l_torso; l_legs; ...
         com_arms; com_torso; com_legs; ...
         m_arms; m_torso; m_legs; ...
         I_arms; I_torso; I_legs; ...
         g];
end