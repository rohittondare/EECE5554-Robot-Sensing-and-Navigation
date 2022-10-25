To run the driver please follow the steps.
Open a new Terminal in Ubuntu and type the following
    roscore

Open a new Terminal and type
    cd ~/catkin_ws
    rosrun imu_driver driver.py

To check if the data is being published run the following in a new Terminal
    source ./devel/setup.bash
    rostopic echo /imu

If data is being populated terminate the process by Ctrl+C.
To check which port the USB has been connected run the following
    ls -lt /dev/ttyUSB*

Run the command to give permissions to the Serial Port
    sudo chmod 666 /dev/ttyUSB*

To Capture data run the follwing
    source ./devel/setup.bash
    rosbag record -O Data /imu

The Code can also be ran using roslaunch
In a new terminal type
    roslaunch imu_driver driver.launch port:=”/dev/ttyUSB*”

Note : Replace * after ttyUSB to the port number obtained after 'ls -lt /dev/ttyUSB*' command.
