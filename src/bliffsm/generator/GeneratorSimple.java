package bliffsm.generator;

import bliffsm.data.*;
import java.lang.Math;
import java.util.*;

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
		int n_states   = fsm.stateEncoding().size ();
		int last_state = fsm.stateNames().lastKey ();
		int n_inputs   = fsm.inputIdToName().size ();
		int n_outputs  = fsm.outputIdToName().size ();

		int last_in_wire  = fsm.inputWireToId().lastKey ();
		int last_out_wire = fsm.outputWireToId().lastKey ();

		int n_state_bits = fsm.nStateBits ();

		int n_adr_bits  = Math.max (last_in_wire, n_inputs + n_state_bits);
		int n_data_bits = Math.max (last_out_wire, n_outputs + n_state_bits);

		Memory result = new Memory (n_adr_bits, n_data_bits);

		for (FSM.TransitionArgument i_transition : fsm.transitions().keySet ()) {
			String in  = i_transition.input ();
			String st  = i_transition.state ();
			FSM.TransitionValue val = fsm.transitions().get (i_transition);
			String nst = val.state ();
			String out = val.output ();

			String addr = encodeAddress (in, st, n_adr_bits, n_state_bits);
			String data = encodeData    (nst, out, n_data_bits, n_state_bits);

			memPut (result, addr, data);
		}

		return result;
	}

	private void memPut (Memory mem, String address, String data)
	{
		// zero xs in data
		data = data.replace ('x', '0');

		// expand xs in address to all cases
		LinkedList<Integer> addresses = new LinkedList<Integer> ();
		addresses.add (0);

		for (int i = 0; i < address.length (); ++i) {
			char digit = address.charAt (i);

			ListIterator<Integer> iter = addresses.listIterator (0);
			while (iter.hasNext ()) {
				Integer value = iter.next ();

				if (digit == '0') {
					iter.set (value << 1);
				} else if (digit == '1') {
					iter.set ((value << 1) | 1);
				} else {
					iter.set (value << 1);
					iter.add ((value << 1) | 1);
				}
			}
		}

		// put data to addresses
		for (Integer i_addr : addresses) {
			mem.put (i_addr, data);
		}
	}

	private String encodeAddress (String input, String state, int adr_bits, int state_bits)
	{
		StringBuilder result = new StringBuilder ();
		
		TreeMap <Integer, Integer> wire_to_id = fsm.inputWireToId ();

		// initial "xxxxx..."
		for (int i_bit = 0; i_bit < adr_bits; ++i_bit) {
			result.append ('x');
		}

		int state_enc = fsm.stateEncoding().get (state);

		// state bits
		{
		int i_bit = 0;
		for (int i_state_bit = 0; i_state_bit < state_bits; ++i_state_bit, ++i_bit) {
			while (wire_to_id.containsKey (i_bit)) i_bit++;

			int bit_val = state_enc % 2;
			state_enc  /= 2;

			result.setCharAt ((adr_bits - 1 - i_bit), (bit_val == 1 ? '1' : '0'));
		}}

		// input bits
		for (Integer i_bit : wire_to_id.keySet ()) {
			int input_bit = wire_to_id.get (i_bit);

			result.setCharAt ((adr_bits - 1 - i_bit), input.charAt (input_bit));
		}

		return result.toString ();
	}

	private String encodeData (String next_state, String output, int data_bits, int state_bits)
	{
		StringBuilder result = new StringBuilder ();

		TreeMap <Integer, Integer> wire_to_id = fsm.outputWireToId ();

		// initial "xxxxx..."
		for (int i_bit = 0; i_bit < data_bits; ++i_bit) {
			result.append ('x');
		}

		int state_enc = fsm.stateEncoding().get (next_state);

		// state bits
		{
		int i_bit = 0;
		for (int i_state_bit = 0; i_state_bit < state_bits; ++i_state_bit, ++i_bit) {
			while (wire_to_id.containsKey (i_bit)) i_bit++;

			int bit_val = state_enc % 2;
			state_enc  /= 2;

			result.setCharAt ((data_bits - 1 - i_bit), (bit_val == 1 ? '1' : '0'));
		}}

		// output bits
		for (Integer i_bit : wire_to_id.keySet ()) {
			int output_bit = wire_to_id.get (i_bit);

			result.setCharAt ((data_bits - 1 - i_bit), output.charAt (output_bit));
		}

		return result.toString ();
	}
}
