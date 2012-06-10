package bliffsm.data;

import java.util.*;

public class Memory {
	private int address_bits = 0;
	private int data_bits    = 0;

	private String[] memory;
	private String   empty_value;

	private Memory ()
	{
	}

	public Memory (int adr_bits, int data_bits)
	{
		this.address_bits = adr_bits;
		this.data_bits    = data_bits;

		this.memory       = new String[1 << adr_bits];

		StringBuilder empty_val_gen = new StringBuilder ();
		for (int i = 0; i < data_bits; i++) {
			empty_val_gen.append ("0");
		}
		empty_value = empty_val_gen.toString ();

		Arrays.fill (memory, empty_value);
	}

	public void put (int address, String data)
	{
		if (address >= (1 << address_bits) || data.length () > data_bits) {
			throw new IllegalArgumentException ("Memory: values out of range");
		}

		memory[address] = data;
	}

	public String toString ()
	{
		StringBuilder result = new StringBuilder ();

		int i_addr = 0;

		for (String i_data : memory) {
			result.append (" 0b");
			String addr = Integer.toBinaryString (i_addr);

			for (int i = addr.length (); i < address_bits; i++) result.append ('0');
			result.append (addr);

			result.append (": ");
			result.append (i_data);
			result.append ('\n');

			i_addr ++;
		}

		return result.toString ();
	}
}
