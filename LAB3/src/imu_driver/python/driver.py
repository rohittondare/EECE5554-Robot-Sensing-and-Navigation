#!/usr/bin/env python
# -*- coding: utf-8 -*-

import rospy
import serial
import sys
import numpy as np
from std_msgs.msg import String
from std_msgs.msg import Header
from imu_driver.msg import imu_msg
    

def euler_to_quaternion(yaw, pitch, roll):
    qx = np.sin(roll/2) * np.cos(pitch/2) * np.cos(yaw/2) - np.cos(roll/2) * np.sin(pitch/2) * np.sin(yaw/2)
    qy = np.cos(roll/2) * np.sin(pitch/2) * np.cos(yaw/2) + np.sin(roll/2) * np.cos(pitch/2) * np.sin(yaw/2)
    qz = np.cos(roll/2) * np.cos(pitch/2) * np.sin(yaw/2) - np.sin(roll/2) * np.sin(pitch/2) * np.cos(yaw/2)
    qw = np.cos(roll/2) * np.cos(pitch/2) * np.cos(yaw/2) + np.sin(roll/2) * np.sin(pitch/2) * np.sin(yaw/2)
    return [qx,qy,qz,qw]

if __name__ == '__main__':
    SENSOR_NAME = "imuData"
    rospy.init_node('imu')
    print(sys.argv[1])
    serial_port = sys.argv[1]
    serial_baud = rospy.get_param('~baudrate',115200)
    sampling_rate = rospy.get_param('~sampling_rate',5.0)
    n=0
    port = serial.Serial(serial_port, serial_baud, timeout=3.)
    port.write(b'$VNWRG,07,40*XX\r')
    #port = serial.Serial('/dev/pts/3', 4800, timeout=1.0)
    
    rospy.logdebug("Start of Main")
    print("Start of Main..")
    

    imuData = rospy.Publisher('/imu', imu_msg, queue_size=15)
    print('12')
    try:
        while not rospy.is_shutdown():
            print('0')
            line = port.readline()
            print(line)
            print('1dd')

            if line == '':
                rospy.logwarn("No data from IMU.")
                print("No data from IMU.")
            else:
                print(line)
                if line.startswith(b"\r$VNYMR") or line.startswith(b"$VNYMR"):
                    print('123')
                    line = line.decode('utf-8')
                    #line=line.decode()
                    
                    vnymr = line.split(",")		#splits the string to a list
                    print(vnymr)
                    yaw, pitch, roll, magX, magY, magZ, accX, accY, accZ, angRateX, angRateY, tempAngRateZ = float(vnymr[1]), float(vnymr[2]), float(vnymr[3]), float(vnymr[4]), float(vnymr[5]), float(vnymr[6]), float(vnymr[7]), float(vnymr[8]), float(vnymr[9]), float(vnymr[10]), float(vnymr[11]), vnymr[12] 
                    split_angRateZ = tempAngRateZ.split('*')
                    angRateZ = float(split_angRateZ[0])
                    print('angRateZ')
                    print(angRateZ)
                    (qx,qy,qz,qw) = euler_to_quaternion(np.radians(yaw),np.radians(pitch),np.radians(roll))
                    print(qx)
                    print(qy)
                    print(qz)
                    print(qw)
                    now = rospy.get_time()
                    seconds = int(now)
                    nanosecs = int((now-seconds)*10000000)
                    #print(now.nsecs)
                    n+=1
                    imuMessages = imu_msg()
                    
                    ##### Header Data Publish
                    imuMessages.Header.seq = n
                    imuMessages.Header.stamp.secs = int(seconds) #get system time with nano sec
                    imuMessages.Header.stamp.nsecs = int(nanosecs)
                    imuMessages.Header.frame_id = 'IMU1_Frame'
                    
                    ##### Orientation Data Publish
                    imuMessages.IMU.orientation.x = qx
                    imuMessages.IMU.orientation.y = qy
                    imuMessages.IMU.orientation.z = qz
                    imuMessages.IMU.orientation.w = qw                    
                    
                    
                    ##### Acceleration
                    imuMessages.IMU.linear_acceleration.x = accX
                    imuMessages.IMU.linear_acceleration.y = accY
                    imuMessages.IMU.linear_acceleration.z = accZ
                    
                    ##### Angular Velocity
                    imuMessages.IMU.angular_velocity.x = angRateX
                    imuMessages.IMU.angular_velocity.y = angRateY
                    imuMessages.IMU.angular_velocity.z = angRateZ
                    
                    
                    ##### Magnetic Field
                    imuMessages.MagField.magnetic_field.x = magX
                    imuMessages.MagField.magnetic_field.y = magY
                    imuMessages.MagField.magnetic_field.z = magZ
                    
                    #rospy.loginfo(imuMessages)
                    imuData.publish(imuMessages)

    except rospy.ROSInterruptException:
        port.close()

    except serial.serialutil.SerialException:
        rospy.loginfo("Shutting down gps node...")

