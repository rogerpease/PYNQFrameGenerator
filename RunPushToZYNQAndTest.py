#!/usr/bin/env python3 

import os

PYNQHOST="xilinx@192.168.1.128"
PYNQROOTHOST="root@192.168.1.128"
PYNQDIR="/home/xilinx/PYNQFrameGenerator"
PYNQSCPTARGET=PYNQHOST+":"+PYNQDIR

def Run(command):
  print("Running: "+command)
  os.system(command)

#
# Copy all files to ZYNQ 
#

Run("ssh "+PYNQHOST + " rm "+PYNQDIR+"/*")
Run("ssh "+PYNQHOST + " mkdir "+PYNQDIR)
Run("scp ./FPGAImage/FPGAImage.runs/impl_1/design_1_wrapper.bit "+                 PYNQSCPTARGET+"/PYNQFrameGenerator.bit")
Run("scp ./FPGAImage/FPGAImage.gen/sources_1/bd/design_1/hw_handoff/design_1.hwh "+PYNQSCPTARGET+"/PYNQFrameGenerator.hwh")
Run("scp python/RunFrameGenerator.py ./testcases/Golden_RedGreenBlueWhite1920x1080_RGB24.raw ")

Run("ssh "+PYNQROOTHOST + ' ' + PYNQDIR +"/ZYNQRunSBNRegression.sh" )
