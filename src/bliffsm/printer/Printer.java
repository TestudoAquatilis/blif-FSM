package bliffsm.printer;

import bliffsm.data.*;

public abstract class Printer {
	protected FSM    fsm;
	protected Memory memory;

	protected int hex_adr_digits;
	protected int hex_dat_digits;

	private Printer ()
	{
	}

	public Printer (FSM fsm, Memory memory)
	{
		this.fsm    = fsm;
		this.memory = memory;

		int adr_bits = memory.addressBits ();
		int dat_bits = memory.dataBits ();
		hex_adr_digits = (adr_bits % 4 == 0 ? adr_bits / 4 : adr_bits / 4 + 1);
		hex_dat_digits = (dat_bits % 4 == 0 ? dat_bits / 4 : dat_bits / 4 + 1);
	}

	public abstract String print ();

	protected void encodeAddressToHex (StringBuilder buffer, int address)
	{
		String val = Integer.toHexString (address);

		for (int i = val.length (); i < hex_adr_digits; i++) buffer.append ('0');
		buffer.append (val.toUpperCase ());
	}

	protected void encodeDataToHex (StringBuilder buffer, String data)
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

		for (; i_position <= 4*(hex_dat_digits-1); i_position += 4) {
			String digit = data.substring (i_position, i_position + 4);

			int value = Integer.parseInt (digit, 2);

			String hex_digit = Integer.toHexString (value);

			buffer.append (hex_digit.toUpperCase ());
		}
	}
}
