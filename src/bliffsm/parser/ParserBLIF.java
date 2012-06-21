package bliffsm.parser;

import java.io.*;
import java.util.Map.Entry;

import bliffsm.data.FSM;

class TextParserException extends Exception {
	
	private int		lineNumber;
	
	private static String makeSuperMessage(String fileName, Integer lineNumber, String message)
	{
		String superMsg = fileName + ":" + lineNumber.toString() + ": ";
		superMsg += message;
		return superMsg;
	}
	
	public TextParserException(String fileName, int lineNumber, String message, Throwable cause)
	{
		super(makeSuperMessage(fileName, lineNumber, message), cause);
		this.lineNumber	= lineNumber;
	}
	public TextParserException(String message)
	{
		super(message);
		this.lineNumber = -1;
	}

	public int	getLineNumber()	{ return this.lineNumber;	}
}

public class ParserBLIF implements Parser {

	private	String			fileName			= null;
	private	BufferedReader	file 				= null;
	private String			pendingStatement 	= null;
	private int				currentLineNumber	= 0;
	private FSM				fsm					= null;

	public	ParserBLIF(String fileName)
	{
		this.fileName = fileName;
	}

	private void warn(String message)
	{
		TextParserException e = new TextParserException(fileName, currentLineNumber, "warning: " + message, null);
		System.err.println(e.getMessage());
	}
	private void error(String message) throws TextParserException
	{
		TextParserException e = new TextParserException(fileName, currentLineNumber, "error: " + message, null);
		System.err.println(e.getMessage());
		throw(e);
	}

	private boolean checkCharacterSet(String text, String characterSet)
	{
		// TODO: eleganter moeglich? so evtl. schneller als mit regexp
		for (int i = 0; i < text.length(); ++i) {
			if (characterSet.indexOf(text.charAt(i)) < 0) {
				return false;
			}
		}
		
		return true;
		
/*		for (int i = 0; i < characterSet.length(); ++i) {
			text.replace(characterSet.charAt(i), ' ');
		}
		
		return text.trim().equals("");
*/	}
	
	private	String readStatement() throws IOException
	{
		String statement = this.pendingStatement;
		this.pendingStatement = null;
		
		if (null == statement) {
			
			String 	line;
			int		i;
			
			statement = "";
			
			while ((line = file.readLine()) != null) {

				currentLineNumber++;
				line = line.trim();
				
				if ((i = line.indexOf('#')) >= 0) {
					line = line.substring(0, i);
				}
				
				if (statement.endsWith("\\")) {
					statement = statement.substring(0, statement.length() - 1).concat(line);
				} else {
					statement = line;
				}

				if (!statement.isEmpty() && !statement.endsWith("\\")) {
					break;
				}
			}
			
			if (statement.endsWith("\\")) {
				statement = statement.substring(0, statement.length() - 1);
			}
				
			if (statement.isEmpty()) {
				statement = null;
			}
		}
			
		return statement;
	}
	
	private void pushbackStatement(String statement)
	{
		assert(pendingStatement == null);
		pendingStatement = statement;
	}

	private void parseKISSEpilogue() throws NumberFormatException, IOException, TextParserException
	{
		String statement;
		
		while (null != (statement = readStatement())) {
			
			String[] cmd = statement.split(" ");
			
			if (cmd[0].equals(".latch_order")) {
				// kann ignoriert werden
			}
			
			else if (cmd[0].equals(".code")) {
				
				if (!fsm.stateEncoding().containsKey(cmd[1])) {
					error("unknown state \"" + cmd[1] + "\"");
				} 
				if ((1 << cmd[2].length()) < fsm.stateEncoding().size()) {
					error("code size doesn't fit number of states");
				}
				if (!checkCharacterSet(cmd[2], "01")) {
					error("code contains invalid character(s)");
				}

				int code = Integer.parseInt(cmd[2], 2);
				
				if (fsm.stateNames().containsKey(code)) {
					error("code already used");
				}
				
				fsm.updateState(cmd[1], code);
			}
			
			else {
				pushbackStatement(statement);
				break;
			}			
		}		
	}
	
