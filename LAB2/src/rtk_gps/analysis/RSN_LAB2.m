StationaryDataOpen = rosbag('Z:\RSN\Bagfiles_LAB2\StationaryDataOpen.bag');
MovingDataOpen = rosbag('Z:\RSN\Bagfiles_LAB2\MovingDataOpen.bag');
StationaryDataOccluded = rosbag('Z:\RSN\Bagfiles_LAB2\StationaryDataOccluded.bag');
MovingDataOccluded = rosbag('Z:\RSN\Bagfiles_LAB2\MovingDataOccluded.bag');
StationaryDataCircle = rosbag('Z:\RSN\Bagfiles_LAB2\StationaryDataCircle.bag');
MovingDataCircle = rosbag('Z:\RSN\Bagfiles_LAB2\MovingDataCircle.bag');

StationaryDataOpen_TopicData = select(StationaryDataOpen,'Topic','/gps');
MovingDataOpen_TopicData = select(MovingDataOpen,'Topic','/gps');
StationaryDataOccluded_TopicData = select(StationaryDataOccluded,'Topic','/gps');
MovingDataOccluded_TopicData = select(MovingDataOccluded,'Topic','/gps');
StationaryDataCircle_TopicData = select(StationaryDataCircle,'Topic','/gps');
MovingDataCircle_TopicData = select(MovingDataCircle,'Topic','/gps');

msgStructs_StationaryDataOpen = readMessages(StationaryDataOpen_TopicData,'DataFormat','struct');
msgStructs_MovingDataOpen = readMessages(MovingDataOpen_TopicData,'DataFormat','struct');
msgStructs_StationaryDataOccluded = readMessages(StationaryDataOccluded_TopicData,'DataFormat','struct');
msgStructs_MovingDataOccluded = readMessages(MovingDataOccluded_TopicData,'DataFormat','struct');
msgStructs_StationaryDataCircle = readMessages(StationaryDataCircle_TopicData,'DataFormat','struct');
msgStructs_MovingDataCircle = readMessages(MovingDataCircle_TopicData,'DataFormat','struct');


%Stationary Data Open
StationaryDataOpen_X_Offset = 328116.721;
StationaryDataOpen_Y_Offset = 4689437.16;
StationaryDataOpen_X = cellfun(@(m) double(m.UtmEasting),msgStructs_StationaryDataOpen)-StationaryDataOpen_X_Offset;
StationaryDataOpen_Y = cellfun(@(m) double(m.UtmNorthing),msgStructs_StationaryDataOpen)-StationaryDataOpen_Y_Offset;
StationaryDataOpen_Quality = cellfun(@(m) double(m.PosStat),msgStructs_StationaryDataOpen);


StationaryDataOpen_X_Gearth = 328116.7234968-StationaryDataOpen_X_Offset;
StationaryDataOpen_Y_Gearth = 4689437.178829196-StationaryDataOpen_Y_Offset;

StationaryDataOpen_Xdeg = cellfun(@(m) double(m.Latitude),msgStructs_StationaryDataOpen)-0;
StationaryDataOpen_Ydeg = cellfun(@(m) double(m.Longitude),msgStructs_StationaryDataOpen)-0;

Sx = std(StationaryDataOpen_X);
Sy = std(StationaryDataOpen_Y);
%disp('std :');
%disp(Sx);
%disp(Sy);

CEP = 0.59*(Sx+Sy);
%disp(CEP);
DRMS = (sqrt(Sx^2+Sy^2))*2;


StationaryDataOpen_MeanX = (mean(cellfun(@(m) double(m.UtmEasting),msgStructs_StationaryDataOpen)))-StationaryDataOpen_X_Offset;
StationaryDataOpen_MeanY = (mean(cellfun(@(m) double(m.UtmNorthing),msgStructs_StationaryDataOpen)))-StationaryDataOpen_Y_Offset;


StationaryDataOpen_Time = cellfun(@(m) double(m.Header.Stamp.Sec),msgStructs_StationaryDataOpen);
StationaryDataOpen_Altitude = cellfun(@(m) double(m.Altitude),msgStructs_StationaryDataOpen);
StationaryDataOpen_Altitude_Mean = (mean(cellfun(@(m) double(m.Altitude),msgStructs_StationaryDataOpen)));


