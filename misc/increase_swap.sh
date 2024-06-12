#!/bin/bash
sudo swapoff /dev/dm-1
sudo fallocate -l 16g /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
