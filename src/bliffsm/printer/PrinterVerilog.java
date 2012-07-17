package bliffsm.printer;

import bliffsm.data.*;

import java.util.*;

public class PrinterVerilog extends Printer {
	private String module_name;

	private PrinterVerilog ()
	{
		super(null, null);
	}

	public PrinterVerilog (FSM fsm, Memory memory, String module)
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

		genStateWiring (result);
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
		buffer.append (" : 0] address_wire;\nwire [");
		buffer.append (memory.dataBits () - 1);
		buffer.append (" : 0] data_wire;\n\nwire [");
		buffer.append (fsm.nStateBits () - 1);
		buffer.append (" : 0] state_wire;\nwire [");
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
					.append ("] = state_wire[")
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
					.append (" = data_wire[")
					.append (i_wire)
					.append ("];\n");
			} else if (state_bit < fsm.nStateBits ()) {
				buffer.append ("assign next_state [")
					.append (state_bit)
					.append ("] = data_wire[")
					.append (i_wire)
					.append ("];\n");
				state_bit ++;
			}
		}

		buffer.append ("\n\n");
	}

	private void genStateWiring (StringBuilder buffer)
	{
		int reset_state = fsm.stateEncoding().get (fsm.resetState ());

		buffer.append ("assign state_wire <= next_state;\n");
	}

	private void genMemory (StringBuilder buffer)
	{
		buffer.append ("InternalROM #(\n")
			.append ("\t.gAddressWidth (")
			.append (memory.addressBits())
			.append ("),\n")
			.append ("\t.gDataWidth (")
			.append (memory.dataBits())
			.append ("),\n")
			.append ("\t.gContent (")
			.append ((1 << memory.addressBits()) * memory.dataBits())
			.append ("'b");

		// content
		String[] mem_data = memory.memory ();
		for (int i_addr = mem_data.length - 1; i_addr >= 0; i_addr--) {
			String i_data = mem_data[i_addr];

			buffer.append (i_data);
		}

		buffer.append(")\n\t) int_rom_inst (\n")
			.append ("\t.iClock(clk),\n")
			.append ("\t.iReset(reset),\n")
			.append ("\t.iAddress(address_wire),\n")
			.append ("\t.oData(data_wire)\n")
			.append (");\n");
	}
}
