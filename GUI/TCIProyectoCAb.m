function [q1,q2]=TCIProyectoCAb(Px,Py,L1,L2)
L3=sqrt(Px^2+Py^2);
Beta=atan2(Py,Px);
ParaAlpha=((L3)^2+(L1)^2-(L2)^2)/(2*L3*L1);
Alpha=acos(ParaAlpha);
q1=(Beta-Alpha)*180/pi; %Codo Abajo
%q1=(Beta+Alpha)*180/pi; %Codo Arribauuui
if (L3<sqrt(L1^2+L2^2))
    q2=(pi-asin((L3*sin(Alpha))/(L2)))*180/pi;
end
if (L3>sqrt(L1^2+L2^2))
    q2=(asin((L3*sin(Alpha))/(L2)))*180/pi;
end
if (L3==sqrt(L1^2+L2^2))
    q2=90;
end
if (isreal(q1))
    q1=q1;
else 
    q1='Nulo';
end
if (isreal(q2))
    q2=q2;
else 
    q2='Nulo';
end

end