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
		genMemory (result);

		return result.toString ();
	}

	private void genHeader (StringBuilder buffer)
	{
		buffer.append ("module ");
		buffer.append (module_name);
		buffer.append (" (\n\tinput clk");

		// inputs
		for (String input_name : fsm.inputNameToId().keySet ()) {
			buffer.append (",\n\tinput ");
			buffer.append (input_name);
		}

		// outputs
		for (String output_name : fsm.outputNameToId().keySet ()) {
			buffer.append (",\n\toutput reg ");
			buffer.append (output_name);
		}
		
		buffer.append ("\n);\n\n");

		// regs and wires
		buffer.append ("wire [");
		buffer.append (memory.addressBits () - 1);
		buffer.append (" : 0] address_wire;\nreg  [");
		buffer.append (memory.dataBits () - 1);
		buffer.append (" : 0] data_reg;\n\n");


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
