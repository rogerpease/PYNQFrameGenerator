
`timescale 1 ns / 1 ps

//
// Do a s=FrameGeneratorTop=<name of your module>=g to rename. 
//  You will (hopefully) add ports to the register file ro 
//
	module FrameGeneratorTop #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line
 

		// Parameters of Axi Slave Bus Interface RegisterFile
		parameter integer C_RegisterFile_DATA_WIDTH	= 32,
		parameter integer C_RegisterFile_ADDR_WIDTH	= 7
	)
	(
		// Users to add ports here

                input frameOut_aclk,
                input frameOut_aresetn,
                          
                output [7:0] frameOut_tdata,
                output frameOut_tlast,
                output frameOut_tvalid,
                input  wire frameOut_tready,
                output frameOut_tstrb,


		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface RegisterFile
		input wire  RegisterFile_aclk,
		input wire  RegisterFile_aresetn,
		input wire [C_RegisterFile_ADDR_WIDTH-1 : 0] RegisterFile_awaddr,
		input wire [2 : 0] RegisterFile_awprot,
		input wire  RegisterFile_awvalid,
		output wire  RegisterFile_awready,
		input wire [C_RegisterFile_DATA_WIDTH-1 : 0] RegisterFile_wdata,
		input wire [(C_RegisterFile_DATA_WIDTH/8)-1 : 0] RegisterFile_wstrb,
		input wire  RegisterFile_wvalid,
		output wire  RegisterFile_wready,
		output wire [1 : 0] RegisterFile_bresp,
		output wire  RegisterFile_bvalid,
		input wire  RegisterFile_bready,
		input wire [C_RegisterFile_ADDR_WIDTH-1 : 0] RegisterFile_araddr,
		input wire [2 : 0] RegisterFile_arprot,
		input wire  RegisterFile_arvalid,
		output wire  RegisterFile_arready,
		output wire [C_RegisterFile_DATA_WIDTH-1 : 0] RegisterFile_rdata,
		output wire [1 : 0] RegisterFile_rresp,
		output wire  RegisterFile_rvalid,
		input wire  RegisterFile_rready
	);
  
        wire [31:0] register1; 
        wire [31:0] register2; 
        wire [31:0] register3; 
        wire [15:0] CoreID; 
        wire [31:0] rowColCounter; 
        wire [31:0] controlRegister; 
        wire [31:0] heightWidthRegister; 

// Instantiation of Axi Bus Interface RegisterFile
	FrameGeneratorTop_RegisterFile # ( 
		.C_S_AXI_DATA_WIDTH(C_RegisterFile_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_RegisterFile_ADDR_WIDTH)
	) FrameGeneratorTop_RegisterFile_inst (
                .register0(controlRegister),
                .register1(heightWidthRegister),
                .register2(register2),
                .register3(register3),
                .CoreID(CoreID), 
                .rowColCounter(rowColCounter), 
		.S_AXI_ACLK(RegisterFile_aclk),
		.S_AXI_ARESETN(RegisterFile_aresetn),
		.S_AXI_AWADDR(RegisterFile_awaddr),
		.S_AXI_AWPROT(RegisterFile_awprot),
		.S_AXI_AWVALID(RegisterFile_awvalid),
		.S_AXI_AWREADY(RegisterFile_awready),
		.S_AXI_WDATA(RegisterFile_wdata),
		.S_AXI_WSTRB(RegisterFile_wstrb),
		.S_AXI_WVALID(RegisterFile_wvalid),
		.S_AXI_WREADY(RegisterFile_wready),
		.S_AXI_BRESP(RegisterFile_bresp),
		.S_AXI_BVALID(RegisterFile_bvalid),
		.S_AXI_BREADY(RegisterFile_bready),
		.S_AXI_ARADDR(RegisterFile_araddr),
		.S_AXI_ARPROT(RegisterFile_arprot),
		.S_AXI_ARVALID(RegisterFile_arvalid),
		.S_AXI_ARREADY(RegisterFile_arready),
		.S_AXI_RDATA(RegisterFile_rdata),
		.S_AXI_RRESP(RegisterFile_rresp),
		.S_AXI_RVALID(RegisterFile_rvalid),
		.S_AXI_RREADY(RegisterFile_rready)
	);

	// Add user logic here

       assign frameOut_tstrb = frameOut_tvalid; 


       FrameGeneratorCore FrameGeneratorCore_inst
       (
          .clk(frameOut_aclk),
          .reset(frameOut_aresetn),
          .CoreID(CoreID),
          .rowColCounter(rowColCounter), 
          .controlRegister(controlRegister), 
          .heightWidthRegister(heightWidthRegister), 
       
          .dataOut      (frameOut_tdata),
          .dataOutLast  (frameOut_tlast),
          .dataOutValid (frameOut_tvalid),
          .dataOutReady (frameOut_tready),
          .dataOutLastPeriod(register3)  
       );



	// User logic ends

	endmodule
