import bliffsm.data.*;
import bliffsm.parser.*;
import bliffsm.generator.*;
import bliffsm.printer.*;

public class Main {
	public static void main (String[] args)
	{
		//Parser parser = new ParserTest (2);
		//Parser parser = new ParserBLIF ("../blif/test.blif");
		Parser parser = new ParserBLIF ("../blif/fsmexamples/bbara.kiss2");
		FSM    fsm    = null;

		System.err.println ("generating test-FSM ...");
		try {
			fsm = parser.parse ();
		} catch (Exception e) {
			System.exit(1);
		}
		System.err.println (fsm);

		if (fsm.check ()) {
			System.err.println ("FSM seems to be correctly specified.");
		} else {
			System.err.println ("FSM is not valid!");
		}

		System.err.println ("encoding states");
		StateEncoder encoder = new StateEncoderSimple ();
		encoder.encodeStates (fsm);
		System.err.println (fsm);
		System.err.println ("generating Memory from FSM");
		Generator generator = new GeneratorSimple (fsm);
		Memory    mem       = generator.generate();
		System.err.println ("Memory content:");
		System.err.println (mem);

		//System.err.println ("printing Memfile:");
		//Printer printer  = new PrinterMemfile (fsm, mem);
		System.err.println ("printing Verilog-FSM:");
		//Printer printer  = new PrinterVerilogGeneric (fsm, mem, "fsm");
		Printer printer  = new PrinterVerilog (fsm, mem, "fsm");
		String  outfile  = printer.print();

		System.out.println (outfile);
	}
}
