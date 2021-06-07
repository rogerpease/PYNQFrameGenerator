module FrameGeneratorCore 
#(
)
(
   input clk,
   input reset, 

   output wire [7:0] dataOut,
   output reg dataOutLast,
   output reg dataOutValid,
   input  wire dataOutReady,

   input  wire [31:0] controlRegister,
   input  wire [31:0] heightWidthRegister,
   input  wire [31:0] dataOutLastPeriod,

   output wire [15:0] CoreID,
   output wire [31:0] rowColCounter  

);

// Add width and height. Modulo operations are expensive, so we have

  // Control Register 0:   0 = enable, bit 1 = reset 
   wire controlReset;
   assign controlReset = controlRegister[1]; 

   wire controlEnable;
   assign controlEnable = controlRegister[0]; 

   parameter FORMAT = 0; 
   parameter NUMPIXELPLANES = 3; 
   parameter LastPeriod     = 256; 

   wire [15:0] height; 
   wire [15:0] width; 
   assign height = heightWidthRegister[31:16]; 
   assign width  = heightWidthRegister[15:0]; 
   
   reg [2:0] pixelPlane; 
   reg [12:0] rowCounter; 
   reg [12:0] colCounter; 
   reg [24:0] dataOutLastIndex; 

  


   assign rowColCounter = { 3'b000,rowCounter,3'b000,colCounter }; 

   always @(posedge clk) 
   begin 
     if ((reset == 0) || (controlReset == 1)) 
       begin 
         pixelPlane = 0; 
         rowCounter = 0; 
         colCounter = 0; 
//         dataOut           = 8'hff; 
         dataOutValid      <= 0; 
         dataOutLast       <= 0; 
         dataOutLastIndex  <= 0; 
       $display ("RESET == 1");  
       end 
     else  
       begin 
         $display("MODULE: Toggle Clock DataOutReady ", dataOutReady, " Control Enable ",controlEnable); 
         if (controlEnable == 0)
           dataOutValid      <= 0; 
         else 
           dataOutValid      <= 1; 
           if ((dataOutReady == 1) && (dataOutValid))
           begin 
             if (FORMAT == 0) 
             begin 
               $display("MODULE: DataOutLastIndex: ",dataOutLastIndex, " dataOutLastPeriod ",dataOutLastPeriod); 
               if (dataOutLastIndex == dataOutLastPeriod[24:0]) 
               begin 
                 $display("MODULE: Dataoutlast"); 
                 dataOutLast <= 1; 
                 dataOutLastIndex <= 0; 
               end 
               else 
               begin 
                 dataOutLast <= 0; 
                 dataOutLastIndex <= dataOutLastIndex + 1; 
               end 
                  
               $display("ColCounter: ",colCounter, " RowCounter ",rowCounter," pixelPlane ", pixelPlane," DataOut ",dataOut); 
  
/*     verilator lint_off WIDTH */ 
               pixelPlane = (pixelPlane + 1); 
               if (pixelPlane == NUMPIXELPLANES)
               begin 
                 pixelPlane = 0; 
               end  
               if (pixelPlane == 0) 
               begin 
                 colCounter = (colCounter + 1);
                 if (colCounter == width[12:0])  
                   colCounter = 0; 
               end 

               if ((colCounter == 0) && (pixelPlane == 0)) 
                 rowCounter = (rowCounter + 1); 
               if (rowCounter == height[12:0]) 
                 rowCounter = 0;
  
 /* 
               if (colCounter[12:0] < width[15:2]) 
                 dataOut = (pixelPlane == 0) ? 8'hFF : 8'h00; // Blue 
               else if (colCounter[11:0] < width[15:1]) 
                 dataOut = (pixelPlane == 1) ? 8'hFF : 8'h00; // Red 
               else if (colCounter[12:0] < (width[15:1]+width[15:2]))
                 dataOut = (pixelPlane == 2) ? 8'hFF : 8'h00; // Green 
               else
                 dataOut = 8'hFF;                 // White. 
 */
/* verilator lint_on WIDTH */ 
               
             end 
           end
           else 
           begin 
             $display(" FORMAT != 0 ", dataOutReady); 
           end
       end 
     $display("MODULE: Ending Always "); 
   end 
    
 /* verilator lint_off WIDTH */

   wire redArea; 
   wire greenArea; 
   wire blueArea ; 
   wire whiteArea; 
   assign redArea   = (colCounter < width[15:2]); 
   assign greenArea = (!redArea) && (colCounter < width[15:1]); 
   assign blueArea  = (!redArea) && (!greenArea) && (colCounter < (width[15:1]+width[15:2])); 
   assign whiteArea = !redArea && ! greenArea && !blueArea; 

   assign dataOut = ((pixelPlane == 0) && ((redArea) || (whiteArea))) ? 8'hFF : 
                    ((pixelPlane == 1) && ((greenArea) || (whiteArea))) ? 8'hFF : 
                    ((pixelPlane == 2) && ((blueArea) || (whiteArea))) ? 8'hFF : 8'h00;  



   assign CoreID = 16'h0DEB;

endmodule 
