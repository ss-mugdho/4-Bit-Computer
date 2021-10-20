module testbench;
  reg clock = 0;
  reg reset = 1;
  reg [3:0] data_in,prog_inst,prog_data,prog_count;
  wire [3:0] data_out;
  reg [3:0] prog_inst_mem[15:0];
  reg [3:0] prog_data_mem[15:0];
  reg [3:0] data_mem[15:0];
  
  four_bit_comp test(clock,reset,data_in,prog_inst,prog_data,prog_count,data_out);
  
  integer count;
  
  	parameter NONE = 4'b0000;

	parameter ADD_A_B	= 4'd0;
	parameter SUB_A_B	= 4'd1;
	parameter XCHG_B_A	= 4'd2;
	parameter MOV_A_ADD	= 4'd3;
	parameter MOV_ADD_B	= 4'd4;
	parameter JNZ_ADD	= 4'd5;
	parameter XOR_A_ADD	= 4'd6;
	parameter PUSHF 	= 4'd7;
	parameter IN_B  	= 4'd8;
	parameter OUT_A 	= 4'd9;
	parameter JMP_ADD	= 4'd10;
	parameter PUSH_A	= 4'd11;
	parameter POP_A 	= 4'd12;
	parameter CALL_ADD	= 4'd13;
	parameter RET   	= 4'd14;
	parameter HLT		= 4'd15;
  
  	initial begin
      
      data_mem[0] = 4'd3;
      data_mem[1] = 4'd5;
      data_mem[2] = 4'd0;
      data_mem[3] = 4'd0;
      data_mem[4] = 4'd0;
      data_mem[5] = 4'd0;
      data_mem[6] = 4'd0;
      data_mem[7] = 4'd0;
      data_mem[8] = 4'd0;
      data_mem[9] = 4'd0;
      data_mem[10] = 4'd0;
      data_mem[11] = 4'd0;
      data_mem[12] = 4'd0;
      data_mem[13] = 4'd0;
      data_mem[14] = 4'd0;
      data_mem[15] = 4'd0;
      
      prog_inst_mem[0] = MOV_A_ADD;	prog_data_mem[0] = 4'd0;
      prog_inst_mem[1] = XCHG_B_A;	prog_data_mem[1] = NONE;
      prog_inst_mem[2] = MOV_A_ADD;	prog_data_mem[2] = 4'd1;
      prog_inst_mem[3] = ADD_A_B;	prog_data_mem[3] = NONE;
      prog_inst_mem[4] = SUB_A_B;	prog_data_mem[4] = NONE;
      prog_inst_mem[5] = OUT_A;		prog_data_mem[5] = NONE;
      prog_inst_mem[6] = HLT;		prog_data_mem[6] = NONE;
      prog_inst_mem[7] = NONE;		prog_data_mem[7] = NONE;
      prog_inst_mem[8] = NONE;		prog_data_mem[8] = NONE;
      prog_inst_mem[9] = NONE;		prog_data_mem[9] = NONE;
      prog_inst_mem[10] = NONE;		prog_data_mem[10] = NONE;
      prog_inst_mem[11] = NONE;		prog_data_mem[11] = NONE;
      prog_inst_mem[12] = NONE;		prog_data_mem[12] = NONE;
      prog_inst_mem[13] = NONE;		prog_data_mem[13] = NONE;
      prog_inst_mem[14] = NONE;		prog_data_mem[14] = NONE;
      prog_inst_mem[15] = NONE;		prog_data_mem[15] = NONE;
      
      
    $dumpfile("dump.vcd");
    $dumpvars;
    
    for (count = 0;count < 16; count = count+1) begin
      # 1 clock = 0;
      data_in = data_mem[count];
      prog_inst = prog_inst_mem[count];
      prog_data = prog_data_mem[count];
      prog_count = count;
      # 1 clock = 1;
      
    end
    
    # 1 reset = 0;
    # 32 $finish;
  end 
  always #1 clock = !clock;
endmodule