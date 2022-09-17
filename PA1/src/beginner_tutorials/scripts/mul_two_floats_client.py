#!/usr/bin/env python

from __future__ import print_function

import sys
import rospy
from beginner_tutorials.srv import *

def mul_two_floats_client(x, y):
    rospy.wait_for_service('mul_two_floats')
    try:
        mul_two_floats = rospy.ServiceProxy('mul_two_floats', MulTwoFloats)
        resp1 = mul_two_floats(x, y)
        return resp1.mul
    except rospy.ServiceException as e:
        print("Service call failed: %s"%e)

def usage():
    return "%s [x y]"%sys.argv[0]

if __name__ == "__main__":
    if len(sys.argv) == 3:
        x = float(sys.argv[1])
        y = float(sys.argv[2])
    else:
        print(usage())
        sys.exit(1)
    print("Requesting %s*%s"%(x, y))
    print("%s * %s = %s"%(x, y, mul_two_floats_client(x, y)))
