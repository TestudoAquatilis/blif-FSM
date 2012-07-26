//**************************************************************************************************
//**************************************************************************************************

module InternalROM
(
	input                       iClock,
	input                       iReset,
	input   [gAddressWidth-1:0] iAddress,
	output  [gDataWidth-1:0]    oData
);

	parameter integer                   gAddressWidth   = 0;	// TODO: für merkwürdige Reihenfolge in Simulator
	parameter integer                   gDataWidth      = 1;
	parameter [cContentSize - 1 : 0]    gContent        = 1'b0;

	localparam                          cContentSize    = (2 ** gAddressWidth) * gDataWidth;

	reg [gDataWidth-1:0] oData;

	always @(posedge iClock or posedge iReset)
	begin
		if (iReset == 1'b1) begin
			oData <= {gDataWidth{1'b0}};
		end else begin
			oData <= gContent[iAddress * gDataWidth +: gDataWidth];
		end
	end
endmodule
