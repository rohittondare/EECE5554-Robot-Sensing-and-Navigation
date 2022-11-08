CircleData = rosbag('Z:\RSN\Bagfiles_LAB4\Circle.bag');
%StationaryData = rosbag('Z:\RSN\Bagfiles_LAB4\Minitour.bag');
MovingData = rosbag('Z:\RSN\Bagfiles_LAB4\MiniTour.bag');


%%%%%%% GPS Data %%%%%%%%%
CircleDataGPS_TopicData = select(CircleData,'Topic','/gps');
msgStructs_CircleDataGPS = readMessages(CircleDataGPS_TopicData,'DataFormat','struct');

EastingOffset_Circle = 0;
NorthingOffset_Circle = 0;
Circle_X = cellfun(@(m) double(m.UTMEasting),msgStructs_CircleDataGPS)-EastingOffset_Circle;
Circle_Y = cellfun(@(m) double(m.UTMNorthing),msgStructs_CircleDataGPS)-NorthingOffset_Circle;

%%% Moving data
MovingDataGPS_TopicData = select(MovingData,'Topic','/gps');
msgStructs_MovingDataGPS = readMessages(MovingDataGPS_TopicData,'DataFormat','struct');

EastingOffset_Moving = 0;
NorthingOffset_Moving = 0;
Moving_Easting = cellfun(@(m) double(m.UTMEasting),msgStructs_MovingDataGPS)-EastingOffset_Moving;
Moving_Northing = cellfun(@(m) double(m.UTMNorthing),msgStructs_MovingDataGPS)-NorthingOffset_Moving;
GPS_Time1 = cellfun(@(m) double(m.Header.Stamp.Sec),msgStructs_MovingDataGPS);
GPS_Time = GPS_Time1-GPS_Time1(1,1);
%%%%%%% IMU Data %%%%%%%%%
CircleDataIMU_TopicData = select(CircleData,'Topic','/imu');
msgStructs_CircleDataIMU = readMessages(CircleDataIMU_TopicData,'DataFormat','struct');

Circle_Orientation_X = cellfun(@(m) double(m.IMU.Orientation.X),msgStructs_CircleDataIMU);
Circle_Orientation_Y = cellfun(@(m) double(m.IMU.Orientation.Y),msgStructs_CircleDataIMU);
Circle_Orientation_Z = cellfun(@(m) double(m.IMU.Orientation.Z),msgStructs_CircleDataIMU);
Circle_Orientation_W = cellfun(@(m) double(m.IMU.Orientation.W),msgStructs_CircleDataIMU);

Circle_AngularVelocity_X = cellfun(@(m) double(m.IMU.AngularVelocity.X),msgStructs_CircleDataIMU);
Circle_AngularVelocity_Y = cellfun(@(m) double(m.IMU.AngularVelocity.Y),msgStructs_CircleDataIMU);
Circle_AngularVelocity_Z = cellfun(@(m) double(m.IMU.AngularVelocity.Z),msgStructs_CircleDataIMU);

Circle_LinearAcceleration_X = cellfun(@(m) double(m.IMU.LinearAcceleration.X),msgStructs_CircleDataIMU);
Circle_LinearAcceleration_Y = cellfun(@(m) double(m.IMU.LinearAcceleration.Y),msgStructs_CircleDataIMU);
Circle_LinearAcceleration_Z = cellfun(@(m) double(m.IMU.LinearAcceleration.Z),msgStructs_CircleDataIMU);

Circle_MagneticField_X = cellfun(@(m) double(m.MagField.MagneticField_.X),msgStructs_CircleDataIMU);
Circle_MagneticField_Y = cellfun(@(m) double(m.MagField.MagneticField_.Y),msgStructs_CircleDataIMU);
Circle_MagneticField_Z = cellfun(@(m) double(m.MagField.MagneticField_.Z),msgStructs_CircleDataIMU);


