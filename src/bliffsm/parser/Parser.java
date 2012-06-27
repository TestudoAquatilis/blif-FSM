package bliffsm.parser;

import bliffsm.data.FSM;

public interface Parser {
	public FSM parse () throws Exception;
}
