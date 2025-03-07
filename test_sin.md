[[_TOC_]]

# <test_sin description>

<! ---  NODE: TEST  -->
<!---   MR BEGIN -->

REG:           |  reg1[2]
----------       |  ------------------------------------
DESC:         | desc  adc 
REG_TYPE: | CFG

FIELDS:  | WIDTH | RESET | TYPE | DESC
-------       | -----   | --------|  -------| ----------
A             | 20         |  0x11 | RW | a field desc  
B             | 20         |  0xff | RO | b field desc  
C[2]        | 10         |  0xff | RW | c field desc  