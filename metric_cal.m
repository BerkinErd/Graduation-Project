%Object Detection Algorithm
function [metric]=metric_cal(perimeter,area)
 % Nesnenin metric de�erini hesaplar
  metric = 4*pi*area/perimeter^2;