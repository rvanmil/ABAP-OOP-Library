# ABAP Object-oriented programming Library

## Installation

- Before importing, decide which namespace you will use (/YOURCOMP/ or Y or Z, etc.) and use a text editor to prefix all code with this namespace
- Manually create the dictionary types listed below
- Use the source based class editor to import all classes and interfaces.
- Some packages use a message class. The messages are saved in the .messageclass.txt files. Create the message class manually and copy/paste the messages inside it.

## Dictionary Types

### Table type 'array'

Standard table with no keys.
Line type: reference to cl_object

### Data type 'resourceclass'

Domain: SEOCLSNAME

### Data type 'resourceid'

Built-in type: CHAR 20

### Data type 'uripattern'

Built-in type: CHAR 255

### Database table 'resources'

Type: customzing  
Buffer: full

    Field           Key   Type
    MANDT           X     MANDT
    RESOURCEID      X     RESOURCEID
    RESOURCECLASS         RESOURCECLASS
    URIPATTERN            URIPATTERN
