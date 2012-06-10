package bliffsm.data;

import java.util.*;

public class FSM {
	private TreeMap<String, Integer> state_encoding;
	private TreeMap<Integer, String> state_names;
	private String reset_state;
	private TreeMap<Integer, String>  input_id_to_name;
	private TreeMap<Integer, Integer> input_id_to_wire;
	private TreeMap<Integer, Integer> input_wire_to_id;
	private TreeMap<String, Integer>  input_name_to_id;
	private TreeMap<Integer, String>  output_id_to_name;
	private TreeMap<Integer, Integer> output_id_to_wire;
	private TreeMap<Integer, Integer> output_wire_to_id;
	private TreeMap<String, Integer>  output_name_to_id;
	private TreeMap<TransitionArgument, TransitionValue> transitions;


	private class TransitionArgument implements Comparable<TransitionArgument> {
		private String input;
		private String state;

		private TransitionArgument ()
		{
		}

		public TransitionArgument (String input, String state)
		{
			this.input = input;
			this.state = state;
		}

		public String input ()
		{
			return input;
		}

		public String state ()
		{
			return state;
		}

		public int compareTo (TransitionArgument other)
		{
			int comparation_state = this.state.compareTo (other.state);

			if (comparation_state != 0) return comparation_state;

			return this.input.compareTo (other.input);
		}

		public boolean equals (Object obj)
		{
			if (obj == this) return true;
			if (obj == null || obj.getClass() != this.getClass()) return false;

			TransitionArgument other = (TransitionArgument) obj;
			return (input.equals (other.input) && state.equals (other.state));
		}

		public int hashCode ()
		{
			return state.hashCode () + input.hashCode ();
		}
	}

	private class TransitionValue implements Comparable<TransitionValue> {
		private String output;
		private String state;

		private TransitionValue ()
		{
		}

		public TransitionValue (String output, String state)
		{
			this.output = output;
			this.state  = state;
		}

		public String output ()
		{
			return output;
		}

		public String state ()
		{
			return state;
		}

		public int compareTo (TransitionValue other)
		{
			int comparation_state = this.state.compareTo (other.state);

			if (comparation_state != 0) return comparation_state;

			return this.output.compareTo (other.output);
		}

		public boolean equals (Object obj)
		{
			if (obj == this) return true;
			if (obj == null || obj.getClass() != this.getClass()) return false;

			TransitionValue other = (TransitionValue) obj;
			return (output.equals (other.output) && state.equals (other.state));
		}

		public int hashCode ()
		{
			return state.hashCode () + output.hashCode ();
		}
	}

	public FSM ()
	{
		state_encoding    = new TreeMap<String, Integer> ();
		state_names       = new TreeMap<Integer, String> ();
		reset_state       = "";
		input_id_to_name  = new TreeMap<Integer, String> ();
		input_id_to_wire  = new TreeMap<Integer, Integer> ();
		input_wire_to_id  = new TreeMap<Integer, Integer> ();
		input_name_to_id  = new TreeMap<String, Integer> ();
		output_id_to_name = new TreeMap<Integer, String> ();
		output_id_to_wire = new TreeMap<Integer, Integer> ();
		output_wire_to_id = new TreeMap<Integer, Integer> ();
		output_name_to_id = new TreeMap<String, Integer> ();
		transitions       = new TreeMap<TransitionArgument, TransitionValue> ();
	}

	public void addState (String state, int encoding)
	{
		if (state == null || encoding < 0) throw new IllegalArgumentException ("");
		state_encoding.put (state, encoding);
		state_names.put (encoding, state);
	}

	public void setResetState (String state)
	{
		if (state == null) throw new IllegalArgumentException ("");
		reset_state = state;

		if (! state_encoding.containsKey (state)) {
			addState (state, 0);
		}
	}

	public void addInput (int id, String name, int wire)
	{
		if (id < 0) throw new IllegalArgumentException ("");

		if (wire < 0)     wire = id;
		if (name == null) name = Integer.toString(id);

		input_id_to_name.put (id, name);
		input_id_to_wire.put (id, wire);
		input_wire_to_id.put (wire, id);
		input_name_to_id.put (name, id);
	}

	public void addOutput (int id, String name, int wire)
	{
		if (id < 0) throw new IllegalArgumentException ("");

		if (wire < 0)     wire = id;
		if (name == null) name = Integer.toString(id);

		output_id_to_name.put (id, name);
		output_id_to_wire.put (id, wire);
		output_wire_to_id.put (wire, id);
		output_name_to_id.put (name, id);
	}

	public void addTransition (String state, String input, String nextState, String output)
	{
		if (state == null || input == null || nextState == null || output == null) throw new IllegalArgumentException ("");

		transitions.put (new TransitionArgument (input, state), new TransitionValue (output, state));
	}

	public String toString ()
	{
		StringBuilder result = new StringBuilder ();

		result.append ("States:\n");
		result.append ("  <name (encoding)>\n");

		for (String i_state_id : state_encoding.keySet ()) {
			result.append (" - " + i_state_id + " (" + state_encoding.get (i_state_id) + ")" + (i_state_id.equals (reset_state) ? " [reset-state]\n" : "\n"));
		}

		result.append ("\nInputs:\n");
		result.append ("  <id (name, wire)>\n");

		for (Integer i_input_id : input_id_to_name.keySet ()) {
			result.append (" - " + i_input_id + " (" + input_id_to_name.get (i_input_id) + ", " + input_id_to_wire.get (i_input_id) + ")\n");
		}

		result.append ("\nOutputs:\n");
		result.append ("  <id (name, wire)>\n");

		for (Integer i_output_id : output_id_to_name.keySet ()) {
			result.append (" - " + i_output_id + " (" + output_id_to_name.get (i_output_id) + ", " + output_id_to_wire.get (i_output_id) + ")\n");
		}

		result.append ("\nTransitions:\n");
		result.append ("  <in state -> next-state out>\n");

		for (TransitionArgument i_transition : transitions.keySet ()) {
			String in  = i_transition.input ();
			String st  = i_transition.state ();
			TransitionValue val = transitions.get (i_transition);
			String nst = val.state ();
			String out = val.output ();

			result.append ("   " + in + " " + st + " -> " + nst + " " + out + "\n");
		}

		return result.toString ();
	}
}
