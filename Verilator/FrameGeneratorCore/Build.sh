verilator --cc --exe --trace --top-module FrameGeneratorCore --build -j TestModule.cpp ../../Verilog/module/FrameGeneratorCore.sv 

#make -j -C obj_dir -f VStreamElement.mk VStreamElement 
