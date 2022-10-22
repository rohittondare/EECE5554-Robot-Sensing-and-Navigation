StationaryData = rosbag('Z:\RSN\Bagfiles_LAB3\IMUData6.bag');
StationaryData_TopicData = select(StationaryData,'Topic','/imu');

msgStructs_StationaryData = readMessages(StationaryData_TopicData,'DataFormat','struct');

Orientation_X = cellfun(@(m) double(m.IMU.Orientation.X),msgStructs_StationaryData);
Orientation_Y = cellfun(@(m) double(m.IMU.Orientation.Y),msgStructs_StationaryData);
Orientation_Z = cellfun(@(m) double(m.IMU.Orientation.Z),msgStructs_StationaryData);
Orientation_W = cellfun(@(m) double(m.IMU.Orientation.W),msgStructs_StationaryData);

AngularVelocity_X = cellfun(@(m) double(m.IMU.AngularVelocity.X),msgStructs_StationaryData);
AngularVelocity_Y = cellfun(@(m) double(m.IMU.AngularVelocity.Y),msgStructs_StationaryData);
AngularVelocity_Z = cellfun(@(m) double(m.IMU.AngularVelocity.Z),msgStructs_StationaryData);

LinearAcceleration_X = cellfun(@(m) double(m.IMU.LinearAcceleration.X),msgStructs_StationaryData);
LinearAcceleration_Y = cellfun(@(m) double(m.IMU.LinearAcceleration.Y),msgStructs_StationaryData);
LinearAcceleration_Z = cellfun(@(m) double(m.IMU.LinearAcceleration.Z),msgStructs_StationaryData);

MagneticField_X = cellfun(@(m) double(m.MagField.MagneticField_.X),msgStructs_StationaryData);
MagneticField_Y = cellfun(@(m) double(m.MagField.MagneticField_.Y),msgStructs_StationaryData);
MagneticField_Z = cellfun(@(m) double(m.MagField.MagneticField_.Z),msgStructs_StationaryData);

Time_seconds = cellfun(@(m) double(m.Header.Stamp.Sec),msgStructs_StationaryData)-1.666418679000000e+09;
Time_nseconds = cellfun(@(m) double(m.Header.Stamp.Nsec),msgStructs_StationaryData);

radEul = quat2eul([Orientation_W Orientation_X Orientation_Y Orientation_Z]);
%disp(radEul)
eul = rad2deg(radEul);
%disp(eul)

%B = fix(abs(log10(abs(Time_nseconds(1,1)))))+1; % number of digits in the int
%disp(B)
Time = Time_seconds;
for i= 1:size(Time_seconds,1)
    B = fix(abs(log10(abs(Time_nseconds(1,1)))))+1;
    Time(i,1) = Time_seconds(i,1) + (Time_nseconds(i,1)/10.^B);
end


figure
plot3(Orientation_X,Orientation_Y,Orientation_Z,'o')
grid on
title("Orientation 3D plot")
xlabel({'X Orientation','(in Degrees)'})
ylabel({'Y Orientation','(in Degrees)'})
zlabel({'Z Orientation','(in Degrees)'})
legend("data");

figure
plot3(eul(:,3),eul(:,2),eul(:,1),'o')
grid on
title("Orientation 3D plot from Euler angles")
xlabel({'X Orientation','(in Degrees)'})
ylabel({'Y Orientation','(in Degrees)'})
zlabel({'Z Orientation','(in Degrees)'})
legend("data");

figure
subplot(2,2,1)
plot(Time_seconds,Orientation_X,'r+')
grid on
title("Plot of X Orientation vs time")
xlabel({'Time','(in Seconds)'})
ylabel({'X Orientation','(in Degrees)'})
legend('x')

subplot(2,2,2)
plot(Time_seconds,Orientation_Y,'b+')
grid on
title("Plot of Y Orientation vs time")
xlabel({'Time','(in Seconds)'})
ylabel({'Y Orientation','(in Degrees)'})
legend('y');

