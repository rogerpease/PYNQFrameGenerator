#!/usr/bin/env python3 

#
#
#  In a "Real world" engineering environment we might try generifying these scripts so that all projects are using the same scripts. 
#  For my purposes keeping them separate is good enough. 
#
#
import os

ROOTNAME= "PYNQFrameGenerator" 

PYNQXILINXACCOUNTANDHOST= "xilinx@192.168.1.128"
PYNQROOTACCOUNTANDHOST  = "root@192.168.1.128"

PYNQDIR="/home/xilinx/"+ROOTNAME
PYNQSCPTARGET=PYNQXILINXACCOUNTANDHOST+":"+PYNQDIR

def Run(command):
  print("Running: "+command)
  os.system(command)

#
# Copy all files to ZYNQ 
#

Run("ssh "+PYNQXILINXACCOUNTANDHOST + " rm "+PYNQDIR+"/*")
Run("ssh "+PYNQXILINXACCOUNTANDHOST + " mkdir "+PYNQDIR)
Run("scp ./project_1/project_1.runs/impl_1/design_1_wrapper.bit "+                           PYNQSCPTARGET+"/"+ROOTNAME+".bit")
Run("scp ./project_1/project_1.gen/sources_1/bd/design_1/hw_handoff/design_1.hwh "+PYNQSCPTARGET+"/"+ROOTNAME+".hwh")
Run("scp python/RunFrameGenerator.py ./testImages/Golden_RedGreenBlueWhite1920x1080_RGB24.raw " + PYNQROOTACCOUNTANDHOST+":"+PYNQDIR)


#
# and run 
#
Run("ssh "+PYNQROOTACCOUNTANDHOST + ' ' + PYNQDIR +"/RunFrameGenerator.py" )