figure
histfit(StationaryDataOpen_Altitude,50);
title('Histogram for Stationary Altitude Data in Open Space')
xlabel({'Altitude in meters'})
ylabel({'Frequency','Nos'})
legend('data','curve');


figure
%scatter(StationaryDataOpen_X,StationaryDataOpen_Y,'x')
gscatter(StationaryDataOpen_X,StationaryDataOpen_Y,StationaryDataOpen_Quality,'br','xo')
hold on
scatter(StationaryDataOpen_MeanX,StationaryDataOpen_MeanY,'black+')
gscatter(StationaryDataOpen_X_Gearth,StationaryDataOpen_Y_Gearth)
viscircles([StationaryDataOpen_MeanX StationaryDataOpen_MeanY],CEP,"Color",'green');
viscircles([StationaryDataOpen_MeanX StationaryDataOpen_MeanY],DRMS,"Color",'cyan');
hold off
grid on
title('Stationary GPS Data in Open Space')
xlabel({'UtmEasting in meters','Offset = 328116.721'})
ylabel({'UtmNorthing in meters','Offset = 4689437.16'})
axis([0 0.2 0 0.2])
legend('Quality = 2','Quality = 4','mean','google earth true value','Location','northwest');

%StationaryDataOpen_Mean = [StationaryDataOpen_MeanX StationaryDataOpen_MeanY];
%StationaryDataOpen_Gearth = [(328116.7234968-StationaryDataOpen_X_Offset) (4689437.178829196-StationaryDataOpen_Y_Offset)];
StationaryDataOpenError = GetPointDistance(StationaryDataOpen_X_Gearth,StationaryDataOpen_Y_Gearth,StationaryDataOpen_X,StationaryDataOpen_Y);
%disp(StraightLineError);
StationaryDataOpen_RMSE = sqrt(mean(StationaryDataOpenError)^2);
disp('RMSE for Stationary Open Data');
disp(StationaryDataOpen_RMSE);



figure
%hist3([StationaryDataOpen_X+StationaryDataOpen_X_Offset,StationaryDataOpen_Y+StationaryDataOpen_Y_Offset],[35,35],'CDataMode','auto','FaceColor','interp');
hh = histogram2(StationaryDataOpen_X+StationaryDataOpen_X_Offset,StationaryDataOpen_Y+StationaryDataOpen_Y_Offset);%,[35,35],'CDataMode','auto','FaceColor','interp');
title('Histogram for Stationary UtmEasting and UtmNorthing in Open Space')
xlabel({'UtmEasting in meters'})
ylabel({'UtmNorthing in meters'});
zlabel({'Frequency','Nos'})
legend('data');

counts = hh.BinCounts;
values = hh.Values;

%[X,Y]=meshgrid(StationaryDataOpen_X+StationaryDataOpen_X_Offset,StationaryDataOpen_Y+StationaryDataOpen_Y_Offset);
%z=(1000/sqrt(2*pi).*exp(-(X.^2/2)-(Y.^2/2)));
%z = values;
%surf(X,Y,z);
%shading interp
%axis tight

figure
histfit(StationaryDataOpen_X+StationaryDataOpen_X_Offset,50);
title('Histogram for Stationary UtmEasting in Open Space')
xlabel({'UtmEasting in meters'})
ylabel({'Frequency','Nos'})
legend('data','curve');

figure
histfit(StationaryDataOpen_Y+StationaryDataOpen_Y_Offset,50);
title('Histogram for Stationary UtmNorthing in Open Space')
xlabel({'UtmNorthing in meters'})
ylabel({'Frequency','Nos'})
legend('data','curve');

wm = webmap('World Imagery');
s = geoshape(StationaryDataOpen_Xdeg,StationaryDataOpen_Ydeg);
%t = geoshape(42.3381341556141,-71.08697065232677);
hold on
wmline(s,'Color','red','Width',10);
%wmline(t,'Color','red','Width',3);
hold off










