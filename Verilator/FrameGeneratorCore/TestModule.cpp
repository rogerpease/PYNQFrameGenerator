#include <iostream>
#include "VFrameGeneratorCore.h"
#include <memory> 
#include <sstream> 
#include <fstream>

// Drive a stream element and compare results. 
//
//

class FrameGeneratorCoreWrapperClass : VFrameGeneratorCore
{

  public:
  bool debug = false;  
  int absoluteCycle = 0; 
  
  FrameGeneratorCoreWrapperClass () 
  {  
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
    VFrameGeneratorCore{contextp.get(), "VFrameGeneratorCore"};
  } 

  void ToggleClock() { 
     this->clk = 1; this->eval(); this->clk = 0; this->eval(); 
     if (debug) printf("Clock Toggled\n"); this->absoluteCycle++; 
    
  } 
  void Reset() { this->reset = 0; ToggleClock(); ToggleClock(); this->reset = 1; ToggleClock(); } 


  bool DriveStreamCycleAndCheckResult() 
  {
      this->dataOutReady = 0; 
      Reset(); 
      ToggleClock(); 
      const int height = 1080; 
      const int width  = 1920; 
#define DATAOUTPERIOD (height*width*3) 
      this->dataOutLastPeriod = DATAOUTPERIOD-1; 
      const int bytesperpixel  = 3; 
      const int frameSizeBytes = height*width*bytesperpixel;  

      this->heightWidthRegister= (height<<16)+width; 
      ToggleClock(); 
  
      this->dataOutReady = 1; 
  
      this->controlRegister = 1; 
      unsigned char * framePtr = (unsigned char *) malloc(frameSizeBytes);  
      assert(framePtr != nullptr); 
      int captureCycle = 0; 
      while (captureCycle < frameSizeBytes) 
      {

          
    
        if ((this->dataOutValid) && (this->dataOutReady)) 
        { 
             *(framePtr + captureCycle) = this->dataOut;
             if (debug) printf("%d %x\n",captureCycle,this->dataOut); 
             if (this->dataOutLast == 1) { if (captureCycle != 0) { if ((captureCycle % DATAOUTPERIOD) == DATAOUTPERIOD) { } else { printf("dataOutLast should be low cycle %d %d",captureCycle,DATAOUTPERIOD-1); exit(1); } } } 
             else                        { if (captureCycle != 0) { if ((captureCycle % DATAOUTPERIOD) != DATAOUTPERIOD) { } else { printf("dataOutLast should be high cycle %d %d",captureCycle,DATAOUTPERIOD-1); exit(1);} } } 
             captureCycle++;
        } 

        // If ready, we'll capture this cycle but not next. 
        if ((this->absoluteCycle % 5) == 0)  // Drop dataOutReady every few cycles  
           this->dataOutReady = 0; 
        else 
           this->dataOutReady = 1; 

        ToggleClock();
        if (debug) printf("Testbench Relooping %d\n",captureCycle); 

      } 


      for (int i = 0; i < 20; i++) 
      { 
         printf("Final %d %x\n",i,*(framePtr+i)); 
      }  
       
      std::ofstream f("outfile.bin"); 
      f.write((const char *) framePtr,frameSizeBytes); 
      f.close(); 
      return true; 
  } 
};


int main(int argc, char **argv) 
{
   int arg = 0; 
   const bool debug = false; 


   FrameGeneratorCoreWrapperClass FrameGeneratorCoreWrapper; 
   FrameGeneratorCoreWrapper.Reset();  
   assert (FrameGeneratorCoreWrapper.DriveStreamCycleAndCheckResult());  
   std::cout << "Test: ************************************** PASS!!!!  ************************************" <<std::endl;       

}
