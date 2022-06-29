%Program to plot flight simulation data for Space Cowboys launch vehicle "Gemini" 
clear
temp = readtable("Booster.csv");
datab = table2array(temp(:,[1 23 19 16]));
temp = readtable("Sustainer.csv");
datas = table2array(temp(:,[1 23 19 16]));
clear temp

%{
figure(1)
clf
hold on
grid on
plot(datas(:,1), datas(:,2),"r")
plot(datas(:,1), datas(:,3),"b")
plot(datas(:,1), datas(:,4),"g")
plot([datas(1,1) datas(2158,1)], [0 0],"k")
plot([0 20 20 0 0], [-250 -250 2400 2400 -250], "k")
legend("Altitude (m)", "Vertical Velocity (m/2)", "Vertical Acceleration (m/s^2)", "Orientation", "Horizontal")
axis([datas(1,1) datas(2158,1) -250 35000])
title("Sustainer Full")
xlabel("Time")
ylabel("Altitude, Velocity, and Acceleration")
set(gcf, 'Position',  [0, 0, 1000, 1000])


figure(2)
clf
hold on
grid on
plot(datas(:,1), datas(:,2),"r")
plot(datas(:,1), datas(:,3),"b")
plot(datas(:,1), datas(:,4),"g")
plot([0 datas(2158,1)], [0 0],"k")
legend("Altitude (m)", "Vertical Velocity (m/2)", "Vertical Acceleration (m/s^2)", "Orientation", "Horizontal")
axis([0 20 -250 2400])
title("Sustainer Zoomed")
xlabel("Time")
ylabel("Altitude, Velocity, and Acceleration")
set(gcf, 'Position',  [0, 0, 1000, 1000])

figure(3)
%clf
hold on
grid on
plot(datab(:,1), datab(:,2),"r")
plot(datab(:,1), datab(:,3),"b")
plot(datab(:,1), datab(:,4),"g")
plot([0 datab(810,1)], [0 0],"k")
plot([0 25 25 0 0], [-400 -400 1000 1000 -400], "k")
legend("Altitude (m)", "Vertical Velocity (m/2)", "Vertical Acceleration (m/s^2)", "Orientation", "Horizontal")
axis([0 datab(810,1) -400 7000])
title("Booster Full")
xlabel("Time")
ylabel("Altitude, Velocity, and Acceleration")
set(gcf, 'Position',  [0, 0, 1000, 1000])

figure(4)
%clf
hold on
grid on
plot(datab(:,1), datab(:,2),"r")
plot(datab(:,1), datab(:,3),"b")
plot(datab(:,1), datab(:,4),"g")
plot([0 datab(810,1)], [0 0],"k")
plot([5.5437 5.5437], [-10000 40000], "k") %Seperation
set(text(5.5437+.6,970,"Seperation"),'Rotation',-90)
plot([17.432 17.432], [-10000 40000], "k") %Apogee/Parachute
set(text(17.432+.6,920,"Apogee/Parachute Deplyment"),'Rotation',-90)
legend("Altitude (m)", "Vertical Velocity (m/2)", "Vertical Acceleration (m/s^2)", "Orientation", "Horizontal")
axis([0 25 -400 1000])
title("Booster Zoomed")
xlabel("Time")
ylabel("Altitude, Velocity, and Acceleration")
set(gcf, 'Position',  [0, 0, 1000, 1000])
%}

figure(5)
clf
hold on
grid on
plot([0],[0],"k-")
plot([0],[0],"k-.")
plot([0],[0],"r-")
plot([0],[0],"g-")
plot([0],[0],"b-")
plot(datas(:,1), datas(:,2)/10,"r-")
plot(datas(:,1), datas(:,3),"g-")
plot(datas(:,1), datas(:,4),"b-")
plot(datab(:,1), datab(:,2)/10,"r-.")
plot(datab(:,1), datab(:,3),"g-.")
plot(datab(:,1), datab(:,4),"b-.")
legend("Sustainer","Booster","Altitude (m*10^1)", "Vertical Velocity (m/2)", "Vertical Acceleration (m/s^2)", "Orientation", "Vertical")
axis([0 650  -250 1750])
title("Full Flight Profile")
xlabel("Time")
ylabel("Altitude, Velocity, and Acceleration")
set(gcf, 'Position',  [0, 0, 1000, 1000])

%{
figure(6)
clf
hold on
grid on
plot(datas(:,1), datas(:,2),"r")
plot(datas(:,1), datas(:,3),"b")
plot(datas(:,1), datas(:,4),"g")
plot(datab(:,1), datab(:,2),"r")
plot(datab(:,1), datab(:,3),"b")
plot(datab(:,1), datab(:,4),"g")
plot([000000 000000], [-10000 40000], "k") %Ignition
plot([3.5412 3.5412], [-10000 40000], "k") %Burnout
plot([5.5412 5.5412], [-10000 40000], "k") %Stage Seperation
plot([6.5412 6.5412], [-10000 40000], "k") %Ignition
plot([10.882 10.882], [-10000 40000], "k") %Burnout
plot([43.482 43.482], [-10000 40000], "k") %Apogee/Parachute
plot([524.67 524.67], [-10000 40000], "k") %Parachute
plot([17.432 17.432], [-10000 40000], "k") %Apogee/Parachute
legend("Altitude (m)", "Vertical Velocity (m/2)", "Vertical Acceleration (m/s^2)", "Orientation", "Horizontal")
axis([0 20 -250 2400])
title("Zoomed Flight Profile")
xlabel("Time")
ylabel("Altitude, Velocity, and Acceleration")
set(gcf, 'Position',  [0, 0, 1000, 1000])
%}