#!/bin/bash
gst-launch-1.0 v4l2src device=/dev/video1 ! video/x-raw, width=640, height=480, framerate=30/1 ! timeoverlay ! jpegenc ! multifilesink location="/home/root/images/img_%d.jpg"
