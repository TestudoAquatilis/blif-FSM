import bliffsm.data.*;
import bliffsm.parser.*;
import bliffsm.generator.*;
import bliffsm.printer.*;

public class Main {
	public static void main (String[] args)
	{
		Parser parser = new ParserTest (1);
		FSM    fsm;

		System.out.println ("generating test-FSM ...");
		fsm = parser.parse ();
		System.out.println (fsm);

		if (fsm.check ()) {
			System.out.println ("FSM seems to be correctly specified.");
		} else {
			System.out.println ("FSM is not valid!");
		}

		System.out.println ("generating Memory from FSM");
		Generator generator = new GeneratorSimple (fsm);
		Memory    mem       = generator.generate();
		System.out.println ("Memory content:");
		System.out.println (mem);

		//System.out.println ("printing Memfile:");
		//Printer printer  = new PrinterMemfile (fsm, mem);
		System.out.println ("printing Verilog-FSM:");
		Printer printer  = new PrinterVerilogGeneric (fsm, mem, "fsm");
		String  memfile     = printer.print();

		System.out.println (memfile);
	}
}
