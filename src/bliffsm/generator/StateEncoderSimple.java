package bliffsm.generator;

import bliffsm.data.*;
import java.util.Map.Entry;

public class StateEncoderSimple implements StateEncoder {
	
	private void warn(String message)
	{
		System.err.println("warning: " + message);
	}
	
	public void encodeStates(FSM fsm) {
		
		int code;
		
		code = fsm.stateEncoding().get(fsm.resetState());
		if (code < 0) {
			if (fsm.stateNames().containsKey(0)) {
				warn("can't use code 0 for reset state (" + fsm.resetState() + 
					") because it has been assigned to " + fsm.stateNames().get(0));
			} else {
				fsm.updateState(fsm.resetState(), 0);
			}
		} else if (code > 0) {
			warn("reset state doesn't use code 0");
		}
		
		code = 0;
		for (Entry<String, Integer> entry : fsm.stateEncoding().entrySet()) {
			if (entry.getValue() < 0) {
				for (; fsm.stateNames().containsKey(code); ++code);
				fsm.updateState(entry.getKey(), code);
			}
		}
	}
}
