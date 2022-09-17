#!/usr/bin/env python

from __future__ import print_function

from beginner_tutorials.srv import MulTwoFloats,MulTwoFloatsResponse
import rospy

def handle_mul_two_floats(req):
    print("Returning [%s * %s = %s]"%(req.a, req.b, (req.a * req.b)))
    return MulTwoFloatsResponse(req.a * req.b)
 
def mul_two_floats_server():
    rospy.init_node('mul_two_floats_server')
    s = rospy.Service('mul_two_floats', MulTwoFloats, handle_mul_two_floats)
    print("Ready to Multiply two floats.")
    rospy.spin()
if __name__ == "__main__":
    mul_two_floats_server()