%%% Moving Data
MovingDataIMU_TopicData = select(MovingData,'Topic','/imu');
msgStructs_MovingDataIMU = readMessages(MovingDataIMU_TopicData,'DataFormat','struct');

Moving_Orientation_X = cellfun(@(m) double(m.IMU.Orientation.X),msgStructs_MovingDataIMU);
Moving_Orientation_Y = cellfun(@(m) double(m.IMU.Orientation.Y),msgStructs_MovingDataIMU);
Moving_Orientation_Z = cellfun(@(m) double(m.IMU.Orientation.Z),msgStructs_MovingDataIMU);
Moving_Orientation_W = cellfun(@(m) double(m.IMU.Orientation.W),msgStructs_MovingDataIMU);

Moving_AngularVelocity_X = cellfun(@(m) double(m.IMU.AngularVelocity.X),msgStructs_MovingDataIMU);
Moving_AngularVelocity_Y = cellfun(@(m) double(m.IMU.AngularVelocity.Y),msgStructs_MovingDataIMU);
Moving_AngularVelocity_Z = cellfun(@(m) double(m.IMU.AngularVelocity.Z),msgStructs_MovingDataIMU);

Moving_LinearAcceleration_X = cellfun(@(m) double(m.IMU.LinearAcceleration.X),msgStructs_MovingDataIMU);
Moving_LinearAcceleration_Y = cellfun(@(m) double(m.IMU.LinearAcceleration.Y),msgStructs_MovingDataIMU);
Moving_LinearAcceleration_Z = cellfun(@(m) double(m.IMU.LinearAcceleration.Z),msgStructs_MovingDataIMU);

Moving_MagneticField_X = cellfun(@(m) double(m.MagField.MagneticField_.X),msgStructs_MovingDataIMU);
Moving_MagneticField_Y = cellfun(@(m) double(m.MagField.MagneticField_.Y),msgStructs_MovingDataIMU);
Moving_MagneticField_Z = cellfun(@(m) double(m.MagField.MagneticField_.Z),msgStructs_MovingDataIMU);


%%%%% Change time offset if time does not start from 0 !!!
TimeOffset_Circle = 1.666916213000000e+09;
Time_seconds_Circle = cellfun(@(m) double(m.Header.Stamp.Sec),msgStructs_CircleDataIMU)-TimeOffset_Circle;
Time_nseconds_Circle = cellfun(@(m) double(m.Header.Stamp.Nsec),msgStructs_CircleDataIMU);

radEul_Circle = quat2eul([Circle_Orientation_W Circle_Orientation_X Circle_Orientation_Y Circle_Orientation_Z]);
eul_Circle = rad2deg(radEul_Circle);

Time_Circle = Time_seconds_Circle;
for i= 1:size(Time_seconds_Circle,1)
    B = fix(abs(log10(abs(Time_nseconds_Circle(1,1)))))+1;
    Time_Circle(i,1) = Time_seconds_Circle(i,1) + (Time_nseconds_Circle(i,1)/10.^B);
end


%%% MOving Data

TimeOffset_Moving = 1.666916399719750e+09;
Time_seconds_Moving = cellfun(@(m) double(m.Header.Stamp.Sec),msgStructs_MovingDataIMU)-TimeOffset_Moving;
Time_nseconds_Moving = cellfun(@(m) double(m.Header.Stamp.Nsec),msgStructs_MovingDataIMU);

radEul_Moving = quat2eul([Moving_Orientation_W Moving_Orientation_X Moving_Orientation_Y Moving_Orientation_Z]);
eul_Moving = rad2deg(radEul_Moving);

Time_Moving = Time_seconds_Moving;
for i= 1:size(Time_seconds_Moving,1)
    B = fix(abs(log10(abs(Time_nseconds_Moving(1,1)))))+1;
    Time_Moving(i,1) = Time_seconds_Moving(i,1) + (Time_nseconds_Moving(i,1)/10.^B);
end

