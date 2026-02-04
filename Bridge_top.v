module Bridge_top(input hclk, hresetn, hwrite, hreadyin,
                  input [1:0]htrans,
				  input [31:0]haddr, hwdata, prdata,
				  output pwrite, penable, hr_readyout,
				  output [2:0]psel,
				  output [31:0]pwdata, paddr, hrdata);
				  wire [1:0]hresp;
				  wire valid, hwrite_reg;
				  wire [31:0]haddr1, haddr2, hwdata1, hwdata2;
				  wire [2:0]temp_selx;
				  
		AHB_slave_interface ahb_s(hclk, hrestn, hwrite, hreadyin, hwdata, haddr, prdata, htrans, hresp,
                                  valid, hwrite_reg, haddr1, haddr2, hwdata1, hwdata2, temp_selx, hrdata);
								  
		APB_Controller apb_c(valid, hwrite_reg, hwrite, hresetn, hreadyin, hclk,
                       		 haddr, haddr1, haddr2, hwdata, hwdata1, hwdata2, prdata, temp_selx,
                             pwrite, penable, hr_readyout, paddr, pwdata, psel);
							 
endmodule
				  
				  
				  