	private void parseKISS() throws NumberFormatException, IOException, TextParserException
	{
		int		numTerms = 0, numStates = 0;
		String	resetState = null;
		String	statement;
		int		i;
		
		while (null != (statement = readStatement())) {

			String[] cmd = statement.split(" ");

			if (cmd[0].startsWith(".")) {
			
				if (cmd[0].equals(".i")) {
					int numInputs = Integer.parseInt(cmd[1]); 
					if (fsm.inputIds().size() > 0) {
						if (numInputs != fsm.inputIds().size()) {
							error("number doesn't match model inputs");
						}
					} else {
						for (i = 0; i < numInputs; ++i) {
							fsm.addInput(i, "in" + i, i);
						}
					}
				}
				
				else if (cmd[0].equals(".o")) {
					int numOutputs = Integer.parseInt(cmd[1]); 
					if (fsm.outputIds().size() > 0) {
						if (numOutputs != fsm.outputIds().size()) {
							error("number doesn't match model outputs");
						}
					} else {
						for (i = 0; i < numOutputs; ++i) {
							fsm.addOutput(i, "out" + i, i);
						}
					}
				}
	
				else if (cmd[0].equals(".p")) {
					numTerms = Integer.parseInt(cmd[1]);
				}
	
				else if (cmd[0].equals(".s")) {
					numStates = Integer.parseInt(cmd[1]);
				}
				
				else if (cmd[0].equals(".r")) {
					resetState = cmd[1];
				}
				
				else if (cmd[0].equals(".end_kiss")) {
					
					if (fsm.stateEncoding().isEmpty()) {
						error("no transitions specified");
					}
					
					if (numStates > 0 && numStates != fsm.stateEncoding().size()) {
						error("number of used states doesn't match .s");
					}
					
					if (numTerms > 0 && numTerms != fsm.transitions().size()) {
						error("number of terms doesn't match .p");
					}
					
					if (null == resetState) {
						fsm.setResetState(fsm.stateEncoding().firstKey());
					} else {
						if (!fsm.stateEncoding().containsKey(resetState)) {
							error("specified reset state isn't used");
						}
						fsm.setResetState(resetState);
					}
					
					parseKISSEpilogue();
					break;
				}
	
				else {
					error("unknown statement");
				}
				
			// !cmd[0].startsWith(".")
			} else {
				
				if (fsm.inputIds().isEmpty()) {
					warn(".i statement not found (which is mandatory), taking information from first transition term");
					for (i = 0; i < cmd[0].length(); ++i) {
						fsm.addInput (i, "in" + i, i);
					}
				} else if (cmd[0].length() != fsm.inputIds().size()) {
					error("number of inputs doesn't match .i");
				}
				
				if (fsm.outputIds().isEmpty()) {
					warn(".o statement not found (which is mandatory), taking information from first transition term");
					for (i = 0; i < cmd[3].length(); ++i) {
						fsm.addOutput (i, "out" + i, i);
					}
				} else if (cmd[3].length() != fsm.outputIds().size()) {
					error("number of outputs doesn't match .o");
				}

				if (!checkCharacterSet(cmd[0], "01-")) {
					error("invalid input specification");
				}
					
				if (!checkCharacterSet(cmd[3], "01-")) {
					error("invalid output specification");
				}
					
				if (!fsm.stateEncoding().containsKey(cmd[1])) {
					fsm.updateState(cmd[1], -1 /*- fsm.stateEncoding().size()*/);
				}
				
				if (!fsm.stateEncoding().containsKey(cmd[2])) {
					fsm.updateState(cmd[2], -1 /*- fsm.stateEncoding().size()*/);
				}

				// TODO: intern auch '-' verwenden
				cmd[0].replace('-', 'x');
				cmd[3].replace('-', 'x');
				
				fsm.addTransition(cmd[1], cmd[0], cmd[2], cmd[3]);
			}
		}
	}
	
	private void parseModel() throws IOException, TextParserException
	{
		String	clockName = null;
		String	statement;
		int		i;
		
		while (null != (statement = readStatement())) {

			String[] cmd = statement.split(" ");

			if (cmd[0].equals(".inputs")) {
				for (i = 1; i < cmd.length; ++i) {
					if (fsm.inputIdToName().containsValue(cmd[i])) {
						error("multiple usage of same name");
					}
					fsm.addInput(i, cmd[i], i);
				}
			}
			
			else if (cmd[0].equals(".outputs")) {
				for (i = 1; i < cmd.length; ++i) {
					if (fsm.outputIdToName().containsValue(cmd[i])) {
						error("multiple usage of same name");
					}
					fsm.addOutput(i, cmd[i], i);
				}				
			}
			
			else if (cmd[0].equals(".clock")) {
				boolean warn = (cmd.length > 2  || clockName != null) ? true : false;
				if (clockName == null) {
					clockName = cmd[1];
				}
				if (warn) {
					warn("multiple clock signals found, taking \"" + clockName + "\" for FSM");
				}
			}

			else if (cmd[0].equals(".subckt")) {
				warn(".subckt statement skipped");
			}
			
			else if (cmd[0].equals(".start_kiss")) {
				parseKISS();
			}
			
			else if (cmd[0].equals(".end")) {
				break;
			}

			// TODO: Wohlgeformtheit pruefen (zumindest bzgl. ausgewerteter Kommandos)?
			// z.B. .model, .search
		}
	}
	
	public FSM parse ()
	{
		String	modelName = this.fileName;
		
		// TODO: Fehler weitergeben
		try {
		try {
		
			if (this.fileName == null) {
				this.file = new BufferedReader(new InputStreamReader(System.in));
			} else {
				this.file = new BufferedReader(new FileReader(this.fileName));
			}
			this.currentLineNumber = 0;
			this.fsm = new FSM();
		
			String statement;
			
			while (null != (statement = readStatement())) {
				
				String[] cmd = statement.split(" ");
				
				if (cmd[0].equals(".search")) {
					warn(".search statement skipped");
					continue;
				}
				
				if (cmd[0].equals(".model")) {
					modelName = cmd[1];
				} else {
					pushbackStatement(statement);
				}

				System.err.println("evaluating model \"" + modelName + "\" ...");
				parseModel();
				
				if (null != (statement = readStatement())) {
					warn("remaining file content skipped");
				}
				
				break;
			}
			
			file.close();

			// TODO: mit check an sinnvolle Stelle schieben
			{
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
			
			return this.fsm;
		} 

		// catch cmd[i] access
		catch (ArrayIndexOutOfBoundsException e) {
			error("invalid number of arguments");
		}

		catch (NumberFormatException e) {
			error("invalid number format");
		}
		
		finally {
			this.fsm = null;
		}
		
		}
		
		catch (Exception e) {
			System.err.println(e);
		}
		
		return this.fsm;
	}							
}
