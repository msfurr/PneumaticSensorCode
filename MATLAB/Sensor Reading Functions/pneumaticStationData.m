%%

% Allows user to select TDMS file to convert
filename = '';
SensorData = TDMS_getStruct(filename);

%%

% Saves TDMS file data to Pressure, Flow, and Time variables
Time = transpose(SensorData.Data.ESPTime.data);
% Set time start at 0 seconds
Time = Time - Time(1);
P1 = transpose(SensorData.Data.P1.data);
P2 = transpose(SensorData.Data.P2.data);
T1 = transpose(SensorData.Data.T1.data);
T2 = transpose(SensorData.Data.T2.data);
Flow = transpose(SensorData.Data.Flow.data);

SensorDataTable = table(Time, Flow, P1, P2, T1, T2);

% Curve Fitting Flow vs Pressure Curve
% Flow_vs_Pressure_Quad_Fit = fit(Flow,Pressure,'poly2')

 %% Plots of Flow and Pressure vs Time

figure(1)
subplot(3,1,1)
plot(Time,Flow,'b','LineWidth',1.2)
xlabel('Time (seconds)')
ylabel('Flow (units)')
title('Flow over Time')

subplot(3,1,2)
plot(Time,P1,'r','LineWidth',1.2)
hold on
plot(Time,P2,'LineWidth',1.2)
ylim([-15 15])
xlabel('Time (seconds)')
ylabel('Relative Pressure (KPa)')
title('Pressure over Time')
legend('P1','P2')
hold off

subplot(3,1,3)
plot(Time,T1,'b','LineWidth',1.5)
hold on
plot(Time,T2,'m','LineWidth',1.5)
ylim([50 120])
xlabel('Time (seconds)')
ylabel('Temperature (F)')
legend('T1','T2')
title('Temperature of Pneumatic Pumps over Time')
hold off

saveas(gcf,'Flow_Pressure_Temp.jpg')

%% Plot of Pressure vs Flow

figure(2)
plot(P1,Flow,'m*')
hold on
plot(P2,Flow,'ro')
xlabel('Relative Pressure (kPa)')
ylabel('Flow')
title('Pressure vs Flow')
hold off

saveas(gcf,'Pressure_vs_Flow.jpg')

%% Report Generation

% Import report API classes (optional)
import mlreportgen.report.*

% Add report container (required)
rpt = Report('Pnuematic Station Report','pdf');

% Add content to container (required)
% Title page added here
titlepg = TitlePage;
titlepg.Title = 'RightAir Pneumatic Station';
titlepg.Author = 'Flow, Pressure, Temperature Report';
add(rpt,titlepg);

% Add images to report
img1 = mlreportgen.report.FormalImage();
img1.Image = which('Flow_Pressure_Temp.jpg');
img1.Height = '4in';
img2 = mlreportgen.report.FormalImage();
img2.Image = which('Pressure_vs_Flow.jpg');
img2.Height = '4in';
add(rpt,img1);
add(rpt,img2);

% chap = Chapter('Test Image');
% add(chap,FormalImage('Image',...
%     which('Sample.jpg'),'Height','5in',...
%     'Width','5in','Caption','Sensor Readings'));
% add(rpt,chap);

% Close the report
close(rpt);
% Display the report (optional)
rptview(rpt);

% Testing notes / parameters, user id or operator name

