; James Dupree
; 5/3/2019
; Final Lab Project

; Description
; This program is a decrypting or encrypting program. 

; Registers
; Registers are subject to change and have been labeled throughout the lab.


; ENCRYPT OR DECRYPT SECTION
.ORIG X3000		 ; Sets the origin	
LEA R0, EORD PUTS	 ; Loads the user's choice into R0	
GETC			 ; R0 contains ASCII value for E or D
OUT			 ; Prints
STI R0, EORDLOC          ; Store E or D in x3100
AND R0, R0, #0		 ; Resets R0

; KEY SECTION	
LEA R0, KEY PUTS	 ; Loads the user's key choice into R0			
GETC			 ; R0 has the key (1-9)
OUT			 ; Prints
LD R1, NASCII2		 ; Loads negative 30 into R1		 
ADD R1, R0, R1		 ; Strips the Ascii value from the input key
STI R1, KEYLOC		 ; Store key in x3101
AND R0, R0, #0		 ; Resets R0

; INPUT MESSAGE SECTION
LD R3, FIRSTCHAR	 ; Loads x3102 into R3
LD R4, COUNTER		 ; Counter to make sure the input is under twenty
LD R6, COUNTER		 ; Counter to make sure the output is the correct number of characters
LEA R0, INPUT PUTS	 ; Prints out on screen
LOOP			 ; Loop as to get multiple characters
LD R5, NEGTWENTY	 ; R5 contains -20
GETC			 ; Loads the input into R0
ADD R2, R0, #-10	 ; To judge whether an enter was pressed
BRZ TRANSITION		 ; Branches to transition section if an enter was pressed
OUT			 ; Prints
STR R0, R3, #0		 ; Stores the character in the x3102 and onward
ADD R3, R3, x1		 ; Adds one to the storing location 
ADD R4, R4, #1		 ; Adds one to the counter for each loop
ADD R6, R6, #1		 ; Adds one to the counter for each loop
ADD R5, R4, R5		 ; Adds the counter and negative 20
BRN LOOP		 ; Else it branches back to loop
BRZP TRANSITION		 ; If the answer is zero or positive go to the ouput


; TRANSITION SECTION
TRANSITION		 ; This is a transition step that routes to encrypt or decrypt
LDI R1, EORDLOC		 ; Loads ascii value of E or D into R1
LD R2, NASCII1		 ; Loads the negative ascii value of E into R2
ADD R2, R2, R1		 ; Checks if R1 is E
BRZ ENCRYPT		 ; If it is, go to encrypt
BRN DECRYPT		 ; If it is not, go to decrypt

; ENCRYPTION SECTION
ENCRYPT			 
LDI R0, FIRSTCHAR	 ; Loads what is stored in x3102 into R0
LDI R1, KEYLOC		 ; Loads the key into R1
LD R2, FIRSTCHAR	 ; Opening Location
LD R3, FOURTEEN		 ; Loads x14 into R3
ADD R3, R2, R3		 ; Storing Location - opening location plus x14
TOPOFE			 ; Top of the encrypted loop
LDR R0, R2, #0		 ; Loads the character in the storing location into R0
ADD R0, R1, R0		 ; R0 HAS THE ENCRYPTED VAlUE
STR R0, R3, #0		 ; Stores the encrypted value into the storing location(R3)
ADD R2, R2, x1		 ; Adds one to the opening location 
ADD R3, R3, x1		 ; Adds one to the storing location 
ADD R4, R4, #-1		 ; Increments based off of the length of text inputted
BRP TOPOFE
BRZ OUTPUT

; DECRYPTION SECTION
DECRYPT			 
LDI R0, FIRSTCHAR	 ; Loads what is stored in x3102 into R0
LDI R1, KEYLOC		 ; Loads the key into R1
NOT R1, R1		 ; Makes the key negative
ADD R1, R1, #1		 ; Makes the key negative
LD R2, FIRSTCHAR	 ; Opening Location
LD R3, FOURTEEN		 ; Loads x14 into R3
ADD R3, R2, R3		 ; Storing Location - opening location plus x14
TOPOFD			 ; Top of the decrypted loop
LDR R0, R2, #0		 ; Loads the character in the storing location into R0
ADD R0, R1, R0		 ; R0 HAS THE DECRYPTED VALUE
STR R0, R3, #0		 ; Stores the decrypted value into the storing location(R3)
ADD R2, R2, x1		 ; Adds one to the opening location 
ADD R3, R3, x1		 ; Adds one to the storing location 
ADD R4, R4, #-1		 ; Increments based off of the length of text inputted
BRP TOPOFD		 ; Branches to top if there is another character remaining
BRZ OUTPUT		 ; Branches to output if there are no characters remaining

; OUTPUT SECTION
OUTPUT
LD R2, OUTLOC		 ; Loads R2 with output location x3116
LEA R0, FINAL PUTS	 ; Prints the final string
TOPOFO			 ; Top of the output loop
LDR R0, R2, #0		 ; Loads x3116 and beyond into R0
OUT			 ; Prints out each decrypted / encrypted character
ADD R2, R2, x1		 ; Counter for the output location incremented by 1
ADD R6, R6, #-1		 ; Counter for the amount of character decremented by 1
BRP TOPOFO		 ; If still remaining characters go back up
BRZ END			 ; If there are no remaining character go to end. 

END
HALT

;DATA
FOURTEEN .FILL x14				; The value for putting the output into its storage location (adds onto x3102)
NASCII1 .FILL #-69				; Negative Ascii value for E
NASCII2 .FILL x-30				; Negative Ascii value to get integers
NEGTWENTY .FILL #-20				; Negative 20 used to keep the input under 20 characters
EORD .STRINGZ "\n(E)ncrypt/(D)ecrypt: "		; User input for encrypt or decrypt
KEY .STRINGZ "\nEncryption Key(1-9): "		; User input for key value
INPUT .STRINGZ "\nInput Message: "		; User input for input message
FINAL .STRINGZ "\nOutput Message: "		; Ouput message
EORDLOC .FILL x3100				; Storage location for E or D
KEYLOC .FILL x3101				; Storage location for key value
FIRSTCHAR .FILL x3102				; Storgae location for first character of user input
OUTLOC .FILL x3116				; Storage location for first output character
COUNTER .FILL #0				; Counters

.END