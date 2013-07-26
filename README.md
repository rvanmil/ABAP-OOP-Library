# ABAP Object-oriented programming Library

## Installation

- Manually create the dictionary types listed below
- Use the source based class editor and regular editor to import all classes, interfaces and programs.
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

### Domain 'log_requests'

Built-in type: CHAR 1

    Values: ' ' No
            'X' Yes

### Data type 'log_requests'

Domain: log_requests

### Database table 'resources'

Type: customizing  
Buffer: full

    Field           Key   Type
    MANDT           X     MANDT
    RESOURCEID      X     RESOURCEID
    RESOURCECLASS         RESOURCECLASS
    URIPATTERN            URIPATTERN
    LOG_REQUESTS          LOG_REQUESTS
    
### Database table 'restlog'

Type: application  
Buffer: none

    Field           Key   Type
    MANDT           X     MANDT
    UUID            X     SYSUUID_C32
    REQUESTDATE     X     DATUM
    REQUESTTIME     X     UZEIT
    REQUESTUSER     X     UNAME
    RESOURCEPATH          RESOURCEPATH
    RESOURCENAME          RESOURCENAME
    RESOURCEID            STRING
    REQUEST               STRING

