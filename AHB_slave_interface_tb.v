module AHB_slave_interface_tb();
  reg hclk, hresetn, hwrite, hreadyin;
  reg [31:0] haddr, hwdata, prdata;
  reg [1:0] htrans, hresp;
  wire valid, hwrite_reg;
  wire [2:0] temp_selx;
  wire [31:0] haddr1, haddr2, hwdata1, hwdata2, hrdata;
  
  AHB_slave_interface DUT(hclk, hresetn, hwrite, hreadyin, hwdata, haddr, prdata, htrans, hresp,
                          valid, hwrite_reg, haddr1, haddr2, hwdata1, hwdata2, temp_selx, hrdata);
						  
	initial
	 begin
	  hclk=1'b0;
	  forever #10 hclk=~hclk;
	 end
	 
	task reset();
	 begin
	  @(negedge hclk)
	   hresetn=1'b0;
	  @(negedge hclk)
	   hresetn=1'b1;
	 end
	endtask
	   
	task inputs(input i, j,input [1:0]k);
	 begin
	  @(negedge hclk);
	  hwrite=i;
	  hreadyin=j;
	  htrans=k;
	 end
	endtask
	
    task in(input[31:0]d, e);
	 begin
	  hwdata=d;
	  haddr=e;
	 end
	endtask
	
	initial
	 begin
	  reset;
	  inputs(1,1,2'b10);
	  in(32'h28, 32'h8000_0002);
	  inputs(1,1,2'b11);
	  in(32'h73, 32'h8000_0003);
	  inputs(1,1,2'b10);
	  in(32'h89, 32'h8000_0004);
	  inputs(1,1,2'b00);
	  in(32'h105, 32'h8000_0005);
	  inputs(0,1,2'b10);
	  in(32'h0, 32'h0);
	  prdata=32'h73;
	 end
endmodule
