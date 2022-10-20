// Auto-generated. Do not edit!

// (in-package gps_driver_pkg.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;
let std_msgs = _finder('std_msgs');

//-----------------------------------------------------------

class gps_msg {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.header = null;
      this.latitude = null;
      this.longitude = null;
      this.altitude = null;
      this.UTM_easting = null;
      this.UTM_northing = null;
      this.Zone = null;
      this.Letter = null;
    }
    else {
      if (initObj.hasOwnProperty('header')) {
        this.header = initObj.header
      }
      else {
        this.header = new std_msgs.msg.Header();
      }
      if (initObj.hasOwnProperty('latitude')) {
        this.latitude = initObj.latitude
      }
      else {
        this.latitude = 0.0;
      }
      if (initObj.hasOwnProperty('longitude')) {
        this.longitude = initObj.longitude
      }
      else {
        this.longitude = 0.0;
      }
      if (initObj.hasOwnProperty('altitude')) {
        this.altitude = initObj.altitude
      }
      else {
        this.altitude = 0.0;
      }
      if (initObj.hasOwnProperty('UTM_easting')) {
        this.UTM_easting = initObj.UTM_easting
      }
      else {
        this.UTM_easting = 0.0;
      }
      if (initObj.hasOwnProperty('UTM_northing')) {
        this.UTM_northing = initObj.UTM_northing
      }
      else {
        this.UTM_northing = 0.0;
      }
      if (initObj.hasOwnProperty('Zone')) {
        this.Zone = initObj.Zone
      }
      else {
        this.Zone = 0.0;
      }
      if (initObj.hasOwnProperty('Letter')) {
        this.Letter = initObj.Letter
      }
      else {
        this.Letter = '';
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type gps_msg
    // Serialize message field [header]
    bufferOffset = std_msgs.msg.Header.serialize(obj.header, buffer, bufferOffset);
    // Serialize message field [latitude]
    bufferOffset = _serializer.float64(obj.latitude, buffer, bufferOffset);
    // Serialize message field [longitude]
    bufferOffset = _serializer.float64(obj.longitude, buffer, bufferOffset);
    // Serialize message field [altitude]
    bufferOffset = _serializer.float64(obj.altitude, buffer, bufferOffset);
    // Serialize message field [UTM_easting]
    bufferOffset = _serializer.float64(obj.UTM_easting, buffer, bufferOffset);
    // Serialize message field [UTM_northing]
    bufferOffset = _serializer.float64(obj.UTM_northing, buffer, bufferOffset);
    // Serialize message field [Zone]
    bufferOffset = _serializer.float64(obj.Zone, buffer, bufferOffset);
    // Serialize message field [Letter]
    bufferOffset = _serializer.string(obj.Letter, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type gps_msg
    let len;
    let data = new gps_msg(null);
    // Deserialize message field [header]
    data.header = std_msgs.msg.Header.deserialize(buffer, bufferOffset);
    // Deserialize message field [latitude]
    data.latitude = _deserializer.float64(buffer, bufferOffset);
    // Deserialize message field [longitude]
    data.longitude = _deserializer.float64(buffer, bufferOffset);
    // Deserialize message field [altitude]
    data.altitude = _deserializer.float64(buffer, bufferOffset);
    // Deserialize message field [UTM_easting]
    data.UTM_easting = _deserializer.float64(buffer, bufferOffset);
    // Deserialize message field [UTM_northing]
    data.UTM_northing = _deserializer.float64(buffer, bufferOffset);
    // Deserialize message field [Zone]
    data.Zone = _deserializer.float64(buffer, bufferOffset);
    // Deserialize message field [Letter]
    data.Letter = _deserializer.string(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    length += std_msgs.msg.Header.getMessageSize(object.header);
    length += _getByteLength(object.Letter);
    return length + 52;
  }

  static datatype() {
    // Returns string type for a message object
    return 'gps_driver_pkg/gps_msg';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '660b3faaa5bbe708e0b3557a47fdbec5';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    Header header
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
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new gps_msg(null);
    if (msg.header !== undefined) {
      resolved.header = std_msgs.msg.Header.Resolve(msg.header)
    }
    else {
      resolved.header = new std_msgs.msg.Header()
    }

    if (msg.latitude !== undefined) {
      resolved.latitude = msg.latitude;
    }
    else {
      resolved.latitude = 0.0
    }

    if (msg.longitude !== undefined) {
      resolved.longitude = msg.longitude;
    }
    else {
      resolved.longitude = 0.0
    }

    if (msg.altitude !== undefined) {
      resolved.altitude = msg.altitude;
    }
    else {
      resolved.altitude = 0.0
    }

    if (msg.UTM_easting !== undefined) {
      resolved.UTM_easting = msg.UTM_easting;
    }
    else {
      resolved.UTM_easting = 0.0
    }

    if (msg.UTM_northing !== undefined) {
      resolved.UTM_northing = msg.UTM_northing;
    }
    else {
      resolved.UTM_northing = 0.0
    }

    if (msg.Zone !== undefined) {
      resolved.Zone = msg.Zone;
    }
    else {
      resolved.Zone = 0.0
    }

    if (msg.Letter !== undefined) {
      resolved.Letter = msg.Letter;
    }
    else {
      resolved.Letter = ''
    }

    return resolved;
    }
};

module.exports = gps_msg;
