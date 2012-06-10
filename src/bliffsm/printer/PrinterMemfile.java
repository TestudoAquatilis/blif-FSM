package bliffsm.printer;

import bliffsm.data.*;

import java.util.*;

public class PrinterMemfile extends Printer {
	private PrinterMemfile ()
	{
	}

	public PrinterMemfile (FSM fsm, Memory memory)
	{
		this.fsm    = fsm;
		this.memory = memory;
	}

	public String print ()
	{
		StringBuilder result = new StringBuilder ();

		int adr_bits = memory.addressBits ();
		int dat_bits = memory.dataBits ();
		String[] mem_data = memory.memory ();

		int hex_adr_digits = (adr_bits % 4 == 0 ? adr_bits / 4 : adr_bits / 4 + 1);
		int hex_dat_digits = (dat_bits % 4 == 0 ? dat_bits / 4 : dat_bits / 4 + 1);

		int i_addr = 0;

		for (String i_data : mem_data) {
			result.append ('@');
			encodeAddressToHex (result, i_addr, hex_adr_digits);
			result.append (' ');
			encodeDataToHex (result, i_data, hex_dat_digits);
			result.append ('\n');
			i_addr ++;
		}

		return result.toString ();
	}
}
