#!/usr/bin/python
# This script is intended to allow easy access and gathering of serial logs on Wemo devices
# Author: Amanda Honea
#############################################################################################

import os
import sys
import serial
from time import gmtime, strftime
import glob
import logging
import logging.handlers

"""
Log file is created 
"""

class mrLogger:

  def __init__(self, source):
    self.file_handle = open('serial-log.txt', 'a')
    self.source=source
    self.buf = []

  def write(self, data):
    self.buf.append(data)
    if data.endswith('\n'):
      self.file_handle = open('serial-log.txt',  'a')
      self.file_handle.write('\t')
      self.file_handle.write(self.source + "|| " + ''.join(self.buf))
      self.file_handle.close()
      self.buf = []

  def __del__(self):
    if self.buf != []:
      self.file_handle = open('serial-log.txt', 'a')
      self.file_handle.write('\t')
      self.file_handle.write(self.source + "|| " + ''.join(self.buf) + '\n')
      self.file_handle.close()      


"""
The contents of the logfile is INFO for all standard output and ERROR for any errors such 
as terminating the script with ctl-c
"""
sys.stdout = mrLogger('INFO: ' + strftime("%m %d %Y %H:%M:%S", gmtime()))
sys.stderr = mrLogger('ERROR: ' + strftime("%m %d %Y %H:%M:%S", gmtime()))

"""
Check to see if the USB Serial device is attached
setting glob up for later dev, to add automation in detecting usb serial that is connected
"""

print "Hello world"
ser = glob.glob('/dev/tty*')

if [[ ser == 1 ]]:
	s = serial.Serial('/dev/ttyUSB_utps_modem', 57600)	

"""
If any serial connections are open then we will close them here
"""

if [[ s.open == 'true' ]] :
	s.close()
  
s.open()

print ('You are now connected to your serial Device')

while(1):
	if s.isOpen():			
		look = s.readline()
		print look 
		
		


				

			
