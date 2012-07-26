
module GenericROM_tb;

	localparam	cAddressWidth	= 6;
	localparam	cContentSize 	= 40 * 40;

	reg							sClock, sReset;
	reg [cAddressWidth-1:0]		sAddress;

	initial begin
		sClock = 0;
		sReset = 1;
		#202 sReset = ~sReset;
	end

	always #5 sClock = ~sClock;

	always @(negedge sClock)
	begin
		if (sReset)
// 			sAddress <= {cAddressWidth{1'b1}};
			sAddress <= {cAddressWidth{1'b0}};
		else begin
// 			if (sAddress == 0)
			if (sAddress == {cAddressWidth{1'b1}})
				$finish;
// 			sAddress <= sAddress - 1;
			sAddress <= sAddress + 1;
		end
	end

// 	GenericROM
// 	#(
// 		.gAddressWidth(5),
// 		.gDataWidth(1),
// 		.gContent(5'b01001)
// 	)
// 	UUT
// 	(
// 		.iReset(sReset),
// 		.iClock(sClock),
// 		.iAddress(sAddress),
// 		.oData()
// 	);

	function [cContentSize - 1 : 0] GetContent(input integer iWidth);
		integer i;
	begin
		GetContent = 1'b0;
		for (i = 0; i < cContentSize; i = i + iWidth + 1)
			GetContent[i] = 1'b1;
	end
	endfunction

	generate
		genvar i;

		// TODO: range anpassen
		for (i = 8; i <= 8; i = i + 1) begin : Gen

			wire [i-1:0]			sData;
			reg	 [i-1:0]			sDataRef;
			reg  [cContentSize-1:0]	sContent;
			integer					j;

			GenericROM
			#(
				.gAddressWidth(cAddressWidth),
				.gDataWidth(i),
				.gContent(GetContent(i))
			)
			UUT
			(
				.iReset(sReset),
				.iClock(sClock),
				.iAddress(sAddress),
				.oData(sData)
			);

			always @(posedge sClock)
			if (sReset == 1)
				sContent <= GetContent(i);
			else begin
				if ((sAddress + 1) * i <= cContentSize)
					sDataRef <= sContent[(sAddress * i)+:i];
				else begin
					sDataRef <= 1'b0;
					for (j = sAddress * i; j < cContentSize; j = j + 1)
						sDataRef[j - (sAddress * i)] <= sContent[j];
				end
			end

			always @(negedge sClock)
			if (sReset == 0)
				$display("Data <-> Ref: %x <-> %x\n", sData, sDataRef);

// 				assert (sData = vContent)
// 					report "data mismatch at " & to_string(sAddress) &
// 						": expected " & to_string(vContent) & ", got " & to_string(sData)
// 					severity error;

		end
	endgenerate

endmodule
