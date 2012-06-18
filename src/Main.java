import bliffsm.data.*;
import bliffsm.parser.*;
import bliffsm.generator.*;
import bliffsm.printer.*;

public class Main {
	public static void main (String[] args)
	{
		Parser parser = new ParserTest (2);
		FSM    fsm;

		System.err.println ("generating test-FSM ...");
		fsm = parser.parse ();
		System.err.println (fsm);

		if (fsm.check ()) {
			System.err.println ("FSM seems to be correctly specified.");
		} else {
			System.err.println ("FSM is not valid!");
		}

		System.err.println ("generating Memory from FSM");
		Generator generator = new GeneratorSimple (fsm);
		Memory    mem       = generator.generate();
		System.err.println ("Memory content:");
		System.err.println (mem);

		//System.err.println ("printing Memfile:");
		//Printer printer  = new PrinterMemfile (fsm, mem);
		System.err.println ("printing Verilog-FSM:");
		Printer printer  = new PrinterVerilogGeneric (fsm, mem, "fsm");
		String  outfile  = printer.print();

		System.out.println (outfile);
	}
}
