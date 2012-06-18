package bliffsm.parser;

import bliffsm.data.FSM;

public class ParserTest implements Parser {
	private int fsm_id = 1;

	public ParserTest ()
	{
		fsm_id = 1;
	}

	public ParserTest (int fsm_id)
	{
		this.fsm_id = fsm_id;
	}

	public FSM parse ()
	{
		if (fsm_id == 2) {
			return fsm_2 ();
		} else {
			return fsm_1 ();
		}
	}

	private FSM fsm_1 ()
	{
		FSM result = new FSM ();

		result.addInput (0, "fsm_input", 0);
		result.addOutput (0, "fsm_output", 0);

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

	private FSM fsm_2 ()
	{
		FSM result = new FSM ();

		result.addInput (0, "input0", 0);
		result.addInput (1, "input1", 1);
		result.addOutput (0, "output0", 0);
		result.addOutput (1, "output1", 1);

		result.addState ("st0", 0);
		result.addState ("st1", 1);
		result.addState ("st2", 2);
		result.addState ("st3", 3);

		result.setResetState ("st0");

		result.addTransition ("st0", "0x", "st0", "0x");
		result.addTransition ("st0", "1x", "st1", "0x");
		result.addTransition ("st1", "0x", "st2", "0x");
		result.addTransition ("st1", "1x", "st1", "0x");
		result.addTransition ("st2", "0x", "st0", "0x");
		result.addTransition ("st2", "1x", "st3", "1x");
		result.addTransition ("st3", "0x", "st2", "0x");
		result.addTransition ("st3", "1x", "st1", "0x");


		return result;
	}
}
