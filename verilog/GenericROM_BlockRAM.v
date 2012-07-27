//**************************************************************************************************
//**************************************************************************************************

module GenericROM 
(
	iClock,
	iReset,
	iAddress,
	oData
);

	parameter integer                   gAddressWidth   = 0;	// TODO: für merkwürdige Reihenfolge in Simulator
	parameter integer                   gDataWidth      = 1;
	parameter [cContentSize - 1 : 0]    gContent        = 1'b0;

	localparam                          cContentSize    = (2 ** gAddressWidth) * gDataWidth;

	input                           iClock;
	input                           iReset;
	input       [gAddressWidth-1:0] iAddress;
	output reg  [gDataWidth-1:0]    oData;

	(* rom_extract = "yes", rom_style = "block" *)
	reg [gDataWidth-1:0] aMem [2**gAddressWidth-1:0];

	integer i;
	initial begin
		for (i = 0; i < 2**gAddressWidth; i = i + 1) begin
			aMem[i] = gContent[i * gDataWidth +: gDataWidth];
		end
	end

	always @(posedge iClock or posedge iReset)
	begin
		if (iReset == 1'b1) begin
			oData <= {gDataWidth{1'b0}};
		end else begin
			oData <= aMem[iAddress];
		end
	end
endmodule
