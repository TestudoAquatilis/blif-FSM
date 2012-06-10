package bliffsm.printer;

import bliffsm.data.*;

public abstract class Printer {
	protected FSM    fsm;
	protected Memory memory;

	public abstract String print ();

	protected void encodeAddressToHex (StringBuilder buffer, int address, int digits)
	{
		String val = Integer.toHexString (address);

		for (int i = val.length (); i < digits; i++) buffer.append ('0');
		buffer.append (val.toUpperCase ());
	}

	protected void encodeDataToHex (StringBuilder buffer, String data, int digits)
	{
		int i_position = 0;
		int first_step = data.length () % 4;

		if (first_step > 0) {
			String digit = data.substring (0, first_step);

			int value = Integer.parseInt (digit, 2);

			String hex_digit = Integer.toHexString (value);

			buffer.append (hex_digit.toUpperCase ());

			i_position = first_step;
		}

		for (; i_position < 4*digits; i_position += 4) {
			String digit = data.substring (i_position, i_position + 4);

			int value = Integer.parseInt (digit, 2);

			String hex_digit = Integer.toHexString (value);

			buffer.append (hex_digit.toUpperCase ());
		}
	}
}