subplot(2,2,3)
plot(Time_seconds,Orientation_Z,'g+')
grid on
title("Plot of Z Orientation vs time")
xlabel({'Time','(in Seconds)'})
ylabel({'Z Orientation','(in Degrees)'})
legend('z');

subplot(2,2,4)
plot(Time_seconds,Orientation_X,'r+')
hold on
plot(Time_seconds,Orientation_Y,'b+')
plot(Time_seconds,Orientation_Z,'g+')
hold off
grid on
title("Combined plot of XYZ Orientation with time")
xlabel({'Time','(in Seconds)'})
ylabel({'Orientation','(in Degrees)'})
legend('x','y','z');

eulMean_X = mean(eul(:,3));
eulMean_Y = mean(eul(:,2));
eulMean_Z = mean(eul(:,1));

figure
histogram(eul(:,3));
hold on
plot([eulMean_X,eulMean_X],[0,1400])
hold off
title("Histogram of X Orientation")
xlabel({'X Orientation','(in Degrees)'})
ylabel({'Frequency','(in Nos)'})
legend("Data","Mean")

figure
histogram(eul(:,2));
hold on
plot([eulMean_Y,eulMean_Y],[0,1200])
hold off
title("Histogram of Y Orientation")
xlabel({'Y Orientation','(in Degrees)'})
ylabel({'Frequency','(in Nos)'})
legend("Data","Mean")

figure
histogram(eul(:,1));
hold on
plot([eulMean_Z,eulMean_Z],[0,1200])
hold off
title("Histogram of Z Orientation")
xlabel({'Z Orientation','(in Degrees)'})
ylabel({'Frequency','(in Nos)'})
legend("Data","Mean")

figure
subplot(2,2,1)
plot(Time_seconds,eul(:,3),'r+')
grid on
title("Plot of X Orientation vs time")
xlabel({'Time','(in Seconds)'})
ylabel({'X Orientation','(in Degrees)'})
legend('x')

subplot(2,2,2)
plot(Time_seconds,eul(:,2),'b+')
grid on
title("Plot of Y Orientation vs time")
xlabel({'Time','(in Seconds)'})
ylabel({'Y Orientation','(in Degrees)'})
legend('y');

subplot(2,2,3)
plot(Time_seconds,eul(:,1),'g+')
grid on
title("Plot of Z Orientation vs time")
xlabel({'Time','(in Seconds)'})
ylabel({'Z Orientation','(in Degrees)'})
legend('z');

subplot(2,2,4)
plot(Time_seconds,eul(:,3),'r+')
hold on
plot(Time_seconds,eul(:,2),'b+')
plot(Time_seconds,eul(:,1),'g+')
hold off
grid on
title("Combined plot of XYZ Orientation with time")
xlabel({'Time','(in Seconds)'})
ylabel({'Orientation','(in Degrees)'})
legend('x','y','z');

%%

OrientationMean_X = mean(Orientation_X);
OrientationMean_Y = mean(Orientation_Y);
OrientationMean_Z = mean(Orientation_Z);

figure
histogram(Orientation_X);
hold on
plot([OrientationMean_X,OrientationMean_X],[0,800])
hold off
title("Histogram of X Orientation")
xlabel({'X Orientation','(in Degrees)'})
ylabel({'Frequency','(in Nos)'})
legend("Data","Mean")

figure
histogram(Orientation_Y);
hold on
plot([OrientationMean_Y,OrientationMean_Y],[0,800])
hold off
title("Histogram of Y Orientation")
xlabel({'Y Orientation','(in Degrees)'})
ylabel({'Frequency','(in Nos)'})
legend("Data","Mean")

figure
histogram(Orientation_Z);
hold on
plot([OrientationMean_Z,OrientationMean_Z],[0,1000])
hold off
title("Histogram of Z Orientation")
xlabel({'Z Orientation','(in Degrees)'})
ylabel({'Frequency','(in Nos)'})
legend("Data","Mean")


