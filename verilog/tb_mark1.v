
module tb_mark1 (
);

	reg clk;
	reg reset;
	reg in0;
	reg in1;
	reg in2;
	reg in3;
	reg in4;
	wire out0;
	wire out1;
	wire out2;
	wire out3;
	wire out4;
	wire out5;
	wire out6;
	wire out7;
	wire out8;
	wire out9;
	wire out10;
	wire out11;
	wire out12;
	wire out13;
	wire out14;
	wire out15;

	wire [0:15] out_vec;

	assign out_vec[0]  = out0;
	assign out_vec[1]  = out1;
	assign out_vec[2]  = out2;
	assign out_vec[3]  = out3;
	assign out_vec[4]  = out4;
	assign out_vec[5]  = out5;
	assign out_vec[6]  = out6;
	assign out_vec[7]  = out7;
	assign out_vec[8]  = out8;
	assign out_vec[9]  = out9;
	assign out_vec[10] = out10;
	assign out_vec[11] = out11;
	assign out_vec[12] = out12;
	assign out_vec[13] = out13;
	assign out_vec[14] = out14;
	assign out_vec[15] = out15;

	fsm fsm_i (
		.clk(clk),
		.reset(reset),
		.in0(in0),
		.in1(in1),
		.in2(in2),
		.in3(in3),
		.in4(in4),
		.out0(out0),
		.out1(out1),
		.out2(out2),
		.out3(out3),
		.out4(out4),
		.out5(out5),
		.out6(out6),
		.out7(out7),
		.out8(out8),
		.out9(out9),
		.out10(out10),
		.out11(out11),
		.out12(out12),
		.out13(out13),
		.out14(out14),
		.out15(out15)
	);


	parameter CLKPERIOD = 100;

	initial clk = 1'b1;
	always #(CLKPERIOD/2) clk = !clk;

	initial begin
		reset = 1'b1;
		in0   = 1'b0;
		in1   = 1'b0;
		in2   = 1'b0;
		in3   = 1'b0;
		in4   = 1'b0;
		#CLKPERIOD
		reset = 1'b0;
	end

	task goto_reset_state;
		begin
			$display("   goto reset state...");
			reset = 1'b1;
			#CLKPERIOD
			reset = 1'b0;
		end
	endtask

	task goto_state_1;
		begin
			goto_reset_state();
			$display("   goto state 1...");
			in0 = 1'b0;
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b", $time, out_vec);
				$finish();
			end
		end
	endtask

	// state2 unreachable...

	task goto_state_3;
		begin
			goto_state_1();
			$display("   goto state 3...");
			in0 = 1'b1;
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b", $time, out_vec);
				$finish();
			end
		end
	endtask

	task goto_state_4;
		begin
			goto_state_3();
			$display("   goto state 4...");
			in0 = 1'b1;
			#CLKPERIOD
			if (out0 != 1'b1 || out1 != 1'b0 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b1) begin
				$display("error @%d - output is %b", $time, out_vec);
				$finish();
			end
		end
	endtask

	task goto_state_5;
		begin
			goto_state_4();
			$display("   goto state 5...");
			in0 = 1'b1;
			in2 = 1'b0;
			in3 = 1'b0;
			in4 = 1'b0;
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b", $time, out_vec);
				$finish();
			end
		end
	endtask

	task goto_state_6;
		begin
			goto_state_4();
			$display("   goto state 6...");
			in0 = 1'b1;
			in2 = 1'b0;
			in3 = 1'b0;
			in4 = 1'b1;
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b", $time, out_vec);
				$finish();
			end
		end
	endtask

	task goto_state_7;
		begin
			goto_state_4();
			$display("   goto state 7...");
			in0 = 1'b1;
			in2 = 1'b0;
			in3 = 1'b1;
			in4 = 1'b0;
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b", $time, out_vec);
				$finish();
			end
		end
	endtask

	task goto_state_8;
		begin
			goto_state_4();
			$display("   goto state 8...");
			in0 = 1'b1;
			in2 = 1'b0;
			in3 = 1'b1;
			in4 = 1'b1;
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b", $time, out_vec);
				$finish();
			end
		end
	endtask

	task goto_state_9;
		begin
			goto_state_4();
			$display("   goto state 9...");
			in0 = 1'b1;
			in2 = 1'b1;
			in3 = 1'b0;
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b", $time, out_vec);
				$finish();
			end
		end
	endtask

	task goto_state_10;
		begin
			goto_state_4();
			$display("   goto state 10...");
			in0 = 1'b1;
			in2 = 1'b1;
			in3 = 1'b1;
			in4 = 1'b0;
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b", $time, out_vec);
				$finish();
			end
		end
	endtask

	task goto_state_11;
		begin
			goto_state_10();
			$display("   goto state 11...");
			in0 = 1'b1;
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0 || out10 != 1'b1 || out11 != 1'b0 || out12 != 1'b0 || out13 != 1'b0 || out14 != 1'b0 || out15 != 1'b0) begin
				$display("error @%d - output is %b", $time, out_vec);
				$finish();
			end
		end
	endtask

	task goto_state_12;
		begin
			goto_state_11();
			$display("   goto state 12...");
			in0 = 1'b1;
			in1 = 1'b1;
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b", $time, out_vec);
				$finish();
			end
		end
	endtask

	task goto_state_13;
		begin
			goto_state_4();
			$display("   goto state 13...");
			in0 = 1'b1;
			in2 = 1'b1;
			in3 = 1'b1;
			in4 = 1'b1;
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b", $time, out_vec);
				$finish();
			end
		end
	endtask

	task goto_state_14;
		begin
			goto_state_13();
			$display("   goto state 14...");
			in0 = 1'b1;
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b", $time, out_vec);
				$finish();
			end
		end
	endtask

	/*      
	// for icarus verilog ...
	initial begin
		$dumpfile("test.vcd");
		$dumpvars(0, fsm_i);
	end
	*/

	integer i;
	initial begin
		#(1.5*CLKPERIOD)
		// start
		
		// state 0 unreachable...
		// 0---- state0 state1 -11---1-00------
		
		// check state1 -> state1
		// 0---- state1 state1 -11---1-00------
		$display("checking state1 -> state1 - %d", $time);
		goto_state_1();
		in0 = 1'b0;
		for (i = 0; i < 2**4; i = i + 1) begin
			$display(" check %d", i);
			in1 = i[3];
			in2 = i[2];
			in3 = i[1];
			in4 = i[0];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state1 - state1)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end
		$display("success.");

		// check state1 -> state3 -> state4
		// 1---- state1 state3 -11---1-00------
		// 1---- state3 state4 101---1-01------
		$display("checking state1 -> state3 -> state4 - %d", $time);
		for (i = 0; i < 2**4; i = i + 1) begin
			$display(" check %d", i);
			goto_state_1();
			in0 = 1'b1;
			in1 = i[3];
			in2 = i[2];
			in3 = i[1];
			in4 = i[0];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state1 - state3)", $time, out_vec);
				$finish();
			end
			#CLKPERIOD
			if (out0 != 1'b1 || out1 != 1'b0 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b1) begin
				$display("error @%d - output is %b (state3 - state4)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end
		$display("success.");

		// state 2 unreachable...
		// 0---- state2 state1 -11---1-00------
		// 1---- state2 state0 -11---1-00------

		//check state3 -> state4
		// 1---- state3 state4 101---1-01------
		$display("checking state3 -> state4 - %d", $time);
		for (i = 0; i < 2**4; i = i + 1) begin
			$display(" check %d", i);
			goto_state_3();
			in0 = 1'b1;
			in1 = i[3];
			in2 = i[2];
			in3 = i[1];
			in4 = i[0];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out0 != 1'b1 || out1 != 1'b0 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b1) begin
				$display("error @%d - output is %b (state3 - state4)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state3 -> state1
		// 0---- state3 state1 -11---1-00------
		$display("checking state3 -> state1 - %d", $time);
		for (i = 0; i < 2**4; i = i + 1) begin
			$display(" check %d", i);
			goto_state_3();
			in0 = 1'b0;
			in1 = i[3];
			in2 = i[2];
			in3 = i[1];
			in4 = i[0];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state3 - state1)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state4 -> state5 -> state14
		// 1-000 state4 state5 -11---1-00------
		// 1---- state5 state14 0011--1-00------
		$display("checking state4 -> state5 -> state14 - %d", $time);
		for (i = 0; i < 2**1; i = i + 1) begin
			$display(" check %d", i);
			goto_state_4();
			in0 = 1'b1;
			in1 = i[0];
			in2 = 1'b0;
			in3 = 1'b0;
			in4 = 1'b0;
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state4 - state5)", $time, out_vec);
				$finish();
			end
			#CLKPERIOD
			if (out0 != 1'b0 || out1 != 1'b0 || out2 != 1'b1 || out3 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state5 - state14)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state4 -> state6 -> state14
		// 1-001 state4 state6 -11---1-00------
		// 1---- state6 state14 00100-0-00000011
		$display("checking state4 -> state6 -> state14 - %d", $time);
		for (i = 0; i < 2**1; i = i + 1) begin
			$display(" check %d", i);
			goto_state_4();
			in0 = 1'b1;
			in1 = i[0];
			in2 = 1'b0;
			in3 = 1'b0;
			in4 = 1'b1;
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state4 - state6)", $time, out_vec);
				$finish();
			end
			#CLKPERIOD
			if (out0 != 1'b0 || out1 != 1'b0 || out2 != 1'b1 || out3 != 1'b0 || out4 != 1'b0 || out6 != 1'b0 || out_vec[8:15] != 8'b00000011) begin
				$display("error @%d - output is %b (state6 - state14)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state4 -> state7 -> state14
		// 1-010 state4 state7 -11---1-00------
		// 1---- state7 state14 001---1100------
		$display("checking state4 -> state7 -> state14 - %d", $time);
		for (i = 0; i < 2**1; i = i + 1) begin
			$display(" check %d", i);
			goto_state_4();
			in0 = 1'b1;
			in1 = i[0];
			in2 = 1'b0;
			in3 = 1'b1;
			in4 = 1'b0;
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state4 - state7)", $time, out_vec);
				$finish();
			end
			#CLKPERIOD
			if (out0 != 1'b0 || out1 != 1'b0 || out2 != 1'b1 || out6 != 1'b1 || out7 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state7 - state14)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state4 -> state8 -> state14
		// 1-011 state4 state8 -11---1-00------
		// 1---- state8 state14 010---1-00------
		$display("checking state4 -> state8 -> state14 - %d", $time);
		for (i = 0; i < 2**1; i = i + 1) begin
			$display(" check %d", i);
			goto_state_4();
			in0 = 1'b1;
			in1 = i[0];
			in2 = 1'b0;
			in3 = 1'b1;
			in4 = 1'b1;
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state4 - state8)", $time, out_vec);
				$finish();
			end
			#CLKPERIOD
			if (out0 != 1'b0 || out1 != 1'b1 || out2 != 1'b0 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state8 - state14)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state4 -> state9 -> state14
		// 1-10- state4 state9 -11---1-00------
		// 1---- state9 state14 001---1010000101
		$display("checking state4 -> state9 -> state14 - %d", $time);
		for (i = 0; i < 2**2; i = i + 1) begin
			$display(" check %d", i);
			goto_state_4();
			in0 = 1'b1;
			in1 = i[0];
			in2 = 1'b1;
			in3 = 1'b0;
			in4 = i[1];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state4 - state9)", $time, out_vec);
				$finish();
			end
			#CLKPERIOD
			if (out0 != 1'b0 || out1 != 1'b0 || out2 != 1'b1 || out_vec[6:15] != 10'b1010000101) begin
				$display("error @%d - output is %b (state9 - state14)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state4 -> state10 -> state11
		// 1-110 state4 state10 -11---1-00------
		// 1---- state10 state11 -11---1-00100000
		$display("checking state4 -> state10 -> state11 - %d", $time);
		for (i = 0; i < 2**1; i = i + 1) begin
			$display(" check %d", i);
			goto_state_4();
			in0 = 1'b1;
			in1 = i[0];
			in2 = 1'b1;
			in3 = 1'b1;
			in4 = 1'b0;
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state4 - state10)", $time, out_vec);
				$finish();
			end
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 ||  out_vec[8:15] != 8'b00100000) begin
				$display("error @%d - output is %b (state10 - state11)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state4 -> state13
		// 1-111 state4 state13 -11---1-00------
		// 1---- state13 state14 -11---1-00------
		// 1---- state14 state3 -110110-00------
		$display("checking state4 -> state13 -> state14 -> state3 - %d", $time);
		for (i = 0; i < 2**1; i = i + 1) begin
			$display(" check %d", i);
			goto_state_4();
			in0 = 1'b1;
			in1 = i[0];
			in2 = 1'b1;
			in3 = 1'b1;
			in4 = 1'b1;
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state4 - state13)", $time, out_vec);
				$finish();
			end
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state13 - state14)", $time, out_vec);
				$finish();
			end
			#CLKPERIOD
			if (out_vec[1:6] != 6'b110110 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state14 - state3)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state4 -> state1
		// 0---- state4 state1 -11---1-00------
		$display("checking state4 -> state1 - %d", $time);
		for (i = 0; i < 2**4; i = i + 1) begin
			$display(" check %d", i);
			goto_state_4();
			in0 = 1'b0;
			in1 = i[3];
			in2 = i[2];
			in3 = i[1];
			in4 = i[0];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state4 - state1)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state5 -> state14 -> state3
		// 1---- state5 state14 0011--1-00------
		$display("checking state5 -> state14 -> state3 - %d", $time);
		for (i = 0; i < 2**4; i = i + 1) begin
			$display(" check %d", i);
			goto_state_5();
			in0 = 1'b1;
			in1 = i[0];
			in2 = i[1];
			in3 = i[2];
			in4 = i[3];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out0 != 1'b0 || out1 != 1'b0 || out2 != 1'b1 || out3 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state5 - state14)", $time, out_vec);
				$finish();
			end
			#CLKPERIOD
			if (out_vec[1:6] != 6'b110110 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state14 - state3)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state5 -> state1
		// 0---- state5 state1 -11---1-00------
		$display("checking state5 -> state1 - %d", $time);
		for (i = 0; i < 2**4; i = i + 1) begin
			$display(" check %d", i);
			goto_state_5();
			in0 = 1'b0;
			in1 = i[3];
			in2 = i[2];
			in3 = i[1];
			in4 = i[0];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state5 - state1)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state6 -> state14 -> state3
		// 1---- state6 state14 00100-0-00000011
		$display("checking state6 -> state14 -> state3 - %d", $time);
		for (i = 0; i < 2**4; i = i + 1) begin
			$display(" check %d", i);
			goto_state_6();
			in0 = 1'b1;
			in1 = i[0];
			in2 = i[1];
			in3 = i[2];
			in4 = i[3];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out0 != 1'b0 || out1 != 1'b0 || out2 != 1'b1 || out3 != 1'b0 || out4 != 1'b0 || out6 != 1'b0 || out_vec[8:15] != 8'b00000011) begin
				$display("error @%d - output is %b (state6 - state14)", $time, out_vec);
				$finish();
			end
			#CLKPERIOD
			if (out_vec[1:6] != 6'b110110 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state14 - state3)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state6 -> state1
		// 0---- state6 state1 -11---1-00------
		$display("checking state6 -> state1 - %d", $time);
		for (i = 0; i < 2**4; i = i + 1) begin
			$display(" check %d", i);
			goto_state_6();
			in0 = 1'b0;
			in1 = i[3];
			in2 = i[2];
			in3 = i[1];
			in4 = i[0];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state6 - state1)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state7 -> state14 -> state3
		// 1---- state7 state14 001---1100------
		$display("checking state7 -> state14 -> state3 - %d", $time);
		for (i = 0; i < 2**4; i = i + 1) begin
			$display(" check %d", i);
			goto_state_7();
			in0 = 1'b1;
			in1 = i[0];
			in2 = i[1];
			in3 = i[2];
			in4 = i[3];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out0 != 1'b0 || out1 != 1'b0 || out2 != 1'b1 || out6 != 1'b1 || out7 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state7 - state14)", $time, out_vec);
				$finish();
			end
			#CLKPERIOD
			if (out_vec[1:6] != 6'b110110 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state14 - state3)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state7 -> state1
		// 0---- state7 state1 -11---1-00------
		$display("checking state7 -> state1 - %d", $time);
		for (i = 0; i < 2**4; i = i + 1) begin
			$display(" check %d", i);
			goto_state_7();
			in0 = 1'b0;
			in1 = i[3];
			in2 = i[2];
			in3 = i[1];
			in4 = i[0];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state7 - state1)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state8 -> state14 -> state3
		// 1---- state8 state14 010---1-00------
		$display("checking state8 -> state14 -> state3 - %d", $time);
		for (i = 0; i < 2**4; i = i + 1) begin
			$display(" check %d", i);
			goto_state_8();
			in0 = 1'b1;
			in1 = i[0];
			in2 = i[1];
			in3 = i[2];
			in4 = i[3];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out0 != 1'b0 || out1 != 1'b1 || out2 != 1'b0 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state8 - state14)", $time, out_vec);
				$finish();
			end
			#CLKPERIOD
			if (out_vec[1:6] != 6'b110110 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state14 - state3)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state8 -> state1
		// 0---- state8 state1 -11---1-00------
		$display("checking state8 -> state1 - %d", $time);
		for (i = 0; i < 2**4; i = i + 1) begin
			$display(" check %d", i);
			goto_state_8();
			in0 = 1'b0;
			in1 = i[3];
			in2 = i[2];
			in3 = i[1];
			in4 = i[0];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state8 - state1)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state9 -> state14 -> state3
		// 1---- state9 state14 001---1010000101
		$display("checking state9 -> state14 -> state3 - %d", $time);
		for (i = 0; i < 2**4; i = i + 1) begin
			$display(" check %d", i);
			goto_state_9();
			in0 = 1'b1;
			in1 = i[0];
			in2 = i[1];
			in3 = i[2];
			in4 = i[3];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out0 != 1'b0 || out1 != 1'b0 || out2 != 1'b1 || out_vec[6:15] != 10'b1010000101) begin
				$display("error @%d - output is %b (state9 - state14)", $time, out_vec);
				$finish();
			end
			#CLKPERIOD
			if (out_vec[1:6] != 6'b110110 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state14 - state3)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state9 -> state1
		// 0---- state9 state1 -11---1-00------
		$display("checking state9 -> state1 - %d", $time);
		for (i = 0; i < 2**4; i = i + 1) begin
			$display(" check %d", i);
			goto_state_9();
			in0 = 1'b0;
			in1 = i[3];
			in2 = i[2];
			in3 = i[1];
			in4 = i[0];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state9 - state1)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state10 -> state11
		// 1---- state10 state11 -11---1-00100000
		$display("checking state10 -> state11 - %d", $time);
		for (i = 0; i < 2**4; i = i + 1) begin
			$display(" check %d", i);
			goto_state_10();
			in0 = 1'b1;
			in1 = i[3];
			in2 = i[2];
			in3 = i[1];
			in4 = i[0];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out_vec[8:15] != 8'b00100000) begin
				$display("error @%d - output is %b (state10 - state11)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state10 -> state1
		// 0---- state10 state1 -11---1-00------
		$display("checking state10 -> state1 - %d", $time);
		for (i = 0; i < 2**4; i = i + 1) begin
			$display(" check %d", i);
			goto_state_10();
			in0 = 1'b0;
			in1 = i[3];
			in2 = i[2];
			in3 = i[1];
			in4 = i[0];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state10 - state1)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state11 -> state12 -> state13
		// 11--- state11 state12 -11---1-00------
		// 1---- state12 state13 -110110-00------
		$display("checking state11 -> state12 -> state13 - %d", $time);
		for (i = 0; i < 2**3; i = i + 1) begin
			$display(" check %d", i);
			goto_state_11();
			in0 = 1'b1;
			in1 = 1'b1;
			in2 = i[2];
			in3 = i[1];
			in4 = i[0];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state11 - state12)", $time, out_vec);
				$finish();
			end
			#CLKPERIOD
			if (out_vec[1:6] != 6'b110110 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state12 - state13)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state11 -> state13 -> state14 -> state3
		// 10--- state11 state13 -11---1-00------
		// 1---- state13 state14 -11---1-00------
		// 1---- state14 state3 -110110-00------
		$display("checking state11 -> state13 -> state14 -> state3 - %d", $time);
		for (i = 0; i < 2**3; i = i + 1) begin
			$display(" check %d", i);
			goto_state_11();
			in0 = 1'b1;
			in1 = 1'b0;
			in2 = i[2];
			in3 = i[1];
			in4 = i[0];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state11 - state13)", $time, out_vec);
				$finish();
			end
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state13 - state14)", $time, out_vec);
				$finish();
			end
			#CLKPERIOD
			if (out_vec[1:6] != 6'b110110 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state14 - state3)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state11 -> state1
		// 0---- state11 state1 -11---1-00------
		$display("checking state11 -> state1 - %d", $time);
		for (i = 0; i < 2**4; i = i + 1) begin
			$display(" check %d", i);
			goto_state_11();
			in0 = 1'b0;
			in1 = i[3];
			in2 = i[2];
			in3 = i[1];
			in4 = i[0];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state11 - state1)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state12 -> state13
		// 1---- state12 state13 -110110-00------
		$display("checking state12 -> state13 - %d", $time);
		for (i = 0; i < 2**4; i = i + 1) begin
			$display(" check %d", i);
			goto_state_12();
			in0 = 1'b1;
			in1 = i[3];
			in2 = i[2];
			in3 = i[1];
			in4 = i[0];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out_vec[1:6] != 6'b110110 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state12 - state13)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state12 -> state1
		// 0---- state12 state1 -11---1-00------
		$display("checking state12 -> state1 - %d", $time);
		for (i = 0; i < 2**4; i = i + 1) begin
			$display(" check %d", i);
			goto_state_12();
			in0 = 1'b0;
			in1 = i[3];
			in2 = i[2];
			in3 = i[1];
			in4 = i[0];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state12 - state1)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state13 -> state14 -> state3
		// 1---- state13 state14 -11---1-00------
		$display("checking state13 -> state14 -> state3 - %d", $time);
		for (i = 0; i < 2**4; i = i + 1) begin
			$display(" check %d", i);
			goto_state_13();
			in0 = 1'b1;
			in1 = i[3];
			in2 = i[2];
			in3 = i[1];
			in4 = i[0];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state13 - state14)", $time, out_vec);
				$finish();
			end
			#CLKPERIOD
			if (out_vec[1:6] != 6'b110110 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state14 - state3)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end


		//check state13 -> state1
		// 0---- state13 state1 -11---1-00------
		$display("checking state13 -> state1 - %d", $time);
		for (i = 0; i < 2**4; i = i + 1) begin
			$display(" check %d", i);
			goto_state_13();
			in0 = 1'b0;
			in1 = i[3];
			in2 = i[2];
			in3 = i[1];
			in4 = i[0];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state13 - state1)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state14 -> state3
		// 1---- state14 state3 -110110-00------
		$display("checking state14 -> state3 - %d", $time);
		for (i = 0; i < 2**4; i = i + 1) begin
			$display(" check %d", i);
			goto_state_14();
			in0 = 1'b1;
			in1 = i[3];
			in2 = i[2];
			in3 = i[1];
			in4 = i[0];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out_vec[1:6] != 6'b110110 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state14 - state3)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end

		//check state14 -> state1
		// 0---- state14 state1 -11---1-00------
		$display("checking state14 -> state1 - %d", $time);
		for (i = 0; i < 2**4; i = i + 1) begin
			$display(" check %d", i);
			goto_state_14();
			in0 = 1'b0;
			in1 = i[3];
			in2 = i[2];
			in3 = i[1];
			in4 = i[0];
			$display(" relevant transitions...");
			#CLKPERIOD
			if (out1 != 1'b1 || out2 != 1'b1 || out6 != 1'b1 || out8 != 1'b0 || out9 != 1'b0) begin
				$display("error @%d - output is %b (state14 - state1)", $time, out_vec);
				$finish();
			end
			$display(" success.");
		end


		// end
		$display("if you are here, everything tested seems to be fine...");
		$finish();
	end

endmodule
