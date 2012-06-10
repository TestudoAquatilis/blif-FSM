package bliffsm.printer;

import bliffsm.data.*;

public class PrinterMemfile implements Printer {
	private FSM    fsm;
	private Memory memory;

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
		String result = "";

		// ... TODO

		return result;
	}
}
