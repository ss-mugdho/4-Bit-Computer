module four_bit_comp(clock,reset,data_in,prog_inst,prog_data,prog_count,data_out);
  input clock;
  input reset;
  input [3:0] data_in;				//data input port
  input [3:0] prog_inst;			//program intrsuction input port
  input [3:0] prog_data;			//program data input port
  input [3:0] prog_count;			//program counter
  
  output reg [3:0] data_out;		//output port
  reg [3:0] A,B,C;					//arithmetic registers
  reg [3:0] IP,SP;					//instruction pointer and stack pointer
  reg [3:0] data_mem[15:0];			//data memory
  reg [3:0] prog_inst_mem[15:0];	//program intsruction memory, stores inst code
  reg [3:0] prog_data_mem[15:0];	//program data memory, stores data corresponding to inst
  reg [3:0] stack[15:0];			//stack memory
  reg HF,ZF,CF = 1'd0;				//halt flag,zero flag,carry flag
  integer count = 0;
  
  always @(negedge clock)			//this block loads the program and data
    begin							//before executing them
      data_mem[prog_count] = data_in;
      prog_inst_mem[prog_count] = prog_inst;
      prog_data_mem[prog_count] = prog_data;
    end
  
  always @(posedge clock)			//this block executes the program
    begin
      
      if (reset == 1)				//resets everything
        begin
          HF = 0;ZF = 0;CF = 0;
          A = 0;B = 0;C = 0;
          IP = 0;SP = 15;
          data_out = 4'bzzzz;
        end
      else if (reset == 0 && HF == 0)	
        begin
          
          if (prog_inst_mem[IP] == 0) 
            begin					//ADD A, B
          	{CF, A} = A + B;
            if (A == 0) begin 
				ZF = 1;
				end
			end
		
		else if (prog_inst_mem[IP] == 1) 
          	begin					//SUB A, B
          	{CF, A} = A - B;
            if (A == 0) begin 
				ZF = 1;
				end
			end
		
		else if (prog_inst_mem[IP] == 2) 
          	begin					//XCHG B, A
		  	C = A;
		  	A = B;
		  	B = C;
            if (B == 0) begin 
				ZF = 1;
				end
			end
          
        else if (prog_inst_mem[IP] == 3)
          begin						//MOV A,[ADDRESS]
            A = data_mem[prog_data_mem[IP]];
            if (A == 0) begin 
				ZF = 1;
				end
          end
          
        else if (prog_inst_mem[IP] == 4)
          begin						//MOV [ADDRESS],B
            data_mem[prog_data_mem[IP]] = B;
            if (B == 0) begin 
				ZF = 1;
				end
          end 
          
        else if (prog_inst_mem[IP] == 5)
          begin						//JNZ ADDRESS
            if (ZF == 0) IP = prog_data_mem[IP];
          end
          
        else if (prog_inst_mem[IP] == 6)
          begin						//XOR A,[ADDRESS]
            A = A ^ data_mem[prog_data_mem[IP]];
            if (A == 0) begin 
				ZF = 1;
				end
          end
          
          else if (prog_inst_mem[IP] == 7)
          begin						//PUSHF
            stack[SP] = {1'b0,ZF,CF,HF};
            SP = SP - 1;
          end
          
          else if (prog_inst_mem[IP] == 8)
          begin
            B = data_in;			//IN B
            if (B == 0) begin 
				ZF = 1;
				end
          end
          
          else if (prog_inst_mem[IP] == 9)
          begin						//OUT A
            data_out = A;
            if (A == 0) begin 
				ZF = 1;
				end
          end
          
          else if (prog_inst_mem[IP] == 10)
          begin						//JMP ADDRESS
            IP = prog_data_mem[IP];
          end
          
          else if (prog_inst_mem[IP] == 11) 
          begin						// PUSH A
          	stack[SP] = A;
		  	SP = SP - 1;
          	if (A == 0) begin 
				ZF = 1;
				end
		  end
          
          else if (prog_inst_mem[IP] == 12)
          begin						//POP A
            SP = SP + 1;
            A = stack[SP];
            stack[SP] = 4'd0;
            if (A == 0) begin 
				ZF = 1;
				end
          end
          
          else if (prog_inst_mem[IP] == 13)
          begin						//CALL ADDRESS
            stack[SP] = IP;
            SP = SP - 1;
            IP = prog_data_mem[IP];
          end
          
          else if (prog_inst_mem[IP] == 14)
          begin
            SP = SP + 1;			//RET
            IP = stack[SP];
          end
          
          else if (prog_inst_mem[IP] == 15)	
          begin						//HLT
		  	HF = 1;
		  end
          IP = IP + 1;				//updating instruction pointer
        end
      end
    
endmodule