%%
%%%%%%  PLOTS !!       %%%%%%%%%
figure
plot(Circle_X,Circle_Y);

figure
plot(Moving_Easting,Moving_Northing);

%%

figure
plot(Circle_MagneticField_X(1521:4957,1),Circle_MagneticField_Y(1521:4957,1),'o')
hold on
ellipse = fit_ellipse(Circle_MagneticField_X(1521:4957,1),Circle_MagneticField_Y(1521:4957,1));
plot(ellipse.X0_in,ellipse.Y0_in,'rx');
hold off
grid on
title("Magnetometer Data Before Soft and Hard Iron Correction")
xlabel({'Magnetometer X','(in Gauss)'})
ylabel({'Magnetometer Y','(in Gauss)'})
legend('Data','Short Axis','Long Axis','Fitted ellipse','Center')
axis([-0.3 0.25 -0.25 0.25]);


%%

Rotation_matrix = [cos(-ellipse.phi) -sin(-ellipse.phi);sin(-ellipse.phi) cos(-ellipse.phi)];

Input_matrix = [Circle_MagneticField_X(1521:4957,1) Circle_MagneticField_Y(1521:4957,1)];

SoftIronCorrection = Input_matrix*Rotation_matrix;

figure 
plot(SoftIronCorrection(:,1),SoftIronCorrection(:,2),'o')
hold on
ellipse2 = fit_ellipse(SoftIronCorrection(:,1),SoftIronCorrection(:,2));
plot(ellipse2.X0_in,ellipse2.Y0_in,'x');
hold off
grid on
axis equal

sigma = ellipse2.short_axis/ellipse2.long_axis;

figure
plot(SoftIronCorrection(:,1)*sigma,SoftIronCorrection(:,2),'o');
hold on
ellipse2 = fit_ellipse(SoftIronCorrection(:,1)*sigma,SoftIronCorrection(:,2));
plot(ellipse2.X0_in,ellipse2.Y0_in,'x');
hold off
axis equal
grid on


figure
plot((SoftIronCorrection(:,1)*sigma)-ellipse2.X0_in,SoftIronCorrection(:,2)-ellipse2.Y0_in,'o');
hold on
ellipse2 = fit_ellipse((SoftIronCorrection(:,1)*sigma)-ellipse2.X0_in,(SoftIronCorrection(:,2))-ellipse2.Y0_in);
plot(ellipse2.X0_in,ellipse2.Y0_in,'rx');
hold off
axis equal
grid on
title("Magnetometer Data After Soft and Hard Iron Correction")
xlabel({'Magnetometer X','(in Gauss)'})
ylabel({'Magnetometer Y','(in Gauss)'})
legend('Data','Short Axis','Long Axis','Fitted ellipse','Center');
axis([-0.2 0.3 -0.2 0.3])

%%

figure
plot(Time_Circle,Circle_MagneticField_X)
grid on
title("Magnetometer Data vs Time")
xlabel({'Time','(in Seconds)'})
ylabel({'Magnetometer X','(in Gauss)'})
legend('Data');

%%

xmag = Circle_MagneticField_X(1521:4957,1);
ymag = Circle_MagneticField_Y(1521:4957,1);
zmag = Circle_MagneticField_Z(1521:4957,1);


Circle_pitch = atan2(Circle_LinearAcceleration_X,sqrt(Circle_LinearAcceleration_Y.^2+Circle_LinearAcceleration_Z.^2));
Circle_roll = atan2(Circle_LinearAcceleration_Y,sqrt(Circle_LinearAcceleration_X.^2+Circle_LinearAcceleration_Z.^2));

Circle_pitch = Circle_pitch(1521:4957,1);
Circle_roll = Circle_roll(1521:4957,1);

yaw = atan2((-ymag.*cos(Circle_roll)+zmag.*sin(Circle_roll)),(xmag.*cos(Circle_pitch)+ymag.*sin(Circle_pitch).*sin(Circle_roll)+zmag.*sin(Circle_pitch).*cos(Circle_roll)));

