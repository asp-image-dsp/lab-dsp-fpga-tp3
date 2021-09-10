;******************************************************************************
                nolist
                INCLUDE 'ioequ.asm'
                INCLUDE 'intequ.asm'
                INCLUDE 'ada_equ.asm'
                INCLUDE 'vectors.asm'
                INCLUDE 'coef.txt'
                list
;******************************************************************************
		OPT	CEX			 
Left_ch	        EQU	0
CTRL_WD_12      EQU     MIN_LEFT_ATTN+MIN_RIGHT_ATTN+LIN2+RIN2
CTRL_WD_34      EQU     MIN_LEFT_GAIN+MIN_RIGHT_GAIN
;******************************************************************************
datin           EQU     $FFFF           ; Location in Y memory of input file
datout          EQU     $FFFE           ; Location in Y memory of output file
;******************************************************************************
                ORG     X:$0000
bits		DS	1
                BADDR   M,5
coef
                DC	mu*alpha
                DC	sigma*alpha
                DC	gamma
                DC	-beta	
                DC	alpha
;******************************************************************************
                ORG     Y:$0000
x_samples       DSM     2
y_samples       DSM     2
;******************************************************************************
                ORG     P:$100
START
main
                MOVEP   #$040006,x:M_PCTL       ; PLL 7 X 12.288 = 86.016MHz
                ORI     #3,MR                   ; Mask interrupts
                MOVEC   #0,SP                   ; Clear hardware stack pointer
                MOVE    #0,OMR                  ; Operating mode 0
;******************************************************************************
                MOVE    #0,X0
                MOVE    X0,X:bits
inifil	        MOVE    #coef,R0                ; Pointer to the coefficient buffer
                MOVE    #x_samples,R4           ; Pointer to the input buffer
                MOVE    #y_samples,R5           ; Pointer to the output buffer
                MOVE    #5-1,M0                 ; Size of the coefficient buffer
                MOVE    #2-1,M4                 ; Size of the input samples buffer
                MOVE    #2-1,M5                 ; Size of the output samples buffer
                MOVE    #alpha,X0               ; Initial load of X0 with alpha coefficient
;******************************************************************************
	        MOVEP	#$0001,X:M_HPCR 	; Port B I/O mode select
	        MOVEP	#$0001,X:M_HDDR 	; PB0 out
;******************************************************************************
                JSR     ada_init                ; Initialize codec
		JMP     *	
                INCLUDE 'ada_init.asm'		; Used to include codec initialization routines
                INCLUDE 'iir.asm'               ; Used to include IIR routine
                END