%%
% <latex> \title{RightAir \\{\normalsize}
% \\{\normalsize Pnuematic Testing Station}} \author{Spring 2019} \date{} \maketitle \textbf{Objective:} </latex>

%% 
% <latex> \begin{center} \author{Flow, Pressure, and Temperature Sensor Report \\
%   \normalsize \\}
% \end{center} 
% </latex>

%%

% Allows user to select TDMS file to convert
filename = '';
my_tdms_struct = TDMS_getStruct(filename);

%%

% Saves TDMS file data to Pressure, Flow, and Time variables
Pressure = transpose(my_tdms_struct.Data.Pressure.data);
Flow = transpose(my_tdms_struct.Data.Flow.data);
Time = transpose(my_tdms_struct.Data.Time.data);
sensorDS = table(Time, Flow, Pressure);

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

figure(1)
subplot(2,1,1)
plot(t,Flow,'b','LineWidth',1.2)
xlabel('Time (seconds)')
ylabel('Flow (units)')
title('Flow over Time')

subplot(2,1,2)
plot(t,Pressure,'r','LineWidth',1.2)
xlabel('Time (seconds)')
ylabel('Pressure (KPa)')
title('Pressure over Time')

%% Plot of Pressure vs Flow

% plot(Flow)
% plot(Pressure)
% plot(Flow, Pressure)

% Pull in the description of the data from the TDMS file read
% User will specify ID, title, type of test

%% 
% <latex>
%   \end{enumerate}
% \end{enumerate}
% </latex>
