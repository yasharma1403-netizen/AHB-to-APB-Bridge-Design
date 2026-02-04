module APB_Contoller_tb();
          reg hclk, hresetn, hwrite, valid, hwrite_reg;
		  reg [31:0] haddr, hwdata, haddr1, haddr2, hwdata1, hwdata2, prdata;
		  reg[2:0] temp_selx;
		  wire pwrite, penable, hr_readyout;
		  wire[2:0] psel;
		  wire[31:0]pwdata, paddr;
		  
		  
		APB_Controller DUT(valid, hwrite_reg, hwrite, hresetn, hreadyin, hclk,
                       	   haddr, haddr1, haddr2, hwdata, hwdata1, hwdata2, prdata, temp_selx,
                           pwrite, penable, hr_readyout, paddr, pwdata, psel);
						   
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
		
		initial
		 begin
		  reset;
		  hwrite=1'b1;
		  valid=1'b1;
		  haddr=32'h8100_0000;
		  haddr1=32'h8200_0000;
		  haddr2=32'h8300_0000;
		  hwdata='d32;
		  hwdata1='d45;
		  hwdata2='d52;
		  prdata='d543;
		  hwrite_reg=1'b1;
		  temp_selx=3'b001;
		  
		  #100;
		  
		  hwrite=1'b0;
		  valid=1'b0;
		 end
endmodule
		  