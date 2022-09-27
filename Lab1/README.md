To run the driver please follow the steps.

Open a new Terminal in Ubuntu and type the following

    roscore

Open a new Terminal and type

    cd ~/catkin_ws
    rosrun gps_driver_pkg gps_driver.py

To check if the data is being published run the following in a new Terminal

    source ./devel/setup.bash
    rostopic echo /gps

If data is being populated terminate the process by Ctrl+C.

To check which port the USB puck has been connected run the following

    ls -lt /dev/ttyUSB*
Run the command to give permissions to the Serial Port

    sudo chmod 666 /dev/ttyUSB0

To Capture data run the follwing

    source ./devel/setup.bash
    rosbag record -O Data /gps

The Code can also be ran using roslaunch
In a new terminal type

    roslaunch driver.launch port:=”/dev/ttyUSB0”
