#!/usr/bin/env python3 
#
# To Run: 
#  RunFrameGenerator.py 
# 
# Should return PASS if we got the image we expected. 
#

from pynq import Overlay 
from pynq import allocate 
import sys
import json 
import time 
import numpy
import collections
import os

#
# Change to path of script. 
#
abspath = os.path.abspath(__file__)
dname = os.path.dirname(abspath)
os.chdir(dname)

#
# Load Image 
#

ol = Overlay("PYNQFrameGenerator.bit") 
fg=ol.FrameGeneratorTop_0
dma=ol.axi_dma_0

height=1080
width =1920
pixels=3 

# Write Number of pixelse we will need (for LAST generation). 
# The next rev will have this auto-computed. :) 
#
fg.write(0x0C,height*width*pixels-1)
# Write height/width to peripheral. 
fg.write(0x04,(height<<16)+width)

receiveFrame = allocate(shape=(height*width*pixels,),dtype='u1')
receiveFrame[:] = 44 

dma.recvchannel.start()
dma.recvchannel.transfer(receiveFrame)
startTime = time.time()
fg.write(0x00,1)
dma.recvchannel.stop()
endTime = time.time()

print("Transfer Time: ", abs(endTime-startTime)*1000000," us" )

with open("pynqOutputFrame.raw","wb") as fp:
  fp.write(bytearray(receiveFrame)) 

with open("Golden_RedGreenBlueWhite1920x1080_RGB24.raw","rb") as fp:
    fileContent = fp.read()

compareFrame = []
for val in fileContent:
  compareFrame += [val]

if (collections.Counter(compareFrame) != collections.Counter(receiveFrame)):
  print( "FAIL- Compare Frame and receive frame Mismatch. Output filename is pynqOutputFrame.raw");
  exit(1)
else:
  print("PASS!")
  exit(0)


