# wifimon


#Start Wifi As Service
cd /home/pi/wifi_monitor

sudo cp wifi-monitor.service /etc/systemd/system/wifi-monitor.service

sudo systemctl daemon-reload

sudo systemctl enable wifi-monitor

sudo reboot

