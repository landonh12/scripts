#!/bin/bash
gst-launch-1.0 v4l2src device=/dev/video1 ! 'video/x-raw,width=640,height=480,framerate=30/1' ! videoconvert ! vpuenc_h264 ! rtph264pay config-interval=1 pt=96 ! udpsink host=192.168.86.21 port=5000 sync=false &