%Moving Data Open
MovingDataOpen_X_Offset = 328116.71;
MovingDataOpen_Y_Offset = 4689432.16;
MovingDataOpen_X = cellfun(@(m) double(m.UtmEasting),msgStructs_MovingDataOpen)-MovingDataOpen_X_Offset;
MovingDataOpen_Y = cellfun(@(m) double(m.UtmNorthing),msgStructs_MovingDataOpen)-MovingDataOpen_Y_Offset;
MovingDataOpen_Quality = cellfun(@(m) double(m.PosStat),msgStructs_MovingDataOpen);


MovingDataOpen_X_Gearth = 328116.7234968-MovingDataOpen_X_Offset;
MovingDataOpen_Y_Gearth = 4689437.178829196-MovingDataOpen_Y_Offset;

MovingDataOpen_Xdeg = cellfun(@(m) double(m.Latitude),msgStructs_MovingDataOpen)-0;
MovingDataOpen_Ydeg = cellfun(@(m) double(m.Longitude),msgStructs_MovingDataOpen)-0;


MovingDataOpen_MeanX = (mean(cellfun(@(m) double(m.UtmEasting),msgStructs_MovingDataOpen)))-MovingDataOpen_X_Offset;
MovingDataOpen_MeanY = (mean(cellfun(@(m) double(m.UtmNorthing),msgStructs_MovingDataOpen)))-MovingDataOpen_Y_Offset;

MovingDataOpen_Time = cellfun(@(m) double(m.Header.Stamp.Sec),msgStructs_StationaryDataOpen);
MovingDataOpen_Altitude = cellfun(@(m) double(m.Altitude),msgStructs_MovingDataOpen);
MovingDataOpen_Altitude_Mean = (mean(cellfun(@(m) double(m.Altitude),msgStructs_MovingDataOpen)));


figure
histfit(MovingDataOpen_Altitude,50);
title('Histogram for Moving Altitude Data in Open Space')
xlabel({'Altitude in meters'})
ylabel({'Frequency','Nos'})
legend('data','curve');


figure
gscatter(MovingDataOpen_X,MovingDataOpen_Y,MovingDataOpen_Quality,'br','oo')

%hold on
%plot(MovingDataOpen_X(41:48),MovingDataOpen_Y(41:48),'o')
%plot(MovingDataOpen_X(49:86),MovingDataOpen_Y(49:86),'o')
%plot(MovingDataOpen_X(87:95),MovingDataOpen_Y(87:95),'o')
%plot(MovingDataOpen_X(96:103),MovingDataOpen_Y(96:103),'o')
%plot(MovingDataOpen_MeanX,MovingDataOpen_MeanY,'x')
%hold off
grid on
title('Moving GPS Data in Open Space')
xlabel({'UtmEasting in meters','Offset = 328116.71'})
ylabel({'UtmNorthing in meters','Offset = 4689432.16'})
legend('Quality = 2','Quality = 5','Location','northwest');


p = fittype('Poly1');

[fitresult1, gof1] = fit(MovingDataOpen_X(1:40),MovingDataOpen_Y(1:40), p);
[fitresult2, gof2] = fit(MovingDataOpen_X(41:48),MovingDataOpen_Y(41:48), p);
[fitresult3, gof3] = fit(MovingDataOpen_X(49:86),MovingDataOpen_Y(49:86), p);
[fitresult4, gof4] = fit(MovingDataOpen_X(87:95),MovingDataOpen_Y(87:95), p);
[fitresult5, gof5] = fit(MovingDataOpen_X(96:103),MovingDataOpen_Y(96:103), p);
figure
plot(fitresult1,MovingDataOpen_X(1:40),MovingDataOpen_Y(1:40),'predoba')
hold on
plot(fitresult2,MovingDataOpen_X(41:48),MovingDataOpen_Y(41:48),'predoba')
plot(fitresult3,MovingDataOpen_X(49:86),MovingDataOpen_Y(49:86),'predoba')
plot(fitresult4,MovingDataOpen_X(87:95),MovingDataOpen_Y(87:95),'predoba')
plot(fitresult5,MovingDataOpen_X(96:103),MovingDataOpen_Y(96:103),'predoba')
hold off
title('Best fit plot for Moving Data in Open Space')
xlabel({'UtmEasting in meters','Offset = 328116.71'})
ylabel({'UtmNorthing in meters','Offset = 4689432.16'})
legend('Data','Best Fit','Prediction Bounds','Location','northwest');