figure
plot(Time_Circle(1521:4957,1),yaw)


%% MOVING DATA CORRECTION

 Moving_MagneticField_X_HardIron = Moving_MagneticField_X-ellipse2.X0_in;
 Moving_MagneticField_Y_HardIron = Moving_MagneticField_Y-ellipse2.Y0_in;
 
 
 Moving_Input_matrix = [Moving_MagneticField_X_HardIron Moving_MagneticField_Y_HardIron];
 
 Moving_SoftIronCorrection = Moving_Input_matrix*Rotation_matrix;
 
 Moving_SoftIronCorrection(:,1) = Moving_SoftIronCorrection(:,1)*sigma;
 
 Moving_xmag = Moving_MagneticField_X;
 Moving_ymag = Moving_MagneticField_Y;
 Moving_zmag = Moving_MagneticField_Z;

Corrected_xmag = Moving_SoftIronCorrection(:,1);
Corrected_ymag = Moving_SoftIronCorrection(:,2);
Corrected_zmag = Moving_MagneticField_Z;
movingYaw2 = atan2(-Corrected_ymag,Corrected_xmag);
%%
figure
plot(Time_Moving,Moving_MagneticField_X)
hold on
plot(Time_Moving,Moving_SoftIronCorrection(:,1))
hold off
grid on
title("Magentometer Before and After correction vs Time")
xlabel({'Time','(in Seconds)'})
ylabel({'Yaw','(in Gauss)'})
legend('Magnetometer Reading Before Correction','Magnetometer Reading After Correction','Location','best');


%%
figure
Moving_yaw = drawYaw(Moving_xmag,Moving_ymag,Moving_zmag,Moving_LinearAcceleration_X,Moving_LinearAcceleration_Y,Moving_LinearAcceleration_Z,Time_Moving);
hold on
Corrected_Moving_yaw = drawYaw(Corrected_xmag,Corrected_ymag,Corrected_zmag,Moving_LinearAcceleration_X,Moving_LinearAcceleration_Y,Moving_LinearAcceleration_Z,Time_Moving);
hold off
grid on
title("Magentometer Yaw and Corrected Magnetometer Yaw vs Time")
xlabel({'Time','(in Seconds)'})
ylabel({'Yaw','(in Gauss)'})
legend('Magnetometer Yaw','Corrected Magnetometer Yaw','Location','best');

%%

yaw_angle_vel = cumtrapz(Time_Moving,Moving_AngularVelocity_Z);
 
figure
plot(Time_Moving,unwrap(yaw_angle_vel),'r')
hold on
plot(Time_Moving,unwrap(radEul_Moving(:,1)),'g')
plot(Time_Moving,unwrap(Corrected_Moving_yaw),'k')
hold off
legend('Gyro','yaw from IMU','corrected mag yaw')


%% Complementory Filter...!!!

alpha = 0.02;

angle = (unwrap(Corrected_Moving_yaw).*alpha)+(yaw_angle_vel.*(1-alpha));

figure
plot(Time_Moving,unwrap(angle),'g')
hold on
plot(Time_Moving,unwrap(yaw_angle_vel),'r')
plot(Time_Moving,unwrap(Corrected_Moving_yaw),'k')
hold off
legend('Complementery filter','gyro yaw','corrected mag data');


alpha_low = 0.02;
alpha_high = 0.0000001;

mag_lowpass = lowpass(unwrap(Corrected_Moving_yaw),5,40);
gyro_highpass = highpass(unwrap(yaw_angle_vel),0.00001,40);
% dT=1/40;
% fcut=0.1;
% Tau = 1/(2*3.142*fcut);
% alpha1 = Tau/(Tau+dT);

