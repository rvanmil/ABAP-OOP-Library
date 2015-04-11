# ABAP Object-oriented programming Library

## Installation

- Manually create the dictionary types listed below
- Use the source based class editor and regular editor to import all classes, interfaces and programs.
- Some packages use a message class. The messages are saved in the .messageclass.txt files. Create the message class manually and copy/paste the messages inside it.

## Dictionary Types

### Table type 'zarray'

Standard table with no keys.
Line type: reference to zcl_object

### Data type 'zresourceclass'

Domain: SEOCLSNAME

### Data type 'zresourcename'

Built-in type: CHAR 30

### Data type 'zresourcepath'

Built-in type: CHAR 255

### Domain 'zlog_requests'

Built-in type: CHAR 1

    Values: ' ' No
            'X' Yes

### Data type 'zlog_requests'

Domain: zlog_requests

### Database table 'zresources'

Type: customizing  
Buffer: full

    Field           Key   Type
    MANDT           X     MANDT
    NAME            X     ZRESOURCENAME
    CLASS                 ZRESOURCECLASS
    PATH                  ZRESOURCEPATH
    LOG_REQUESTS          ZLOG_REQUESTS
    
### Database table 'zrestlog'

Type: application  
Buffer: none

    Field           Key   Type
    MANDT           X     MANDT
    UUID            X     SYSUUID_C32
    REQUESTDATE     X     DATUM
    REQUESTTIME     X     UZEIT
    REQUESTUSER     X     UNAME
    RESOURCEPATH          ZRESOURCEPATH
    RESOURCENAME          ZRESOURCENAME
    RESOURCEID            STRING
    REQUEST               STRING