MovingDataOpen_RMSE = (gof1.rmse + gof2.rmse + gof3.rmse + gof4.rmse + gof5.rmse)/5;
disp('RMSE for Moving Open Data');
disp(MovingDataOpen_RMSE);

wm2 = webmap('World Imagery');
s = geoshape(MovingDataOpen_Xdeg,MovingDataOpen_Ydeg);
%t = geoshape(42.3381341556141,-71.08697065232677);
hold on
wmline(s,'Color','red','Width',3);
%wmline(t,'Color','red','Width',3);
hold off












%Stationary Data Occluded
StationaryDataOccluded_X_Offset = 327985.221;
StationaryDataOccluded_Y_Offset = 4689511.66;
StationaryDataOccluded_X = cellfun(@(m) double(m.UtmEasting),msgStructs_StationaryDataOccluded)-StationaryDataOccluded_X_Offset;
StationaryDataOccluded_Y = cellfun(@(m) double(m.UtmNorthing),msgStructs_StationaryDataOccluded)-StationaryDataOccluded_Y_Offset;
StationaryDataOccluded_Quality = cellfun(@(m) double(m.PosStat),msgStructs_StationaryDataOccluded);


StationaryDataOccluded_X_Gearth = 327987.28-StationaryDataOccluded_X_Offset;
StationaryDataOccluded_Y_Gearth = 4689513.58-StationaryDataOccluded_Y_Offset;

StationaryDataOccluded_Xdeg = cellfun(@(m) double(m.Latitude),msgStructs_StationaryDataOccluded)-0;
StationaryDataOccluded_Ydeg = cellfun(@(m) double(m.Longitude),msgStructs_StationaryDataOccluded)-0;

StationaryDataOccluded_Sx = std(StationaryDataOccluded_X);
StationaryDataOccluded_Sy = std(StationaryDataOccluded_Y);
disp('std :');
disp(StationaryDataOccluded_Sx);
disp(StationaryDataOccluded_Sy);

StationaryDataOccluded_CEP = 0.59*(StationaryDataOccluded_Sx+StationaryDataOccluded_Sy);
disp(StationaryDataOccluded_CEP);
StationaryDataOccluded_DRMS = (sqrt(StationaryDataOccluded_Sx^2+StationaryDataOccluded_Sy^2))*2;


StationaryDataOccluded_MeanX = (mean(cellfun(@(m) double(m.UtmEasting),msgStructs_StationaryDataOccluded)))-StationaryDataOccluded_X_Offset;
StationaryDataOccluded_MeanY = (mean(cellfun(@(m) double(m.UtmNorthing),msgStructs_StationaryDataOccluded)))-StationaryDataOccluded_Y_Offset;


StationaryDataOccluded_Time = cellfun(@(m) double(m.Header.Stamp.Sec),msgStructs_StationaryDataOccluded);
StationaryDataOccluded_Altitude = cellfun(@(m) double(m.Altitude),msgStructs_StationaryDataOccluded);
StationaryDataOccluded_Altitude_Mean = (mean(cellfun(@(m) double(m.Altitude),msgStructs_StationaryDataOccluded)));


figure
histfit(StationaryDataOccluded_Altitude,50);
title('Histogram for Stationary Altitude Data in Occluded Space')
xlabel({'Altitude in meters'})
ylabel({'Frequency','Nos'})
legend('data','curve');


figure
%scatter(StationaryDataOccluded_X,StationaryDataOccluded_Y,'x')
gscatter(StationaryDataOccluded_X,StationaryDataOccluded_Y,StationaryDataOccluded_Quality,'grk','*ox')
hold on
scatter(StationaryDataOccluded_MeanX,StationaryDataOccluded_MeanY,'cyan+')
gscatter(StationaryDataOccluded_X_Gearth,StationaryDataOccluded_Y_Gearth)
viscircles([StationaryDataOccluded_MeanX StationaryDataOccluded_MeanY],StationaryDataOccluded_CEP,"Color",'green');
viscircles([StationaryDataOccluded_MeanX StationaryDataOccluded_MeanY],StationaryDataOccluded_DRMS,"Color",'cyan');
hold off
grid on
title('Stationary GPS Data in Occluded Space')
xlabel({'UtmEasting in meters','Offset = 327985.221'})
ylabel({'UtmNorthing in meters','Offset = 4689511.66'})
axis([0 4.5 0 4.5])
legend('Quality = 2','Quality = 4','Quality = 5','mean','google earth true value','Location','northeast');

