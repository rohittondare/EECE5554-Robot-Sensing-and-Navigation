#!/usr/bin/env python
# -*- coding: utf-8 -*-

import rospy
import serial
import utm
import sys
from std_msgs.msg import String
from std_msgs.msg import Header
from rtk_gps.msg import gps_msg


def gpggaLatLong_to_Degrees(location):
    degree = int(location/100)
    degree = degree+(location/100-degree)*10/6
    return degree

def gpggaTime_To_SecNanosec(satTime):
    hours = int(satTime/10000)
    mins = int((satTime-hours*10000)/100)
    seconds = int(satTime-hours*10000-mins*100)
    nanoseconds = float((satTime-int(satTime))*10**9)
    totalSeconds = int(hours*3600+mins*60+seconds)
    print("hours:",hours," mins",mins," seconds",seconds," total",totalSeconds," nano",nanoseconds)
    return(nanoseconds,totalSeconds)
    

if __name__ == '__main__':
    SENSOR_NAME = "gpsPuck"
    rospy.init_node('gps')
    print(sys.argv[1])
    serial_port = sys.argv[1]
    serial_baud = rospy.get_param('~baudrate',4800)
    sampling_rate = rospy.get_param('~sampling_rate',5.0)
    latitude_deg = rospy.get_param('~latitude',41.526) 
    
    port = serial.Serial(serial_port, serial_baud, timeout=3.)
    #port = serial.Serial('/dev/pts/3', 4800, timeout=1.0)
    
    rospy.logdebug("Start of Main")
    print("Start of Main..")
    

    gpsData = rospy.Publisher('/gps', gps_msg, queue_size=10)
    print('12')
    try:
        while not rospy.is_shutdown():
            print('0')
            line = port.readline()
            print('1')

            if line == '':
                rospy.logwarn("No data from GPS Puck.")
                print("No data from puck")
            else:
                #print(line)
                if line.startswith(b"\r$GNGGA") or line.startswith(b"$GNGGA"):
                    print('123')
                    #line = line.decode('utf-8')
                    
                    line=line.decode()
                    print('1234')
                    gpgga = line.split(",")		#splits the string to a list
                    print(gpgga)
                    satTime = float(gpgga[1])
                    nanoseconds, seconds = gpggaTime_To_SecNanosec(satTime)
                    if gpgga[3] == 'N':
                    	northSouth = 1
                    else:
                    	northSouth = -1
                    if gpgga[5] == 'E':
                    	eastWest = 1
                    else:
                    	eastWest = -1
                    lat = float(gpgga[2])
                    lon = float(gpgga[4])
                    altitude = float(gpgga[9])
                    quality = int(gpgga[6])
                    latitude = gpggaLatLong_to_Degrees(lat)
                    longitude = gpggaLatLong_to_Degrees(lon)
                    UTM = utm.from_latlon(northSouth*latitude, eastWest*longitude)
                    print(lat)
                    print(lon)
                    print("herhe")
                    #UTM = utm.from_latlon(lat,lon)	
                    print("qwqwewewwe")
                    utmMsessages = gps_msg()
                    utmMsessages.header.stamp.secs = seconds
                    utmMsessages.header.stamp.nsecs = nanoseconds
                    utmMsessages.header.frame_id = 'GPS1_Frame'
                    utmMsessages.latitude = northSouth*latitude
                    utmMsessages.longitude = eastWest*longitude
                    utmMsessages.altitude = altitude
                    utmMsessages.UTM_easting = (UTM[0])
                    utmMsessages.UTM_northing = (UTM[1])
                    utmMsessages.Zone = UTM[2]
                    utmMsessages.Letter = UTM[3]
                    utmMsessages.Quality = quality
                    
                    #print(utmMsessages.header.stamp.secs)
                    #print("xxx")
                    #print(utmMsessages.header.stamp.nsecs)
                    gpsData.publish(utmMsessages)

    except rospy.ROSInterruptException:
        port.close()

    except serial.serialutil.SerialException:
        rospy.loginfo("Shutting down gps node...")
