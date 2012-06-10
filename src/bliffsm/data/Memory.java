package bliffsm.data;

public class Memory {
	private int address_bits = 0;
	private int data_bits    = 0;

	private Memory ()
	{
	}

	public Memory (int adr_bits, int data_bits)
	{
		this.address_bits = adr_bits;
		this.data_bits    = data_bits;
	}

}
