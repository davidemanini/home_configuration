#! /usr/bin/python3

import subprocess
import math

xrandr=subprocess.run(["xrandr"],capture_output=True).stdout

r=xrandr.split(b'\n')[0].split(b', ')[1].split(b' ')

width=r[1]
height=r[3]



xres=max(round(4*1920/int(width)),1)
yres=max(round(4*1080/int(height)),1)

print("DeskTopSize %ix%i"%(xres,yres))
