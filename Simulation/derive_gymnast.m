function derive_everything() 
name = 'gymnast';

% Define global variables
syms t g real

% Define variables for generalized coordinates and derivatives
syms th_1 dth_1 ddth_1 th_2 dth_2 ddth_2 th_3 dth_3 ddth_3 real

% Define length variables
syms l_arms l_torso l_legs com_arms com_torso com_legs real

% Define inertial parameters
syms m_arms m_torso m_legs I_arms I_torso I_legs real

% Define Control
syms tau_shoulders tau_waist real


% Group them for later use
q = [th_1; th_2; th_3];                           % generalized coordinates
dq = [dth_1; dth_2; dth_3];                       % first time derivative
ddq = [ddth_1; ddth_2; ddth_3];                   % second time derivative

u = [tau_shoulders; tau_waist];                   % control forces

                                                  % TODO CONSTRAINT FORCES?
                             
p = [l_arms; l_torso; l_legs;
     com_arms; com_torso; com_legs; 
     m_arms; m_torso; m_legs; 
     I_arms; I_torso; I_legs; 
     g];                                        % Parameters

%%% Calculate important vectors and their time derivatives.

% Define fundamental unit vectors.
ihat = [1; 0; 0];
jhat = [0; 1; 0];
khat = cross(ihat,jhat);

% Define other unit vectors for use in defining other vectors.
armhat =  sin(th_1)*ihat - cos(th_1)*jhat;                                    % Direction of torso
torsohat = sin(th_1 + th_2)*ihat - cos(th_1 + th_2)*jhat;                  % Direction of legs
leghat = sin(th_1 + th_2 + th_3)*ihat - cos(th_1 + th_2 + th_3)*jhat;      % Direction of legs

% A handy anonymous function for taking first and second time derivatives
% of vectors using the chain rule.  See Lecture 6 for more information. 
ddt = @(r) jacobian(r,[q;dq])*[dq;ddq]; 

% Define vectors to key points
shoulders = l_arms*armhat;
waist = shoulders + l_torso*torsohat;
feet = waist + l_legs*leghat;
head = shoulders - (l_torso/2)*torsohat;
toes = feet + (l_legs/5)*[-leghat(2), leghat(1), 0]';

r_coma = com_torso*armhat;
r_comt = shoulders + com_torso*torsohat;
r_coml = waist + com_legs*leghat;

keypoints = [shoulders waist feet head toes]; % For simulation visualization

% Take time derivatives of vectors as required for kinetic energy terms.
drcoma = ddt(r_coma); % rate of change com arms
drcomt = ddt(r_comt); % rate of change com torso
drcoml = ddt(r_coml); % rate of change com legs

%%% Calculate Kinetic Energy, Potential Energy, and Generalized Forces

% F2Q calculates the contribution of a force to all generalized forces
% for forces, F is the force vector and r is the position vector of the 
% point of force application
F2Q = @(F,r) simplify(jacobian(r,q)'*(F)); 

% M2Q calculates the contribution of a moment to all generalized forces
% M is the moment vector and w is the angular velocity vector of the
% body on which the moment acts
M2Q = @(M,w) simplify(jacobian(w,dq)'*(M)); 

% Define kinetic energies. See Lecture 6 formula for kinetic energy
% of a rigid body.
T_a = (1/2)*m_arms*dot(drcoma, drcoma) + (1/2)* I_arms * dth_1^2;
T_t = (1/2)*m_torso*dot(drcomt, drcomt) + (1/2)* I_torso * (dth_1 + dth_2)^2;
T_l = (1/2)*m_legs*dot(drcoml, drcoml) + (1/2)* I_legs * (dth_1 + dth_2 + dth_3)^2;


% Define potential energies. See Lecture 6 formulas for gravitational 
% potential energy of rigid bodies and elastic potential energies of
% energy storage elements.
V_a = m_arms*g*dot(r_coma, jhat);
V_t = m_torso*g*dot(r_comt, jhat);
V_l = m_legs*g*dot(r_coml, jhat);


% Define contributions to generalized forces.  See Lecture 6 formulas for
% contributions to generalized forces.
Q_shoulder = M2Q(tau_shoulders*khat, dth_2*khat);  % Torque from shoulder
Q_waist = M2Q(tau_waist*khat, dth_3*khat);         % Torque from waist


% Sum kinetic energy terms, potential energy terms, and generalized force
% contributions.
T = T_a + T_t + T_l;
V = V_a + V_t + V_l;
Q = Q_shoulder + Q_waist;

% Calculate rcm, the location of the center of mass
num = m_arms*r_coma + m_torso*r_comt + m_legs*r_coml;
den = m_arms + m_torso + m_legs;
r_cm = num/den;

%% All the work is done!  Just turn the crank...
%%% Derive Energy Function and Equations of Motion
E = T+V;                                         % total system energy
L = T-V;                                         % the Lagrangian
eom = ddt(jacobian(L,dq)') - jacobian(L,q)' - Q;  % form the dynamics equations
size(eom);

%%% Rearrange Equations of Motion. 
A = jacobian(eom,ddq);
b = A*ddq - eom;

%%% Write functions to evaluate dynamics, etc...
z = sym(zeros(length([q;dq]),1)); % initialize the state vector
z(1:3,1) = q;  
z(4:6,1) = dq;

% Write functions to a separate folder because we don't usually have to see them
directory = 'Simulation/AutoDerived/';
% Write a function to evaluate the energy of the system given the current state and parameters
matlabFunction(E,'file',[directory 'energy_' name],'vars',{z p});
% Write a function to evaluate the A matrix of the system given the current state and parameters
matlabFunction(A,'file',[directory 'A_' name],'vars',{z p});
% Write a function to evaluate the b vector of the system given the current state, current control, and parameters
matlabFunction(b,'file',[directory 'b_' name],'vars',{z u p});

matlabFunction(keypoints,'file',[directory 'keypoints_' name],'vars',{z p});


% Write a function to evaluate the X and Y coordinates and speeds of the center of mass given the current state and parameters
drcm = ddt(r_cm);             % Calculate center of mass velocity vector
COM = [r_cm(1:2); drcm(1:2)]; % Concatenate x and y coordinates and speeds of center of mass in array
matlabFunction(COM,'file',[directory 'COM_' name],'vars',{z p});

% Write Function to eval Jacobian of energy
dq_E = jacobian(E,dq);
matlabFunction(dq_E,'file',[directory 'dqE_' name],'vars',{z p});

% Extra terms
h_p_terms = eom + Q - A*ddq;
matlabFunction(h_p_terms,'file',[directory 'motion_terms_' name],'vars',{z p});

% Write a function to evaluate other energies
matlabFunction(T,'file',[directory 'energy_Kinetic_' name],'vars',{z p});
matlabFunction(V,'file',[directory 'energy_Potential_' name],'vars',{z p});
