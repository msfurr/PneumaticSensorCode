%% Sample Report Generation

% Import report API classes (optional)
import mlreportgen.report.*

% Add report container (required)
rpt = Report('Pnuematic Station Report','pdf');

% Add content to container (required)
% Types of content added here: title 
% page and table of contents reporters
titlepg = TitlePage;
titlepg.Title = 'RightAir Pneumatic Station';
titlepg.Author = 'Flow, Pressure, Temperature Report';
add(rpt,titlepg);

img1 = FormalImage(which('Sample.jpg'));
img2 = FormalImage(which('Sample2.jpg'));
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