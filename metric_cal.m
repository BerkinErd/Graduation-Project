%Object Detection Algorithm
function [metric]=metric_cal(perimeter,area)
 % Nesnenin metric deðerini hesaplar
  metric = 4*pi*area/perimeter^2;