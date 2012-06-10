import bliffsm.data.*;
import bliffsm.parser.*;
import bliffsm.generator.*;
import bliffsm.printer.*;

public class Main {
	public static void main (String[] args)
	{
		Parser parser = new ParserTest ();
		FSM    fsm;

		System.out.println ("generating test-FSM ...");
		fsm = parser.parse ();
		System.out.println (fsm);

		System.out.println ("generating Memory from FSM");
		Generator generator = new GeneratorSimple (fsm);
		Memory    mem       = generator.generate();

		System.out.println ("printing Memfile:");
		Printer memprinter  = new PrinterMemfile (fsm, mem);
		String  memfile     = memprinter.print();

		System.out.println (memfile);
	}
}
