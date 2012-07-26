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

	/////////////////////////////////////////////////////////////////////
	//  READ_WIDTH | BRAM_SIZE | READ Depth  | ADDR Width |            //
	// WRITE_WIDTH |           | WRITE Depth |            |  WE Width  //
	// ============|===========|=============|============|============//
	//    19-36    |  "18Kb"   |      512    |    9-bit   |    4-bit   //
	//    10-18    |  "18Kb"   |     1024    |   10-bit   |    2-bit   //
	//    10-18    |   "9Kb"   |      512    |    9-bit   |    2-bit   //
	//     5-9     |  "18Kb"   |     2048    |   11-bit   |    1-bit   //
	//     5-9     |   "9Kb"   |     1024    |   10-bit   |    1-bit   //
	//     3-4     |  "18Kb"   |     4096    |   12-bit   |    1-bit   //
	//     3-4     |   "9Kb"   |     2048    |   11-bit   |    1-bit   //
	//       2     |  "18Kb"   |     8192    |   13-bit   |    1-bit   //
	//       2     |   "9Kb"   |     4096    |   12-bit   |    1-bit   //
	//       1     |  "18Kb"   |    16384    |   14-bit   |    1-bit   //
	//       1     |   "9Kb"   |     8192    |   13-bit   |    1-bit   //
	/////////////////////////////////////////////////////////////////////

	localparam                          cRamSize        = GetRamSize(0);
	localparam                          cAddressWidth   = GetAddressWidth(0);
	localparam                          cContentSize    = (2 ** cAddressWidth) * gDataWidth;

	localparam                          cDStep          = GetDStep(0);
	localparam                          cPStep          = (gDataWidth <= cDStep) ? 0 : (cDStep / 8);
	localparam                          cDUsed          = (gDataWidth <= cDStep) ? gDataWidth : cDStep;
	localparam                          cPUsed          = (cPStep > 0) ? gDataWidth - cDUsed : 1;

	wire [cAddressWidth - 1 : 0]        sAddress        = iAddress;

	function integer GetRamSize(input dummy = 0);
		localparam cSize = (2 ** gAddressWidth) * gDataWidth;
	begin
		if (gAddressWidth == 0)	// TODO: für merkwürdige Reihenfolge in Simulator
			GetRamSize = 18;
		else if (cSize <= 9 * 1024 && gDataWidth <= 18)
			GetRamSize = 9;
		else if (cSize <= 18 * 1024 && gDataWidth <= 36)
			GetRamSize = 18;
		else
//          assert false
//              report "illegal block RAM size"
//              severity failure;
			GetRamSize = 0;
	end
	endfunction

	function integer GetAddressWidth(input dummy = 0);
	begin
		case (gDataWidth)
			1:                      GetAddressWidth = 13;
			2:                      GetAddressWidth = 12;
			3, 4:                   GetAddressWidth = 11;
			default:
			if (gDataWidth <= 9)    GetAddressWidth = 10; else
			if (gDataWidth <= 18)   GetAddressWidth =  9; else
			if (gDataWidth <= 36)   GetAddressWidth =  8; else
			if (gDataWidth <= 72)   GetAddressWidth =  7; else
									GetAddressWidth =  0;
		endcase
		if (cRamSize == 18)
			GetAddressWidth = GetAddressWidth + 1;
	end
	endfunction

	function integer GetDStep(input dummy = 0);
		if (gDataWidth <=  1)   GetDStep =  1;  else
		if (gDataWidth <=  2)   GetDStep =  2;  else
		if (gDataWidth <=  4)   GetDStep =  4;  else
		if (gDataWidth <=  9)   GetDStep =  8;  else
		if (gDataWidth <= 18)   GetDStep = 16;  else
		if (gDataWidth <= 36)   GetDStep = 32;  else