alpha1 = 0.78;
figure
plot(Time_Moving,mag_lowpass,'k')
hold on
plot(Time_Moving,unwrap(Corrected_Moving_yaw),'cyan')
plot(Time_Moving,gyro_highpass,'r')
%plot(Time_Moving,unwrap(angle),'g')
plot(Time_Moving,radEul_Moving(:,1),'g')
plot(Time_Moving,alpha1*mag_lowpass+(1-alpha1)*gyro_highpass,'blue');
hold off
legend('Lowpass Filter','raw mag yaw','Highpass filter','raw yaw imu','complementery filter');

%%

figure
plot(Time_Moving,unwrap(alpha1*mag_lowpass+(1-alpha1)*gyro_highpass),'g')
hold on
plot(Time_Moving,radEul_Moving(:,1))
hold off


%% PLOTS !!!

figure
plot(Moving_MagneticField_X,Moving_MagneticField_Y,'o')
grid on
title("Magentometer X-Y plot Before Soft and Hard Iron Calibrations")
xlabel({'Magnetic Field in X','(in Gauss)'})
ylabel({'Magnetic Field in Y','(in Gauss)'})
axis equal
legend('Data');

figure
plot(Corrected_xmag,Corrected_ymag,'o')
grid on
title("Magentometer X-Y plot After Soft and Hard Iron Calibrations")
xlabel({'Magnetic Field in X','(in Gauss)'})
ylabel({'Magnetic Field in Y','(in Gauss)'})
axis equal
legend('Data');

figure
plot(Time_Moving,unwrap(yaw_angle_vel),'r')
hold on
plot(Time_Moving,unwrap(Corrected_Moving_yaw),'g')
hold off
grid on
title("Magentometer Yaw and Gyroscope Yaw vs Time")
xlabel({'Time','(in Seconds)'})
ylabel({'Yaw','(in Rad)'})
legend('Gyroscope Yaw','Corrected Magnetometer Yaw')

figure
plot(Time_Moving,mag_lowpass,'k')
hold on
plot(Time_Moving,unwrap(Corrected_Moving_yaw),'cyan')
plot(Time_Moving,alpha1*mag_lowpass+(1-alpha1)*gyro_highpass,'blue');
hold off
grid on
title("LPF, HPF & CF plots vs Time")
xlabel({'Time','(in Seconds)'})
ylabel({'Yaw','(in Rad)'})
legend('Lowpass filter','Highpass filter','Complementary filter');
%%
figure
plot(Time_Moving,alpha1*mag_lowpass+(1-alpha1)*gyro_highpass,'blue')
hold on 
plot(Time_Moving,unwrap(radEul_Moving(:,1)))
hold off
grid on
title("Complementary filter Yaw and Yaw angle from IMU sensor vs Time")
xlabel({'Time','(in Seconds)'})
ylabel({'Yaw','(in Rad)'})
legend('Complementary filter','Yaw from IMU','location','best');
%%
figure
plot(Time_Moving,Corrected_Moving_yaw)
hold on
plot(Time_Moving,unwrap(Corrected_Moving_yaw))
grid on
title("Plot of Magnetic yaw before and after using unwrap function vs Time")
xlabel({'Time','(in Seconds)'})
ylabel({'Yaw','(in Rad)'})
legend('Data','Unwrapped Data','location','best');



%% Estimation of Forward velocity !!
% integrate forward acc to get forward velocity...

figure
plot(Time_Moving,Moving_LinearAcceleration_X)

IMU_forward_velocity = cumtrapz(Time_Moving,Moving_LinearAcceleration_X);
figure
plot(Time_Moving,IMU_forward_velocity)

%%
GPS_data(:,1) = Moving_Easting;
GPS_data(:,2) = Moving_Northing;
GPS_velocity = zeros(size(Moving_Easting));

for i = 1:size(GPS_data,1)-1
     distance = GPS_data(i+1,:)-GPS_data(i,:);
     GPS_velocity(i) = ((distance(1)^2 +distance(2)^2)^0.5)/((Time_Moving(i+1)-Time_Moving(i)));
end

