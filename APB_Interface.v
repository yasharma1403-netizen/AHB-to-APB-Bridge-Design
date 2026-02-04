module APB_Interface(input penable, pwrite,
                     input [2:0]psel,
					 input [31:0]pwdata, paddr,
					 output pwrite_out, penable_out,
					 output [2:0]psel_out,
					 output [31:0]pwdata_out, paddr_out,
					 output reg[31:0]prdata);
					 
	assign penable_out=penable;
	assign pwrite_out=pwrite;
	assign pwdata_out=pwdata;
	assign paddr_out=paddr;
	assign psel_out=psel;
	
always@(*)
 begin
  if(!pwrite && penable)
  begin
  prdata=8'd37;
  end
 end
endmodule