figure
subplot(2,2,1)
plot(Time_seconds,LinearAcceleration_X,'r+')
grid on
title("Plot of Linear Acceleration in X vs time")
xlabel({'Time','(in Seconds)'})
ylabel({'Linear Acceleration in X','(in m/s^{2})'})
legend('x')

subplot(2,2,2)
plot(Time_seconds,LinearAcceleration_Y,'b+')
grid on
title("Plot of Linear Acceleration in Y vs time")
xlabel({'Time','(in Seconds)'})
ylabel({'Linear Acceleration in Y','(in m/s^{2})'})
legend('y')

subplot(2,2,3)
plot(Time_seconds,LinearAcceleration_Z,'g+')
grid on
title("Plot of Linear Acceleration in Z vs time")
xlabel({'Time','(in Seconds)'})
ylabel({'Linear Acceleration in Z','(in m/s^{2})'})
legend('z')

subplot(2,2,4)
plot(Time_seconds,LinearAcceleration_X,'r+')
hold on
plot(Time_seconds,LinearAcceleration_Y,'b+')
plot(Time_seconds,LinearAcceleration_Z,'g+')
hold off
grid on
title("Combined plot of Linear Acceleration in XYZ with time")
xlabel({'Time','(in Seconds)'})
ylabel({'Linear Acceleration','(in m/s^{2})'})
legend('x','y','z');


LinearAccelerationMean_X = mean(LinearAcceleration_X);
LinearAccelerationMean_Y = mean(LinearAcceleration_Y);
LinearAccelerationMean_Z = mean(LinearAcceleration_Z);

figure
histogram(LinearAcceleration_X);
hold on
plot([LinearAccelerationMean_X,LinearAccelerationMean_X],[0,1400])
hold off
title("Histogram of LinearAcceleration in X")
xlabel({'Linear Acceleration in X','(in Degrees)'})
ylabel({'Frequency','(in Nos)'})
legend("Data","Mean")

figure
histogram(LinearAcceleration_Y);
hold on
plot([LinearAccelerationMean_Y,LinearAccelerationMean_Y],[0,1000])
hold off
title("Histogram of LinearAcceleration in Y")
xlabel({'Linear Acceleration in Y','(in Degrees)'})
ylabel({'Frequency','(in Nos)'})
legend("Data","Mean")

figure
histogram(LinearAcceleration_Z);
hold on
plot([LinearAccelerationMean_Z,LinearAccelerationMean_Z],[0,1000])
hold off
title("Histogram of LinearAcceleration in Z")
xlabel({'Linear Acceleration in Z','(in Degrees)'})
ylabel({'Frequency','(in Nos)'})
legend("Data","Mean")



figure
subplot(2,2,1)
plot(Time_seconds,AngularVelocity_X,'r+')
grid on
title("Plot of Angular Velocity in X vs time")
xlabel({'Time','(in Seconds)'})
ylabel({'Angular Velocity in X','(in rad/sec)'})
legend('x')

subplot(2,2,2)
plot(Time_seconds,AngularVelocity_Y,'b+')
grid on
title("Plot of Angular Velocity in Y vs time")
xlabel({'Time','(in Seconds)'})
ylabel({'Angular Velocity in Y','(in rad/sec)'})
legend('y')

subplot(2,2,3)
plot(Time_seconds,AngularVelocity_Z,'g+')
grid on
title("Plot of Angular Velocity in Z vs time")
xlabel({'Time','(in Seconds)'})
ylabel({'Angular Velocity in Z','(in rad/sec)'})
legend('z')

subplot(2,2,4)
plot(Time_seconds,AngularVelocity_X,'r+')
hold on
plot(Time_seconds,AngularVelocity_Y,'b+')
plot(Time_seconds,AngularVelocity_Z,'g+')
hold off
grid on
title("Combined plot of Angular Velocity in XYZ with time")
xlabel({'Time','(in Seconds)'})
ylabel({'Angular Velocity','(in rad/sec)'})
legend('x','y','z');


