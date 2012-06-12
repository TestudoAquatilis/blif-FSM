package bliffsm.printer;

import bliffsm.data.*;

import java.util.*;

public class PrinterMemfile extends Printer {
	private PrinterMemfile ()
	{
		super (null, null);
	}

	public PrinterMemfile (FSM fsm, Memory memory)
	{
		super (fsm, memory);
	}

	public String print ()
	{
		StringBuilder result = new StringBuilder ();

		String[] mem_data = memory.memory ();

		int i_addr = 0;

		for (String i_data : mem_data) {
			result.append ('@');
			encodeAddressToHex (result, i_addr);
			result.append (' ');
			encodeDataToHex (result, i_data);
			result.append ('\n');
			i_addr ++;
		}

		return result.toString ();
	}
}
