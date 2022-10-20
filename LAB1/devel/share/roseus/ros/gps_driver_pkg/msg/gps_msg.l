;; Auto-generated. Do not edit!


(when (boundp 'gps_driver_pkg::gps_msg)
  (if (not (find-package "GPS_DRIVER_PKG"))
    (make-package "GPS_DRIVER_PKG"))
  (shadow 'gps_msg (find-package "GPS_DRIVER_PKG")))
(unless (find-package "GPS_DRIVER_PKG::GPS_MSG")
  (make-package "GPS_DRIVER_PKG::GPS_MSG"))

(in-package "ROS")
;;//! \htmlinclude gps_msg.msg.html
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass gps_driver_pkg::gps_msg
  :super ros::object
  :slots (_header _latitude _longitude _altitude _UTM_easting _UTM_northing _Zone _Letter ))

(defmethod gps_driver_pkg::gps_msg
  (:init
   (&key
    ((:header __header) (instance std_msgs::Header :init))
    ((:latitude __latitude) 0.0)
    ((:longitude __longitude) 0.0)
    ((:altitude __altitude) 0.0)
    ((:UTM_easting __UTM_easting) 0.0)
    ((:UTM_northing __UTM_northing) 0.0)
    ((:Zone __Zone) 0.0)
    ((:Letter __Letter) "")
    )
   (send-super :init)
   (setq _header __header)
   (setq _latitude (float __latitude))
   (setq _longitude (float __longitude))
   (setq _altitude (float __altitude))
   (setq _UTM_easting (float __UTM_easting))
   (setq _UTM_northing (float __UTM_northing))
   (setq _Zone (float __Zone))
   (setq _Letter (string __Letter))
   self)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:latitude
   (&optional __latitude)
   (if __latitude (setq _latitude __latitude)) _latitude)
  (:longitude
   (&optional __longitude)
   (if __longitude (setq _longitude __longitude)) _longitude)
  (:altitude
   (&optional __altitude)
   (if __altitude (setq _altitude __altitude)) _altitude)
  (:UTM_easting
   (&optional __UTM_easting)
   (if __UTM_easting (setq _UTM_easting __UTM_easting)) _UTM_easting)
  (:UTM_northing
   (&optional __UTM_northing)
   (if __UTM_northing (setq _UTM_northing __UTM_northing)) _UTM_northing)
  (:Zone
   (&optional __Zone)
   (if __Zone (setq _Zone __Zone)) _Zone)
  (:Letter
   (&optional __Letter)
   (if __Letter (setq _Letter __Letter)) _Letter)
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ;; float64 _latitude
    8
    ;; float64 _longitude
    8
    ;; float64 _altitude
    8
    ;; float64 _UTM_easting
    8
    ;; float64 _UTM_northing
    8
    ;; float64 _Zone
    8
    ;; string _Letter
    4 (length _Letter)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;; float64 _latitude
       (sys::poke _latitude (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; float64 _longitude
       (sys::poke _longitude (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; float64 _altitude
       (sys::poke _altitude (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; float64 _UTM_easting
       (sys::poke _UTM_easting (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; float64 _UTM_northing
       (sys::poke _UTM_northing (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; float64 _Zone
       (sys::poke _Zone (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; string _Letter
       (write-long (length _Letter) s) (princ _Letter s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; std_msgs/Header _header
     (send _header :deserialize buf ptr-) (incf ptr- (send _header :serialization-length))
   ;; float64 _latitude
     (setq _latitude (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; float64 _longitude
     (setq _longitude (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; float64 _altitude
     (setq _altitude (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; float64 _UTM_easting
     (setq _UTM_easting (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; float64 _UTM_northing
     (setq _UTM_northing (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; float64 _Zone
     (setq _Zone (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; string _Letter
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _Letter (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;;
   self)
  )

(setf (get gps_driver_pkg::gps_msg :md5sum-) "660b3faaa5bbe708e0b3557a47fdbec5")
(setf (get gps_driver_pkg::gps_msg :datatype-) "gps_driver_pkg/gps_msg")
(setf (get gps_driver_pkg::gps_msg :definition-)
      "Header header
float64 latitude
float64 longitude
float64 altitude
float64 UTM_easting
float64 UTM_northing
float64 Zone
string Letter

================================================================================
MSG: std_msgs/Header
# Standard metadata for higher-level stamped data types.
# This is generally used to communicate timestamped data 
# in a particular coordinate frame.
# 
# sequence ID: consecutively increasing ID 
uint32 seq
#Two-integer timestamp that is expressed as:
# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')
# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')
# time-handling sugar is provided by the client library
time stamp
#Frame this data is associated with
string frame_id

")



(provide :gps_driver_pkg/gps_msg "660b3faaa5bbe708e0b3557a47fdbec5")


