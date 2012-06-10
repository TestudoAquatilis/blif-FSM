package bliffsm.parser;

import bliffsm.data.FSM;

public class ParserTest implements Parser {
	public ParserTest ()
	{
	}

	public FSM parse ()
	{
		FSM result = new FSM ();

		result.addInput (0, "input", 0);
		result.addOutput (0, "output", 0);

		result.addState ("st0", 0);
		result.addState ("st1", 1);
		result.addState ("st2", 2);
		result.addState ("st3", 3);

		result.setResetState ("st0");

		result.addTransition ("st0", "0", "st0", "0");
		result.addTransition ("st0", "1", "st1", "0");
		result.addTransition ("st1", "0", "st2", "0");
		result.addTransition ("st1", "1", "st1", "0");
		result.addTransition ("st2", "0", "st0", "0");
		result.addTransition ("st2", "1", "st3", "1");
		result.addTransition ("st3", "0", "st2", "0");
		result.addTransition ("st3", "1", "st1", "0");

		return result;
	}
}
