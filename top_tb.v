module top_tb();
      reg hclk, hresetn;
	  wire [31:0] haddr, hwdata, hrdata, paddr, paddr_out, pwdata, pwdata_out, prdata;
	  wire hwrite, hreadyin, hr_readyout, valid, hwrite_reg, pwrite, pwrite_out, penable, penable_out;
	  wire [1:0] htrans, hresp;
	  wire [2:0] temp_selx, psel, psel_out;
	  
	  AHB_Master ahb(hclk, hresetn, hreadyout, hrdata, hwrite,hreadyin, haddr, hwdata, htrans);
	  
	  APB_Interface apb(penable, pwrite, psel, pwdata, paddr, pwrite_out, penable_out, psel_out,
                        pwdata_out, paddr_out, prdata);
	  
	  Bridge_top bridge(hclk, hresetn, hwrite, hreadyin, htrans, haddr, hwdata, prdata, pwrite,
                    	penable, hr_readyout, psel, pwdata, paddr, hrdata); 
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
	//ahb.single_write();
	ahb.burst_write();
	//ahb.single_read();
   end
endmodule
	
	