package bliffsm.generator;

import bliffsm.data.*;

public class GeneratorSimple implements Generator {
	private FSM fsm;

	private GeneratorSimple ()
	{
	}

	public GeneratorSimple (FSM fsm)
	{
		this.fsm = fsm;
	}

	public Memory generate ()
	{
		Memory result = new Memory ();

		// ... TODO

		return result;
	}
}