figure
plot(GPS_Time,GPS_velocity)
%%
figure
plot(GPS_Time,GPS_velocity/10)
hold on
plot(Time_Moving,IMU_forward_velocity)
hold off
title("Plot of GPS velocity and IMU velocity vs Time before adjustment")
xlabel({'Time','(in Seconds)'})
ylabel({'Velocity','(in m/s)'})
legend('GPS Velocity','IMU Velocity','location','best');




%%
%jerk = diff(Moving_LinearAcceleration_X);

Jerk = zeros(size(Moving_LinearAcceleration_X));

for i = 1:size(Moving_LinearAcceleration_X,1)-1
     distance = Moving_LinearAcceleration_X(i+1,:)-Moving_LinearAcceleration_X(i,:);
     Jerk(i) = distance/((Time_Moving(i+1)-Time_Moving(i)));
end
figure
plot(Time_Moving,Jerk)
hold on 
plot(Time_Moving,IMU_forward_velocity)
hold off


%%

final_velocity = zeros(size(Jerk));
disp(size(Jerk))
window = 100;
for n = 1:size(Jerk)
    %disp(Jerk(n,1))
    if Jerk(n,1) < 7.8 && Jerk(n,1) > 4.4
        final_velocity(n,1) = 0;
        disp(final_velocity(n,1))
    else
        final_velocity(n,1) = IMU_forward_velocity(n,1);
    end 
        
end
figure
plot(Time_Moving,final_velocity)

%%
count = zeros(size(Jerk));
for n = 1:size(Jerk)-window
    
    for m = 1:window

        if final_velocity(n+m,1) == 0 
            count(n,1) = 81.45;
        end
    end
end
velocity2 = zeros(size(Jerk));
for n = 1:size(Jerk)-window
    if count(n,1) == 0
        for m = n:size(Jerk)-window
            velocity2(m,1) = IMU_forward_velocity(m,1)-IMU_forward_velocity(n,1);
            
        end
    else
        velocity2(n,1) = IMU_forward_velocity(n,1);
    end
end

figure
plot(Time_Moving,count)
hold on
plot(Time_Moving,Jerk)
plot(Time_Moving,velocity2)
hold off


%%
velocity3 = zeros(size(Jerk));
for n = 2:size(Jerk)
    if velocity2(n-1,1) == 0
        for m = n:size(Jerk)
            velocity3(m,1) = velocity2(m,1) - velocity2(n,1);
        end
    end
end
for n = 2:size(Jerk)
    if velocity3(n,1) < 0
        velocity3(n,1) = 0;
    end
end
figure
plot(Time_Moving,velocity3)
hold on
plot(GPS_Time,GPS_velocity./6.11)
hold off
legend('imu velocity','gps velocity')

%%
p = fittype('Poly1');

[fitresult, gof] = fit(Time_Moving,velocity3, p);

figure
plot(fitresult,Time_Moving,velocity3,'predoba')

%%
i = 0;
m = 1;
limit = size(Jerk);
while m < limit(1,1)
        if count(m,1) == 81.45
            i = i+1;
            sections(i,1) = m;
            while count(m,1) == 81.45
                m = m +1;
            end
            sections(i,2) = m-1;
        else
            m = m + 1;
        end

end

%%
limit2 = size(sections);
p = fittype('Poly1');
figure
velocity7 = size(Jerk);
for n = 1:limit2(1,1)
    start = sections(n,1);
    ending = sections(n,2);
    [fitresult, gof] = fit(Time_Moving(start:ending,1),velocity3(start:ending,1), p);

    %plot(fitresult,Time_Moving(start:ending,1),velocity3(start:ending,1),'predoba')
    hold on
    %plot(Time_Moving(start:ending,1),velocity3(start:ending,1))
    for x = start:ending
        %distance1(x,1) = GetPointDistance(fitresult.p1,fitresult.p2,start,ending,Time_Moving);
        distance1(x,1) = fitresult.p1.*(Time_Moving(x,1)) + fitresult.p2;
        %velocity7(x,1) = velocity3(x,1) - distance1;
    end
    %plot(Time_Moving,distance)

