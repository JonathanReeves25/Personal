clear
clc
temp = readtable("Data.csv");
Data(:,1) = temp(:,16);
Data(:,2) = temp(:,19);
Data(:,3) = temp(:,17);
Data(:,4) = temp(:,8);
Data = table2array(Data);


Avgdat = zeros(9,4);

Avgdat(1,1) = mean(Data(1:20,1));
Avgdat(2,1) = mean(Data(21:40,1));
Avgdat(3,1) = mean(Data(41:60,1));
Avgdat(4,1) = mean(Data(61:80,1));
Avgdat(5,1) = mean(Data(81:100,1));
Avgdat(6,1) = mean(Data(101:120,1));
Avgdat(7,1) = mean(Data(121:140,1));
Avgdat(8,1) = mean(Data(141:160,1));
Avgdat(9,1) = mean(Data(161:180,1));

Avgdat(1,2) = mean(Data(1:20,2));
Avgdat(2,2) = mean(Data(21:40,2));
Avgdat(3,2) = mean(Data(41:60,2));
Avgdat(4,2) = mean(Data(61:80,2));
Avgdat(5,2) = mean(Data(81:100,2));
Avgdat(6,2) = mean(Data(101:120,2));
Avgdat(7,2) = mean(Data(121:140,2));
Avgdat(8,2) = mean(Data(141:160,2));
Avgdat(9,2) = mean(Data(161:180,2));

Avgdat(1,3) = mean(Data(1:20,3));
Avgdat(2,3) = mean(Data(21:40,3));
Avgdat(3,3) = mean(Data(41:60,3));
Avgdat(4,3) = mean(Data(61:80,3));
Avgdat(5,3) = mean(Data(81:100,3));
Avgdat(6,3) = mean(Data(101:120,3));
Avgdat(7,3) = mean(Data(121:140,3));
Avgdat(8,3) = mean(Data(141:160,3));
Avgdat(9,3) = mean(Data(161:180,3));

Avgdat(1,4) = mean(Data(1:20,4));
Avgdat(2,4) = mean(Data(21:50,4));
Avgdat(3,4) = mean(Data(41:60,4));
Avgdat(4,4) = mean(Data(61:80,4));
Avgdat(5,4) = mean(Data(81:100,4));
Avgdat(6,4) = mean(Data(101:120,4));
Avgdat(7,4) = mean(Data(121:140,4));
Avgdat(8,4) = mean(Data(141:160,4));
Avgdat(9,4) = mean(Data(161:180,4));

Avgdat(:,2) = -1.*Avgdat(:,2);
Avgdat(:,3) = -1.*Avgdat(:,3);

Avgdat(:,5) = Avgdat(:,2).*(4/3).*(Avgdat(:,4));
Avgdat(:,6) = Avgdat(:,3).*(4/3).*(Avgdat(:,4));

%%
% 1 Angle of Attack
% 2 Lift
% 3 Drag
% 4 Dynamic Pressure
% 5 Lift Coefficent
% 6 Drag Coefficent
%%

figure(1)
clf
subplot(2,2,1)
grid on
hold on
plot(Avgdat(:,1),Avgdat(:,5),"kd-")
title("C_L vs \alpha")
xlabel("\alpha")
ylabel("C_L")

subplot(2,2,2)
grid on
hold on
plot(Avgdat(:,5).^2,Avgdat(:,6),"kd-")
title("C_D vs C_L^2")
ylabel("C_D")
xlabel("C_L^2")

subplot(2,2,3)
grid on
hold on
plot(Avgdat(:,5),Avgdat(:,6),"kd-")
title("C_D vs C_L")
ylabel("C_D")
xlabel("C_L")

Avgdat(:,7) = Avgdat(:,5)./Avgdat(:,6);