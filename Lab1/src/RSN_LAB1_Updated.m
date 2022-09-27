StationaryData = rosbag('Z:\RSN\Bagfiles\stationaryData1.bag');
StraightLineData = rosbag('Z:\RSN\Bagfiles\straightLine.bag');

StationaryData_TopicData = select(StationaryData,'Topic','/gps');
StraightLineData_TopicData = select(StraightLineData,'Topic','/gps');

msgStructs_Stationary = readMessages(StationaryData_TopicData,'DataFormat','struct');
msgStructs_StraightLine = readMessages(StraightLineData_TopicData,'DataFormat','struct');

%Stationary Data
Stationary_X = cellfun(@(m) double(m.UTMEasting),msgStructs_Stationary)-327700;
Stationary_Y = cellfun(@(m) double(m.UTMNorthing),msgStructs_Stationary)-4689200;
 
%T = struct2table(msgStructs_Stationary);

Stationary_MeanX = (mean(cellfun(@(m) double(m.UTMEasting),msgStructs_Stationary)))-327700;
Stationary_MeanY = (mean(cellfun(@(m) double(m.UTMNorthing),msgStructs_Stationary)))-4689200;

%disp(Stationary_MeanX);
%disp(Stationary_MeanY);
Time = cellfun(@(m) double(m.Header.Stamp.Sec),msgStructs_Stationary);
errorX = (cellfun(@(m) double(m.UTMEasting),msgStructs_Stationary))-Stationary_MeanX;
errorY = (cellfun(@(m) double(m.UTMNorthing),msgStructs_Stationary))-Stationary_MeanY;

%figure
%plot(errorY,Time);

figure
plot(Stationary_X,Stationary_Y)
hold on
plot(Stationary_MeanX,Stationary_MeanY,'--ro')
hold off
title('Stationary GPS Data')
xlabel({'UTMEasting','Offset = 327700'})
ylabel({'UTMNorthing','Offset = 4689200'})
legend('data','mean');
%figure
%scatter(Stationary_X,Stationary_Y);

%Stationary Altitude
Stationary_Altitude = cellfun(@(m) double(m.Altitude),msgStructs_Stationary);
Stationary_Time = cellfun(@(m) double(m.Header.Stamp.Sec),msgStructs_Stationary);
Stationary_Altitude_Mean = (mean(cellfun(@(m) double(m.Altitude),msgStructs_Stationary)));

figure
plot(Stationary_Time,Stationary_Altitude)
title('Stationary Altitude GPS Data Plot')
xlabel({'Time','(in Seconds)'})
ylabel({'Altitude','(in meters)'})
legend('Altitude Data','Mean Line','Location','best');


%Straight Line GPS Data
StraightLine_X = cellfun(@(m) double(m.UTMEasting),msgStructs_StraightLine)-327700;
StraightLine_Y = cellfun(@(m) double(m.UTMNorthing),msgStructs_StraightLine)-4689200;

StraightLineError = GetPointDistance(StraightLine_X,StraightLine_Y);
p = fittype('Poly1');

[fitresult, gof] = fit(StraightLine_X,StraightLine_Y, p);

RMSE = sqrt(mean(StraightLineError)^2);
disp(RMSE);

%disp(fitresult);
figure
plot(fitresult,StraightLine_X,StraightLine_Y,'predoba')
title('Straight Line GPS Data')
xlabel({'UTMEasting','Offset = 327700'})
ylabel({'UTMNorthing','Offset = 4689200'})

%Straight Line Altitude
Straight_Altitude = cellfun(@(m) double(m.Altitude),msgStructs_StraightLine);
Straight_Time = cellfun(@(m) double(m.Header.Stamp.Sec),msgStructs_StraightLine);
Straight_Altitude_Mean = (mean(cellfun(@(m) double(m.Altitude),msgStructs_StraightLine)));

figure
plot(Straight_Time,Straight_Altitude)
hold on
plot(Straight_Time,Straight_Altitude_Mean,'--ro','LineWidth',0.5)
hold off
title('Straight Line Altitude GPS Data Plot')
xlabel({'Time','(in Seconds)'})
ylabel({'Altitude','(in meters)'})
legend('Altitude Data','Mean Line');

figure
plot(-Straight_Time+5390,StraightLineError);
title('Straight Line Error Plot')
xlabel({'Time','(in Seconds)'})
ylabel({'Error','(in Meters)'})
legend('Spread of Residual in Straigth Line data');

function distance = GetPointDistance(x3,y3)
    x1=18.3492; y1=125.416; x2=113.852;y2=105.53;
    num = abs((x2-x1)*(y1-y3)-(x1-x3)*(y2-y1));
    den = sqrt((x2-x1)^2 + (y2-y1)^2);
    distance = num ./ den;
    return
end