//      if (gDataWidth <= 72)   GetDStep = 64;  else
								GetDStep =  0;
	endfunction

	function [255:0] GetINIT(input integer iIndex);
		integer vContentPos, i;
	begin
		GetINIT = 256'b0;
		vContentPos = ((iIndex * 256) / cDStep) * gDataWidth;
		for (i = 0; i < 256 /*&& vContentPos < cContentSize*/; i = i + cDStep) begin
			GetINIT[i+:cDUsed] = gContent[vContentPos+:cDUsed];
			vContentPos = vContentPos + gDataWidth;
		end
	end
	endfunction

	function [255:0] GetINITP(input integer iIndex);
		integer vContentPos, i;
	begin
		GetINITP = 256'b0;
		if (cPStep > 0) begin
			vContentPos = ((iIndex * 256) / cPStep) * gDataWidth + cPUsed;
			for (i = 0; i < 256 /*&& vContentPos < cContentSize*/; i = i + cPStep) begin
				GetINITP[i+:cPUsed] = gContent[vContentPos+:cPUsed];
				vContentPos = vContentPos + gDataWidth;
			end
		end
	end
	endfunction

	////////////////////////////////////////////////////////////////////////////////////////////////

	// BRAM_SINGLE_MACRO: Single Port RAM
	BRAM_SINGLE_MACRO
	#(
		.BRAM_SIZE((cRamSize == 9) ? "9Kb" : (cRamSize == 18) ? "18Kb" : "invalid"), // Target BRAM, "9Kb" or "18Kb"
		.DEVICE("SPARTAN6"),            // Target Device: "VIRTEX5", "VIRTEX6", "SPARTAN6"
		.DO_REG(0),                     // Optional output register (0 or 1)
		//.INIT(36'h000000000),         // Initial values on output port
		.INIT_FILE ("NONE"),
		.WRITE_WIDTH(gDataWidth),       // Valid values are 1-36 (19-36 only valid when BRAM_SIZE="18Kb")
		.READ_WIDTH(gDataWidth),        // Valid values are 1-36 (19-36 only valid when BRAM_SIZE="18Kb")
		//.SRVAL(36'h000000000),        // Set/Reset value for port output
		//.WRITE_MODE("WRITE_FIRST"),   // "WRITE_FIRST", "READ_FIRST", or "NO_CHANGE"

		// The following INIT_xx declarations specify the initial contents of the RAM
		.INIT_00(GetINIT(8'h00)),
		.INIT_01(GetINIT(8'h01)),
		.INIT_02(GetINIT(8'h02)),
		.INIT_03(GetINIT(8'h03)),
		.INIT_04(GetINIT(8'h04)),
		.INIT_05(GetINIT(8'h05)),
		.INIT_06(GetINIT(8'h06)),
		.INIT_07(GetINIT(8'h07)),
		.INIT_08(GetINIT(8'h08)),
		.INIT_09(GetINIT(8'h09)),
		.INIT_0A(GetINIT(8'h0A)),
		.INIT_0B(GetINIT(8'h0B)),
		.INIT_0C(GetINIT(8'h0C)),
		.INIT_0D(GetINIT(8'h0D)),
		.INIT_0E(GetINIT(8'h0E)),
		.INIT_0F(GetINIT(8'h0F)),
		.INIT_10(GetINIT(8'h10)),
		.INIT_11(GetINIT(8'h11)),
		.INIT_12(GetINIT(8'h12)),
		.INIT_13(GetINIT(8'h13)),
		.INIT_14(GetINIT(8'h14)),
		.INIT_15(GetINIT(8'h15)),
		.INIT_16(GetINIT(8'h16)),
		.INIT_17(GetINIT(8'h17)),
		.INIT_18(GetINIT(8'h18)),
		.INIT_19(GetINIT(8'h19)),
		.INIT_1A(GetINIT(8'h1A)),
		.INIT_1B(GetINIT(8'h1B)),
		.INIT_1C(GetINIT(8'h1C)),
		.INIT_1D(GetINIT(8'h1D)),
		.INIT_1E(GetINIT(8'h1E)),
		.INIT_1F(GetINIT(8'h1F)),
		// The next set of INIT_xx are for "18Kb" configuration only
		.INIT_20(GetINIT(8'h20)),
		.INIT_21(GetINIT(8'h21)),
		.INIT_22(GetINIT(8'h22)),
		.INIT_23(GetINIT(8'h23)),
		.INIT_24(GetINIT(8'h24)),
		.INIT_25(GetINIT(8'h25)),
		.INIT_26(GetINIT(8'h26)),
		.INIT_27(GetINIT(8'h27)),
		.INIT_28(GetINIT(8'h28)),
		.INIT_29(GetINIT(8'h29)),
		.INIT_2A(GetINIT(8'h2A)),
		.INIT_2B(GetINIT(8'h2B)),
		.INIT_2C(GetINIT(8'h2C)),
		.INIT_2D(GetINIT(8'h2D)),
		.INIT_2E(GetINIT(8'h2E)),
		.INIT_2F(GetINIT(8'h2F)),
		.INIT_30(GetINIT(8'h30)),
		.INIT_31(GetINIT(8'h31)),
		.INIT_32(GetINIT(8'h32)),
		.INIT_33(GetINIT(8'h33)),
		.INIT_34(GetINIT(8'h34)),
		.INIT_35(GetINIT(8'h35)),
		.INIT_36(GetINIT(8'h36)),
		.INIT_37(GetINIT(8'h37)),
		.INIT_38(GetINIT(8'h38)),
		.INIT_39(GetINIT(8'h39)),
		.INIT_3A(GetINIT(8'h3A)),
		.INIT_3B(GetINIT(8'h3B)),
		.INIT_3C(GetINIT(8'h3C)),
		.INIT_3D(GetINIT(8'h3D)),
		.INIT_3E(GetINIT(8'h3E)),
		.INIT_3F(GetINIT(8'h3F)),
		// The next set of INITP_xx are for the parity bits
		.INITP_00(GetINITP(8'h00)),
		.INITP_01(GetINITP(8'h01)),
		.INITP_02(GetINITP(8'h02)),
		.INITP_03(GetINITP(8'h03)),
		// The next set of INIT_xx are valid when configured as 18Kb
		.INITP_04(GetINITP(8'h04)),
		.INITP_05(GetINITP(8'h05)),
		.INITP_06(GetINITP(8'h06)),
		.INITP_07(GetINITP(8'h07))
	)
	BRAM
	(
		.RST(iReset),           // 1-bit input reset
		.CLK(iClock),           // 1-bit input clock

		.ADDR(sAddress),        // Input address, width defined by read/write port depth
		.DO(oData),             // Output data, width defined by READ_WIDTH parameter
		.DI({gDataWidth{1'b0}}),// Input data port, width defined by WRITE_WIDTH parameter

		.EN(1'b1),              // 1-bit input RAM enable
		.REGCE(1'b1),           // 1-bit input output register enable
		.WE(1'b0)               // Input write enable, width defined by write port depth
	);

endmodule

//**************************************************************************************************

module GenericROM
(
	input                       iClock,
	input                       iReset,
	input   [gAddressWidth-1:0] iAddress,
	output  [gDataWidth-1:0]    oData
);

	parameter integer                   gAddressWidth   = 1;
	parameter integer                   gDataWidth      = 1;
	parameter [cContentSize - 1 : 0]    gContent        = 1'b0;

	localparam                          cRamSize        = GetRamSize(0);
	localparam                          cContentSize    = (2 ** gAddressWidth) * gDataWidth;
	localparam                          cGranularity    = GetGranularity(0);
	localparam                          cBlockSize      = (2 ** gAddressWidth) * cGranularity;
	localparam                          cNumSlices      = (gDataWidth + cGranularity - 1) / cGranularity;

	function integer GetRamSize(input dummy = 0);
		if (cContentSize <= 9 * 1024 && gDataWidth <= 18)
			GetRamSize = 9;
		else if (cContentSize <= 18 * 1024 && gDataWidth <= 36)
			GetRamSize = 18;
		else GetRamSize = 0;
	endfunction

	function integer GetGranularity(input dummy = 0);
		if (gAddressWidth <= 9)
			GetGranularity = 36;
		else case (gAddressWidth)
			10:         GetGranularity = 18;
			11:         GetGranularity =  9;
			12:         GetGranularity =  4;
			13:         GetGranularity =  2;
			14:         GetGranularity =  1;
			default:    GetGranularity =  0;
		endcase;
	endfunction;

	function integer GetWidth(input integer iSlice);
	begin
		GetWidth = gDataWidth - (iSlice * cGranularity);
		if (GetWidth > cGranularity)
			GetWidth = cGranularity;
	end
	endfunction;

//  function [2 ** gAddressWidth * GetWidth(iSlice) - 1 : 0] GetContent(input integer iSlice);
	function [cBlockSize - 1 : 0] GetContent(input integer iSlice);
		localparam  [cBlockSize * cNumSlices - 1 : 0]   aContent = gContent;
//      localparam  cWidth = GetWidth(iSlice);
		integer     cWidth;
		integer     vPosIn, vPosOut;
	begin
		cWidth = GetWidth(iSlice);
		GetContent = 1'b0;

		vPosIn  = iSlice * cGranularity;
		vPosOut = 0;

		while (vPosOut < cBlockSize) begin
			GetContent[vPosOut+:cGranularity] = aContent[vPosIn+:cGranularity];
			vPosOut = vPosOut + cWidth;
			vPosIn  = vPosIn  + gDataWidth;
		end

	end
	endfunction

	////////////////////////////////////////////////////////////////////////////////////////////////

	generate

		genvar i;

		if (cRamSize > 0)

			InternalROM
			#(
				.gAddressWidth(gAddressWidth),
				.gDataWidth(gDataWidth),
				.gContent(gContent)
			)
			Flat
			(
				.iReset(iReset),
				.iClock(iClock),
				.iAddress(iAddress),
				.oData(oData)
			);

		else begin: Cascaded

//          assert (cGranularity > 0)
//              report "unsupported address width"
//              severity failure;

			for (i = 0; i < cNumSlices; i = i + 1)
			begin : Slice
				InternalROM
				#(
					.gAddressWidth(gAddressWidth),
					.gDataWidth(GetWidth(i)),
					.gContent(GetContent(i))
				)
				Slice
				(
					.iReset(iReset),
					.iClock(iClock),
					.iAddress(iAddress),
					.oData(oData[i*cGranularity+:GetWidth(i)])
				);
			end

		end

	endgenerate

endmodule

//**************************************************************************************************
//**************************************************************************************************
