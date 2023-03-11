function h_p_terms = motion_terms_gymnast(in1,in2)
%MOTION_TERMS_GYMNAST
%    H_P_TERMS = MOTION_TERMS_GYMNAST(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 9.1.
%    02-Dec-2022 17:44:20

com_legs = in2(6,:);
com_torso = in2(5,:);
dth_1 = in1(4,:);
dth_2 = in1(5,:);
dth_3 = in1(6,:);
g = in2(13,:);
l_arms = in2(1,:);
l_torso = in2(2,:);
m_arms = in2(7,:);
m_legs = in2(9,:);
m_torso = in2(8,:);
th_1 = in1(1,:);
th_2 = in1(2,:);
th_3 = in1(3,:);
t2 = cos(th_1);
t3 = sin(th_1);
t4 = th_1+th_2;
t5 = l_arms.*t2;
t6 = cos(t4);
t7 = l_arms.*t3;
t8 = sin(t4);
t9 = t4+th_3;
t10 = cos(t9);
t11 = sin(t9);
t12 = com_torso.*t6;
t13 = l_torso.*t6;
t14 = com_torso.*t8;
t15 = l_torso.*t8;
t16 = dth_1.*t12;
t17 = dth_2.*t12;
t18 = com_legs.*t10;
t19 = dth_1.*t14;
t20 = dth_2.*t14;
t21 = com_legs.*t11;
t28 = t5+t12;
t29 = t7+t14;
t22 = dth_1.*t18;
t23 = dth_2.*t18;
t24 = dth_3.*t18;
t25 = dth_1.*t21;
t26 = dth_2.*t21;
t27 = dth_3.*t21;
t30 = dth_1.*t28;
t31 = dth_1.*t29;
t32 = t13+t18;
t33 = t15+t21;
t34 = t16+t17;
t35 = t19+t20;
t36 = dth_1.*t32;
t37 = dth_2.*t32;
t38 = dth_1.*t33;
t39 = dth_2.*t33;
t40 = t5+t32;
t41 = t7+t33;
t44 = t17+t30;
t45 = t20+t31;
t46 = t22+t23+t24;
t47 = t25+t26+t27;
t42 = dth_1.*t40;
t43 = dth_1.*t41;
t48 = t12.*t45.*2.0;
t49 = t14.*t44.*2.0;
t51 = t24+t36+t37;
t52 = t27+t38+t39;
t50 = -t49;
t53 = t24+t37+t42;
t54 = t27+t39+t43;
t55 = t21.*t53.*2.0;
t56 = t18.*t54.*2.0;
t58 = t33.*t53.*2.0;
t59 = t32.*t54.*2.0;
t57 = -t55;
t60 = -t59;
mt1 = [-dth_2.*((m_legs.*(t58+t60+t40.*t52.*2.0-t41.*t51.*2.0))./2.0-(m_torso.*(t48+t50-t28.*t35.*2.0+t29.*t34.*2.0))./2.0)-(dth_3.*m_legs.*(t55-t56+t40.*t47.*2.0-t41.*t46.*2.0))./2.0+g.*m_legs.*t41+g.*m_torso.*t29+com_torso.*g.*m_arms.*t3;-dth_2.*((m_legs.*(t58+t60+t32.*t52.*2.0-t33.*t51.*2.0))./2.0-(m_torso.*(t48+t50-t12.*t35.*2.0+t14.*t34.*2.0))./2.0)-(m_legs.*(t51.*t54.*2.0-t52.*t53.*2.0))./2.0-(m_torso.*(t34.*t45.*2.0-t35.*t44.*2.0))./2.0-(dth_3.*m_legs.*(t55-t56+t32.*t47.*2.0-t33.*t46.*2.0))./2.0+g.*m_legs.*t33+g.*m_torso.*t14];
mt2 = [m_legs.*(t46.*t54.*2.0-t47.*t53.*2.0).*(-1.0./2.0)-(dth_3.*m_legs.*(t55-t56+t18.*t47.*2.0-t21.*t46.*2.0))./2.0-(dth_2.*m_legs.*(t55-t56+t18.*t52.*2.0-t21.*t51.*2.0))./2.0+g.*m_legs.*t21];
h_p_terms = [mt1;mt2];
