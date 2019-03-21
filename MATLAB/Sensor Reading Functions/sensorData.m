%%

% Allows user to select TDMS file to convert
filename = '';
SensorData = TDMS_getStruct(filename);

%%

% Saves TDMS file data to Pressure, Flow, and Time variables
Time = transpose(SensorData.Untitled.Time.data);
% Set time start at 0 seconds
Time = Time - Time(1);
P1 = transpose(SensorData.Untitled.P1.data);
P2 = transpose(SensorData.Untitled.P2.data);
T1 = transpose(SensorData.Untitled.T1.data);
T2 = transpose(SensorData.Untitled.T2.data);
Flow = transpose(SensorData.Untitled.Flow.data);

SensorDataTable = table(Time, Flow, P1, P2, T1, T2);

% Curve Fitting Flow vs Pressure Curve
% Flow_vs_Pressure_Quad_Fit = fit(Flow,Pressure,'poly2')

%% Convert Time to Double

 for i = 1:length(Time)

     t(i,1) =  str2num(Time{i}(1:2))*60*60+str2num(Time{i}(4:5))*60+str2num(Time{i}(7:8));

     t(i,1) = t(i,1) + str2num(Time{i}(10:13))*1e-4;

 end

 start = t(1);

 for i = 1:length(t)

     t(i) = t(i) - start;

 end

 %% Plots of Flow and Pressure vs Time

% figure(1)
% subplot(2,1,1)
% plot(t,Flow,'b','LineWidth',1.2)
% xlabel('Time (seconds)')
% ylabel('Flow (units)')
% title('Flow over Time')
% 
% subplot(2,1,2)
% plot(t,Pressure,'r','LineWidth',1.2)
% xlabel('Time (seconds)')
% ylabel('Pressure (KPa)')
% title('Pressure over Time')

%% Plot of Pressure vs Flow

% plot(Flow)
% plot(Pressure)
% plot(Flow, Pressure)

% Pull in the description of the data from the TDMS file read
% User will specify ID, title, type of test
