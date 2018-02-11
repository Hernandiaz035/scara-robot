function [theta1 , theta2 , posible]=Scara_Inversa( Px , Py , L1 , L2 , zurdo )
    if nargin < 5
        zurdo = 0;
    end
    
    posible = true;
    posible = posible && ((Px^2 + Py^2) <= (L1 + L2)^2);
    posible = posible && ((Px^2 + Py^2) >= (L1^2 + L2^2 - 2*L1*L2*cosd(180-(2400*1.8/32))));
    
    
    L3 = sqrt(Px^2+Py^2);
    Beta = atan2(Py,Px);
    ParaAlpha = ((L3)^2+(L1)^2-(L2)^2)/(2*L3*L1);
    Alpha = acos(ParaAlpha);
    
    if (L3 < sqrt(L1^2+L2^2))
        theta2 = rad2deg(pi-asin((L3*sin(Alpha))/(L2)));
    else
        theta2 = rad2deg(asin((L3*sin(Alpha))/(L2)));
    end
    
    
    if zurdo
        theta1 = rad2deg(Beta+Alpha); %Codo Arriba
        theta2 = -theta2;
    else
        theta1 = rad2deg(Beta-Alpha); %Codo Abajo
    end
%     theta = [theta1 , theta2];
end