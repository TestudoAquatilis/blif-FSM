package bliffsm.printer;

import bliffsm.data.*;

import java.util.*;

public class PrinterVerilogGeneric extends Printer {
	private String module_name;

	private PrinterVerilogGeneric ()
	{
		super (null, null);
	}

	public PrinterVerilogGeneric (FSM fsm, Memory memory, String module)
	{
		super (fsm, memory);
		module_name = module;
	}

	public String print ()
	{
		StringBuilder result = new StringBuilder ();

		genHeader (result);

		genInputWiring (result);
		genOutputWiring (result);

		genStateTransition (result);
		genMemory (result);

		genFooter (result);

		return result.toString ();
	}

	private void genHeader (StringBuilder buffer)
	{
		buffer.append ("module ");
		buffer.append (module_name);
		buffer.append (" (\n\tinput clk,");
		buffer.append ("\n\tinput reset");

		// inputs
		for (String input_name : fsm.inputNameToId().keySet ()) {
			buffer.append (",\n\tinput ");
			buffer.append (input_name);
		}

		// outputs
		for (String output_name : fsm.outputNameToId().keySet ()) {
			buffer.append (",\n\toutput wire ");
			buffer.append (output_name);
		}
		
		buffer.append ("\n);\n\n");

		// regs and wires
		buffer.append ("wire [");
		buffer.append (memory.addressBits () - 1);
		buffer.append (" : 0] address_wire;\nreg  [");
		buffer.append (memory.dataBits () - 1);
		buffer.append (" : 0] data_reg;\n\nreg  [");
		buffer.append (fsm.nStateBits () - 1);
		buffer.append (" : 0] state_reg;\nwire [");
		buffer.append (fsm.nStateBits () - 1);
		buffer.append (" : 0] next_state;\n\n");
	}

	private void genFooter (StringBuilder buffer)
	{
		buffer.append ("endmodule\n");
	}

	private void genInputWiring (StringBuilder buffer)
	{
		TreeMap<Integer, String>  input_id_to_name = fsm.inputIdToName ();
		TreeMap<Integer, Integer> input_wire_to_id = fsm.inputWireToId ();

		int state_bit = 0;

		for (int i_wire = 0; i_wire < memory.addressBits (); i_wire++) {
			if (input_wire_to_id.containsKey (i_wire)) {
				buffer.append ("assign address_wire[")
					.append (i_wire)
					.append ("] = ")
					.append (input_id_to_name.get (input_wire_to_id.get (i_wire)))
					.append (";\n");
			} else if (state_bit < fsm.nStateBits ()) {
				buffer.append ("assign address_wire[")
					.append (i_wire)
					.append ("] = state_reg[")
					.append (state_bit)
					.append ("];\n");
				state_bit ++;
			} else {
				buffer.append ("assign address_wire[")
					.append (i_wire)
					.append ("] = 1'b0;\n");
			}
		}

		buffer.append ("\n\n");

	}

	private void genOutputWiring (StringBuilder buffer)
	{
		TreeMap<Integer, String>  output_id_to_name = fsm.outputIdToName ();
		TreeMap<Integer, Integer> output_wire_to_id = fsm.outputWireToId ();

		int state_bit = 0;

		for (int i_wire = 0; i_wire < memory.dataBits (); i_wire ++) {
			if (output_wire_to_id.containsKey (i_wire)) {
				buffer.append ("assign ")
					.append (output_id_to_name.get (output_wire_to_id.get (i_wire)))
					.append (" = data_reg[")
					.append (i_wire)
					.append ("];\n");
			} else if (state_bit < fsm.nStateBits ()) {
				buffer.append ("assign next_state [")
					.append (state_bit)
					.append ("] = data_reg[")
					.append (i_wire)
					.append ("];\n");
				state_bit ++;
			}
		}

		buffer.append ("\n\n");
	}

	private void genStateTransition (StringBuilder buffer)
	{
		int reset_state = fsm.stateEncoding().get (fsm.resetState ());

		buffer.append ("always @(posedge clk or posedge reset) begin\n")
			.append ("\tif (reset == 1'b1) begin\n")
			.append ("\t\tstate_reg <= ")
			.append (fsm.nStateBits ())
			.append ("'h")
			.append (Integer.toHexString (reset_state))
			.append (";\n\tend else begin\n")
			.append ("\t\tstate_reg <= next_state;\n")
			.append ("\tend\nend\n\n");
		

	}

	private void genMemory (StringBuilder buffer)
	{
		buffer.append ("always @(address_wire) begin\n\tcase (address_wire)\n");

		String[] mem_data = memory.memory ();

		int i_addr = 0;
		for (String i_data : mem_data) {
			buffer.append ("\t\t");
			buffer.append (memory.addressBits ());
			buffer.append ("'h");
			encodeAddressToHex (buffer, i_addr);

			buffer.append (": data_reg = ");
			buffer.append (memory.dataBits ());
			buffer.append ("'h");
			encodeDataToHex (buffer, i_data);

			buffer.append (";\n");
			i_addr ++;
		}

		buffer.append ("\t\tdefault: data_reg = ");
		buffer.append (memory.dataBits ());
		buffer.append ("'h");

		for (int i = 0; i < hex_dat_digits; i++) {
			buffer.append ('x');
		}

		buffer.append (";\n\tendcase\nend\n\n");
	}
}