%StationaryDataOccluded_Mean = [StationaryDataOccluded_MeanX StationaryDataOccluded_MeanY];
%StationaryDataOccluded_Gearth = [(328116.7234968-StationaryDataOccluded_X_Offset) (4689437.178829196-StationaryDataOccluded_Y_Offset)];
StationaryDataOccludedError = GetPointDistance(StationaryDataOccluded_X_Gearth,StationaryDataOccluded_Y_Gearth,StationaryDataOccluded_X,StationaryDataOccluded_Y);
%disp(StraightLineError);
StationaryDataOccluded_RMSE = sqrt(mean(StationaryDataOccludedError)^2);
disp('RMSE for Stationary Occluded Data');
disp(StationaryDataOccluded_RMSE);



figure
%hist3([StationaryDataOccluded_X+StationaryDataOccluded_X_Offset,StationaryDataOccluded_Y+StationaryDataOccluded_Y_Offset],[35,35],'CDataMode','auto','FaceColor','interp');
hh = histogram2(StationaryDataOccluded_X+StationaryDataOccluded_X_Offset,StationaryDataOccluded_Y+StationaryDataOccluded_Y_Offset);%,[35,35],'CDataMode','auto','FaceColor','interp');
title('Histogram for Stationary UtmEasting and UtmNorthing in Occluded Space')
xlabel({'UtmEasting in meters'})
ylabel({'UtmNorthing in meters'});
zlabel({'Frequency','Nos'})
legend('data');


figure
histfit(StationaryDataOccluded_X+StationaryDataOccluded_X_Offset,50);
title('Histogram for Stationary UtmEasting in Occluded Space')
xlabel({'UtmEasting in meters'})
ylabel({'Frequency','Nos'})
legend('data','curve');

figure
histfit(StationaryDataOccluded_Y+StationaryDataOccluded_Y_Offset,50);
title('Histogram for Stationary UtmNorthing in Occluded Space')
xlabel({'UtmNorthing in meters'})
ylabel({'Frequency','Nos'})
legend('data','curve');

wm3 = webmap('World Imagery');
s = geoshape(StationaryDataOccluded_Xdeg,StationaryDataOccluded_Ydeg);
%t = geoshape(42.3381341556141,-71.08697065232677);
hold on
wmline(s,'Color','red','Width',10);
%wmline(t,'Color','red','Width',3);
hold off
















%Moving Data Occluded
MovingDataOccluded_X_Offset = 327974.71;
MovingDataOccluded_Y_Offset = 4689512.16;
MovingDataOccluded_X = cellfun(@(m) double(m.UtmEasting),msgStructs_MovingDataOccluded)-MovingDataOccluded_X_Offset;
MovingDataOccluded_Y = cellfun(@(m) double(m.UtmNorthing),msgStructs_MovingDataOccluded)-MovingDataOccluded_Y_Offset;
MovingDataOccluded_Quality = cellfun(@(m) double(m.PosStat),msgStructs_MovingDataOccluded);


MovingDataOccluded_X_Gearth = 328116.7234968-MovingDataOccluded_X_Offset;
MovingDataOccluded_Y_Gearth = 4689437.178829196-MovingDataOccluded_Y_Offset;

MovingDataOccluded_Xdeg = cellfun(@(m) double(m.Latitude),msgStructs_MovingDataOccluded)-0;
MovingDataOccluded_Ydeg = cellfun(@(m) double(m.Longitude),msgStructs_MovingDataOccluded)-0;


MovingDataOccluded_MeanX = (mean(cellfun(@(m) double(m.UtmEasting),msgStructs_MovingDataOccluded)))-MovingDataOccluded_X_Offset;
MovingDataOccluded_MeanY = (mean(cellfun(@(m) double(m.UtmNorthing),msgStructs_MovingDataOccluded)))-MovingDataOccluded_Y_Offset;