end
%%
distance2 = distance1 - distance1*10/100;
plot(Time_Moving(1:size(distance1)),distance2)
hold off
distance2(size(distance1):size(Jerk),1) = 0;
velocity7 = zeros(size(velocity3));
velocity7 = velocity3(1:size(distance2),1) - distance2;

for n = 1:size(Jerk)
    if velocity7(n,1) < 0
        velocity7(n,1) = 0;
    end
end

figure 
plot(Time_Moving(1:size(Jerk)-101),velocity7(1:size(Jerk)-101))
hold on
plot(GPS_Time,GPS_velocity./60.11)
hold off
title("Plot of GPS velocity and IMU velocity vs Time after adjustment")
xlabel({'Time','(in Seconds)'})
ylabel({'Velocity','(in m/s)'})
legend('GPS Velocity','IMU Velocity','location','best');


%% Dead Reckoning !!

IMU_displacement = cumtrapz(Time_Moving,velocity7);
figure 
plot(Time_Moving,IMU_displacement)  
figure
plot(GPS_Time,Moving_Northing)



%%

t = linspace(1, 900, 28836);

imu_acc_mv2 = Moving_LinearAcceleration_X; 

vel_car_X = velocity7;

w = Moving_AngularVelocity_Z;
value = w .* vel_car_X./50;

acc_car_Y = Moving_AngularVelocity_Y;

figure(1);
plot(t, value, 'color', 'b');
hold on 
xlabel('time series (second)'); 
title('Compare w * X dot AND acc car y');
grid on
plot(t, acc_car_Y);
legend('w * Xdot', 'acc car y');

%% 
yaw_frommag_shift = Corrected_Moving_yaw;

fwd_vel_from_GPS = GPS_velocity;
new_GPS_vel = Get_New_GPS_Vel(fwd_vel_from_GPS);

vn = [];
ve = [];

yaw_from_gyro = Moving_AngularVelocity_Z;
yaw_from_gyro_ture = Moving_AngularVelocity_Z;
yaw_from_filter = Moving_AngularVelocity_Z;
yaw_from_IMU_shift = Moving_AngularVelocity_Z;

for ii = 1:length(yaw_frommag_shift)
    angle = yaw_frommag_shift(ii);
    
    vn = [vn; vel_car_X(ii) * cos(angle)]; 
    ve = [ve; vel_car_X(ii) * sin(angle)];
end
v_head = [ve, vn];

xe = cumtrapz(t, ve);
xn = cumtrapz(t, vn);
figure(2);
plot(xe, xn);
xlabel('East'); 
ylabel('North');
title('The estimated trajectory before adjustment');
grid on

%% plotting the GPS track and estimated trajectory on the same plot
gps_data_utm(:,1) = Moving_Easting; 
gps_data_utm(:,2) = Moving_Northing; 


%%

xe = xe + gps_data_utm(1, 1);
xn = xn + gps_data_utm(1, 2);

GPS_point_A = [gps_data_utm(10, 1), gps_data_utm(10, 2)];
GPS_point_B = [gps_data_utm(40, 1), gps_data_utm(40, 2)];
slope_A = (GPS_point_B(2) - GPS_point_A(2)) / (GPS_point_B(1) - GPS_point_A(1));
degree_A = rad2deg(atan(slope_A) + pi);

estimated_pointA = [xe(4076), xn(4076)];
estimated_pointB = [xe(5748), xn(5748)];
slope_B = (estimated_pointB(2) - estimated_pointA(2)) / (estimated_pointB(1) - estimated_pointA(1));
degree_B = rad2deg(atan(slope_B) + pi);
theta = -deg2rad(degree_A - degree_B);
theta = 0.05;
R_matrix = [cos(theta), sin(theta);
            -sin(theta), cos(theta)];