AngularVelocityMean_X = mean(AngularVelocity_X);
AngularVelocityMean_Y = mean(AngularVelocity_Y);
AngularVelocityMean_Z = mean(AngularVelocity_Z);

figure
histogram(AngularVelocity_X);
hold on
plot([AngularVelocityMean_X,AngularVelocityMean_X],[0,1000])
hold off
title("Histogram of Angular Velocity in X")
xlabel({'Angular Velocity in X','(in rad/sec)'})
ylabel({'Frequency','(in Nos)'})
legend("Data","Mean")

figure
histogram(AngularVelocity_Y);
hold on
plot([AngularVelocityMean_Y,AngularVelocityMean_Y],[0,1000])
hold off
title("Histogram of Angular Velocity in Y")
xlabel({'Angular Velocity in Y','(in rad/sec)'})
ylabel({'Frequency','(in Nos)'})
legend("Data","Mean")

figure
histogram(AngularVelocity_Z);
hold on
plot([AngularVelocityMean_Z,AngularVelocityMean_Z],[0,1000])
hold off
title("Histogram of Angular Velocity in Z")
xlabel({'Angular Velocity in Z','(in rad/sec)'})
ylabel({'Frequency','(in Nos)'})
legend("Data","Mean")



figure
subplot(2,2,1)
plot(Time_seconds,MagneticField_X,'r+')
grid on
title("Plot of Magnetic Field in X vs time")
xlabel({'Time','(in Seconds)'})
ylabel({'Magnetic Field in X','(in Gauss)'})
legend('x')

subplot(2,2,2)
plot(Time_seconds,MagneticField_Y,'b+')
grid on
title("Plot of Magnetic Field in Y vs time")
xlabel({'Time','(in Seconds)'})
ylabel({'Magnetic Field in Y','(in Gauss)'})
legend('y')

subplot(2,2,3)
plot(Time_seconds,MagneticField_Z,'g+')
grid on
title("Plot of Magnetic Field in Z vs time")
xlabel({'Time','(in Seconds)'})
ylabel({'Magnetic Field in Z','(in Gauss)'})
legend('z')

subplot(2,2,4)
plot(Time_seconds,MagneticField_X,'r+')
hold on
plot(Time_seconds,MagneticField_Y,'b+')
plot(Time_seconds,MagneticField_Z,'g+')
hold off
grid on
title("Combined plot of Magnetic Field in XYZ with time")
xlabel({'Time','(in Seconds)'})
ylabel({'Magnetic Field','(in Gauss)'})
legend('x','y','z');


MagneticFieldMean_X = mean(MagneticField_X);
MagneticFieldMean_Y = mean(MagneticField_Y);
MagneticFieldMean_Z = mean(MagneticField_Z);

figure
histogram(MagneticField_X);
hold on
plot([MagneticFieldMean_X,MagneticFieldMean_X],[0,3000])
hold off
title("Histogram of Magnetic Field in X")
xlabel({'Magnetic Field in X','(in Gauss)'})
ylabel({'Frequency','(in Nos)'})
legend("Data","Mean")

figure
histogram(MagneticField_Y);
hold on
plot([MagneticFieldMean_Y,MagneticFieldMean_Y],[0,1400])
hold off
title("Histogram of Magnetic Field in Y")
xlabel({'Magnetic Field in Y','(in Gauss)'})
ylabel({'Frequency','(in Nos)'})
legend("Data","Mean")

figure
histogram(MagneticField_Z);
hold on
plot([MagneticFieldMean_Z,MagneticFieldMean_Z],[0,1200])
hold off
title("Histogram of Magnetic Field in Z")
xlabel({'Magnetic Field in Z','(in Gauss)'})
ylabel({'Frequency','(in Nos)'})
legend("Data","Mean")

