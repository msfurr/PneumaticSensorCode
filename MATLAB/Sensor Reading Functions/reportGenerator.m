%%

% Clear current data stores
clear

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
UserName = string(SensorData.Data.User_Name.data(1));

SensorDataTable = table(Time, Flow, P1, P2, T1, T2);

% Curve Fitting Flow vs Pressure Curve
% Flow_vs_Pressure_Quad_Fit = fit(Flow,Pressure,'poly2')

 %% Plots of Flow and Pressure vs Time

figure(1)
subplot(3,1,1)
plot(Time,Flow,'b','LineWidth',1.2)
ylabel('Flow (units)')
title('Flow over Time')

subplot(3,1,2)
plot(Time,P1,'r','LineWidth',1.2)
hold on
plot(Time,P2,'LineWidth',1.2)
ylim([-15 15])
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
import mlreportgen.dom.*
TestDate = date;
PDFTitle = strcat('Pneumatic Station Report_',date);

% Add report container (required) with PDF name
% Located in current folder (can specify new location)
rpt = Document(PDFTitle,'pdf');

% Add title to report
title = mlreportgen.dom.Text('Pneumatic Station Report');
title.Style = {FontFamily('Calibri'),FontSize('18pt'),Bold(true), ... 
    mlreportgen.dom.HAlign('center'),LineSpacing(2.5)};
append(rpt,title);

% Add the date
Date = mlreportgen.dom.Text(date);
Date.Style = {FontFamily('Calibri'),FontSize('12pt') ... 
    mlreportgen.dom.HAlign('center')};
append(rpt,Date);

% Add operator / user name
UserNameTitle = 'User Name';
User = mlreportgen.dom.Text(UserNameTitle);
User.Style = {FontFamily('Calibri'),FontSize('12pt') ... 
    mlreportgen.dom.HAlign('left'),LineSpacing(2.5),Bold(true)};
append(rpt,User);

UserNameEntry = mlreportgen.dom.Text(UserName);
UserNameEntry.Style = {FontFamily('Calibri'),FontSize('10pt') ... 
    mlreportgen.dom.HAlign('left'),LineSpacing(2),Italic(true)};
append(rpt,UserNameEntry);

% Add testing description pulled from LabVIEW prompt
SubTitle_1 = 'Testing Description';
SubTitle_1 = mlreportgen.dom.Text(SubTitle_1);
SubTitle_1.Style = {FontFamily('Calibri'),FontSize('12pt') ... 
    mlreportgen.dom.HAlign('left'),LineSpacing(2.5),Bold(true)};
append(rpt,SubTitle_1);

TestDescription = string(SensorData.Data.Test_Description.data(1));
Description = mlreportgen.dom.Text(TestDescription);
Description.Style = {FontFamily('Calibri'),FontSize('10pt') ... 
    mlreportgen.dom.HAlign('left'),LineSpacing(2),Italic(true)};
append(rpt,Description);

% Add images to report
% Image 1: Flow, Pressure, Temp
img1 = mlreportgen.dom.Image('Flow_Pressure_Temp.jpg');
img1.Style = {mlreportgen.dom.HAlign('center')};
img1.Width = '6in';
img1.Height = '4.5in';
append(rpt,img1);

% Add caption for Figure 1
CaptionMessage_1 = 'Figure 1: Plot of Pneumatic Station sensors including Flow, Pressure, and Temperature readings';
caption1 = mlreportgen.dom.Text(CaptionMessage_1);
caption1.Style = {FontFamily('Calibri'),FontSize('10pt') ... 
    mlreportgen.dom.HAlign('left'),LineSpacing(2.5)};
append(rpt,caption1);

% Image 2: Pressure vs Flow
img2 = mlreportgen.dom.Image('Pressure_vs_Flow.jpg');
img2.Style = {mlreportgen.dom.HAlign('center')};
img2.Width = '6in';
img2.Height = '4.5in';
append(rpt,img2);

% Add caption for Figure 2
CaptionMessage_2 = 'Figure 2: Plot of Pressure vs Flow readings for various RPM settings within the pneumatic system';
caption2 = mlreportgen.dom.Text(CaptionMessage_2);
caption2.Style = {FontFamily('Calibri'),FontSize('10pt') ... 
    mlreportgen.dom.HAlign('left'),LineSpacing(2.5)};
append(rpt,caption2);

% Close report
close(rpt);