MovingDataOccluded_Time = cellfun(@(m) double(m.Header.Stamp.Sec),msgStructs_StationaryDataOccluded);
MovingDataOccluded_Altitude = cellfun(@(m) double(m.Altitude),msgStructs_MovingDataOccluded);
MovingDataOccluded_Altitude_Mean = (mean(cellfun(@(m) double(m.Altitude),msgStructs_MovingDataOccluded)));


figure
histfit(MovingDataOccluded_Altitude,50);
title('Histogram for Moving Altitude Data in Occluded Space')
xlabel({'Altitude in meters'})
ylabel({'Frequency','Nos'})
legend('data','curve');


figure
gscatter(MovingDataOccluded_X,MovingDataOccluded_Y,MovingDataOccluded_Quality,'br','oo')
%plot(MovingDataOccluded_X(1:20),MovingDataOccluded_Y(1:20),'o')
%hold on
%plot(MovingDataOccluded_X(21:30),MovingDataOccluded_Y(21:30),'o')
%plot(MovingDataOccluded_X(31:51),MovingDataOccluded_Y(31:51),'o')
%plot(MovingDataOccluded_X(52:62),MovingDataOccluded_Y(52:62),'o')
%plot(MovingDataOccluded_X(63:65),MovingDataOccluded_Y(63:65),'o')

hold off
grid on
title('Moving GPS Data in Occluded Space')
xlabel({'UtmEasting in meters','Offset = 327974.71'})
ylabel({'UtmNorthing in meters','Offset = 4689512.16'})
axis([0 18 0 18])
legend('Quality = 5','Location','northeast');
%fitresult

p = fittype('Poly1');

[Occluded_fitresult1, Occluded_gof1] = fit(MovingDataOccluded_X(1:20),MovingDataOccluded_Y(1:20), p);
[Occluded_fitresult2, Occluded_gof2] = fit(MovingDataOccluded_X(21:30),MovingDataOccluded_Y(21:30), p);
[Occluded_fitresult3, Occluded_gof3] = fit(MovingDataOccluded_X(31:51),MovingDataOccluded_Y(31:51), p);
[Occluded_fitresult4, Occluded_gof4] = fit(MovingDataOccluded_X(52:62),MovingDataOccluded_Y(52:62), p);
[Occluded_fitresult5, Occluded_gof5] = fit(MovingDataOccluded_X(63:65),MovingDataOccluded_Y(63:65), p);
figure
plot(Occluded_fitresult1,MovingDataOccluded_X(1:20),MovingDataOccluded_Y(1:20),'predoba')
hold on
plot(Occluded_fitresult2,MovingDataOccluded_X(21:30),MovingDataOccluded_Y(21:30),'predoba')
plot(Occluded_fitresult3,MovingDataOccluded_X(31:51),MovingDataOccluded_Y(31:51),'predoba')
plot(Occluded_fitresult4,MovingDataOccluded_X(52:62),MovingDataOccluded_Y(52:62),'predoba')
plot(Occluded_fitresult5,MovingDataOccluded_X(63:65),MovingDataOccluded_Y(63:65),'predoba')
hold off
title('Best fit plot for Moving Data in Occluded Space')
xlabel({'UtmEasting in meters','Offset = 327974.71'})
ylabel({'UtmNorthing in meters','Offset = 4689512.16'})
grid on
axis([0 18 0 18])
legend('Data','Best Fit','Prediction Bounds','Location','northeast');

MovingDataOccluded_RMSE = (Occluded_gof1.rmse + Occluded_gof2.rmse + Occluded_gof3.rmse + Occluded_gof4.rmse + Occluded_gof5.rmse)/5;
disp('RMSE for Moving Occluded Data');
disp(MovingDataOccluded_RMSE);

wm4 = webmap('World Imagery');
s = geoshape(MovingDataOccluded_Xdeg,MovingDataOccluded_Ydeg);
%t = geoshape(42.3381341556141,-71.08697065232677);
hold on
wmline(s,'Color','red','Width',3);
%wmline(t,'Color','red','Width',3);
hold off










function distance = GetPointDistance(x1,y1,x2,y2)
    %x1=18.3492; y1=125.416; x2=113.852;y2=105.53;
    distance = sqrt((x2-x1).^2 + (y2-y1).^2);
    return
end