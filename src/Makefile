#
# define compiler and compiler flag variables
#

# JFLAGS = -g
#JFLAGS = -verbose
# JFLAGS = -Xlint:unchecked
JFLAGS =
JC = javac

OUTPUTJAR = bliffsm.jar
MANIFEST = Manifest.txt
MAINCLASS = Main


#
# CLASSES is a macro consisting of n words (one for each java source file)
#

CLASSES = \
	  bliffsm/data/FSM.java \
	  bliffsm/data/Memory.java \
	  bliffsm/parser/Parser.java \
	  bliffsm/parser/ParserTest.java \
	  bliffsm/parser/ParserBLIF.java \
	  bliffsm/generator/Generator.java \
	  bliffsm/generator/GeneratorSimple.java \
	  bliffsm/generator/StateEncoder.java \
	  bliffsm/generator/StateEncoderSimple.java \
	  bliffsm/printer/Printer.java \
	  bliffsm/printer/PrinterMemfile.java \
	  bliffsm/printer/PrinterVerilogGeneric.java \
	  bliffsm/printer/PrinterVerilog.java \
	  Main.java \



#
# Clear any default targets for building .class files from .java files; we 
# will provide our own target entry to do this in this makefile.
# make has a set of default targets for different suffixes (like .c.o) 
# Currently, clearing the default for .java.class is not necessary since 
# make does not have a definition for this target, but later versions of 
# make may, so it doesn't hurt to make sure that we clear any default 
# definitions for these
#

.SUFFIXES: .java .class


#
# Here is our target entry for creating .class files from .java files 
# This is a target entry that uses the suffix rule syntax:
#	DSTS:
#		rule
#  'TS' is the suffix of the target file, 'DS' is the suffix of the dependency 
#  file, and 'rule'  is the rule for building a target	
# '$*' is a built-in macro that gets the basename of the current target 
# Remember that there must be a < tab > before the command line ('rule') 
#

.java.class:
	$(JC) $(JFLAGS) $*.java

#
# the default make target entry
#

default: classes


#
# This target entry uses Suffix Replacement within a macro: 
# $(name:string1=string2)
# 	In the words in the macro named 'name' replace 'string1' with 'string2'
# Below we are replacing the suffix .java of all words in the macro CLASSES 
# with the .class suffix
#

classes: $(CLASSES:.java=.class)


#
# RM is a predefined macro in make (RM = rm -f)
#

clean:
	find . -name *.class -print0 | xargs -0 rm \
	$(RM) $(OUTPUTJAR)

#
# create .jar
#

$(OUTPUTJAR) : $(CLASSES:.java=.class)
	jar cvfm $(OUTPUTJAR) $(MANIFEST) $(CLASSES:.java=.class)

jar: $(OUTPUTJAR)


#
#
#

run: classes
	java $(MAINCLASS)

runjar: jar
	java -jar $(OUTPUTJAR)
