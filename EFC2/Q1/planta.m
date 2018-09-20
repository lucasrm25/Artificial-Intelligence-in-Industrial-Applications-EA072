function [sys] = planta(kp,kd,ki)
Khw = 14732;
m1 = 2.778;
c1 = 2.94;
sys = tf([Khw*kp/m1 Khw*ki/m1],[1 c1+Khw*kd Khw*kp/m1 Khw*ki/m1]);