new_x = R_matrix * [xe, xn]';
new_x = new_x';
        
figure(3);
plot(gps_data_utm(:, 1), gps_data_utm(:, 2), 'linewidth', 0.5);
xlabel('UTM easting'); 
ylabel('UTM northing');
title('GPS UTM trajectory and estimated trajectory w/o adjust');
grid off
hold on

plot(xe/10, xn/10);
legend('GPS trajectory', 'estimated trajectory');
hold off

new_x(:, 1) = new_x(:, 1) + (gps_data_utm(117, 1) - new_x(117, 1));
new_x(:, 2) = new_x(:, 2) + (gps_data_utm(87, 2) - new_x(87, 2));

% after adjustment
figure(4);
plot(gps_data_utm(:, 1), gps_data_utm(:, 2), 'linewidth', 0.5);
xlabel('UTM easting'); 
ylabel('UTM northing');
title('GPS UTM trajectory and adjusted estimated trajectory');
grid on
hold on
plot(new_x(:, 1), new_x(:, 2));
legend('GPS trajectory', 'adjusted trajectory');
hold off

%% 3. Estimate x_c
gps_acc = [(new_GPS_vel(1)) / t(1)];
for ii = 2:length(new_GPS_vel)-168
    a_temp = (new_GPS_vel(ii)-new_GPS_vel(ii-1)) / (t(ii)-t(ii-1));
    gps_acc = [gps_acc; a_temp];
end

w_dot = [(w(1)) / t(1)];
for ii = 2:length(w)
    w_dot_temp = (w(ii)-w(ii-1)) / (t(ii)-t(ii-1));
    w_dot = [w_dot; w_dot_temp];
end

imu_acc = Moving_LinearAcceleration_X;
zzz = w_dot + w.*w;
imu_acc_drift = mean(imu_acc(1:400, 1));
x_c = (imu_acc(:, 1)-imu_acc_drift - imu_acc_mv2 - value) ./ zzz;

figure(6)
plot(t, x_c);
grid on
xlabel('Time in Seconds'); 
ylabel('Xc');
title('Estimated Xc');
text(312,3.736,'o','color','r');
text(323,-1.3,'o','color','r');

%%
figure
plot(t(1,9994:10287),x_c(9994:10287,1))
text(313,3.736,'o','color','r');
text(321,-1.3,'o','color','r');
x_c_mean = mean(x_c(9994:10287,1));
disp(x_c_mean)
xlabel('Time in seconds')
ylabel('Xc')
title('Zoomed in Xc values')



%%
function Moving_yaw = drawYaw(Moving_xmag1,Moving_ymag1,Moving_zmag1,Moving_LinearAcceleration_X,Moving_LinearAcceleration_Y,Moving_LinearAcceleration_Z,Time_Moving)

 mag_norm = sqrt((Moving_xmag1.*Moving_xmag1)+(Moving_ymag1.*Moving_ymag1)+(Moving_zmag1.*Moving_zmag1));
 
 Moving_xmag = Moving_xmag1./mag_norm;
 Moving_ymag = Moving_ymag1./mag_norm;
 Moving_zmag = Moving_zmag1./mag_norm;

 Moving_pitch = atan2(Moving_LinearAcceleration_X,sqrt(Moving_LinearAcceleration_Y.^2+Moving_LinearAcceleration_Z.^2));
 Moving_roll = atan2(Moving_LinearAcceleration_Y,sqrt(Moving_LinearAcceleration_X.^2+Moving_LinearAcceleration_Z.^2));

 Moving_yaw = atan2((-Moving_ymag.*cos(Moving_roll)+Moving_zmag.*sin(Moving_roll)),(Moving_xmag.*cos(Moving_pitch)+Moving_ymag.*sin(Moving_pitch).*sin(Moving_roll)+Moving_zmag.*sin(Moving_pitch).*cos(Moving_roll)));
 
 plot(Time_Moving,unwrap(Moving_yaw))

end


