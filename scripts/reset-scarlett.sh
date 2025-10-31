#!/bin/bash
echo "Restarting sound card..."

sudo alsactl restore

echo "Sound card restarted"
