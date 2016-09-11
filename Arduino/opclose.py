import serial
from time import sleep
import urllib2

print ("STATUS: 200 OK\n")


ser = serial.Serial('/dev/cu.usbmodem1421', 9600, timeout=5)
sleep(5)

while 1:
    print "HTTP reading..."
    data = urllib2.urlopen("http://192.241.204.102:8001/").read()
    print data

    ser.write(data)
    sleep(1)


ser.close()

print ("ok")