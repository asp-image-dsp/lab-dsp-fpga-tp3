;******************************************************************************
                nolist
                INCLUDE 'ioequ.asm'
                INCLUDE 'intequ.asm'
                INCLUDE 'ada_equ.asm'
                INCLUDE 'vectors.asm'
                INCLUDE 'coef.txt'
                INCLUDE 'iir.asm'               ; Used to include IIR routine macro
                list
;******************************************************************************
		OPT	CEX	 
Left_ch	        EQU	0
CTRL_WD_12      EQU     MIN_LEFT_ATTN+MIN_RIGHT_ATTN+LIN2+RIN2
CTRL_WD_34      EQU     MIN_LEFT_GAIN+MIN_RIGHT_GAIN

;******************************************************************************
;       FILTER CONSTANTS
;******************************************************************************
nsec            EQU     4
;******************************************************************************
datin           EQU     $FFFF           ; Location in Y memory of input file
datout          EQU     $FFFE           ; Location in Y memory of output file
;******************************************************************************
                ORG     X:$0000
bits		DS	1
                BADDR   M,5*nsec
coef
                DC	beta1
                DC	alpha1
                DC	alpha1*sigma1
                DC	alpha1*mu1	
                DC	gamma1
                DC	beta2
                DC	alpha2
                DC	alpha2*sigma2
                DC	alpha2*mu2	
                DC	gamma2
                DC	beta3
                DC	alpha3
                DC	alpha3*sigma3
                DC	alpha3*mu3	
                DC	gamma3
                DC	beta4
                DC	alpha4
                DC	alpha4*sigma4
                DC	alpha4*mu4	
                DC	gamma4
;******************************************************************************
                ORG     Y:$0000
xbuf            DSM     2*(nsec+1)
;******************************************************************************
                ORG     P:$100
START
main
                MOVEP   #$040006,x:M_PCTL       ; PLL 7 X 12.288 = 86.016MHz
                ORI     #3,MR                   ; Mask interrupts
                MOVEC   #0,SP                   ; Clear hardware stack pointer
                MOVE    #0,OMR                  ; Operating mode 0
;******************************************************************************
;       INITIALISATION
;******************************************************************************
                MOVE    #0,X0
                MOVE    X0,X:bits
inifil	        MOVE    #xbuf,R4                ; Pointer to states
                MOVE    #coef,R0                ; Pointer to coefficients
                MOVE    #1,M4                   ; Modulo 2 for xbuf pointer
                MOVE    #5*nsec-1,M0            ; R0 circular pointer modulo 5*nsec
				MOVE    X:(R0)+,X1              ; Save beta1 in X1 for first run
				MOVE    X:(R0)+,X0              ; Save alpha1 in X0 for first run
                MOVE    #2,N4
;******************************************************************************
	        MOVEP	#$0001,X:M_HPCR 	; Port B I/O mode select
	        MOVEP	#$0001,X:M_HDDR 	; PB0 out
;******************************************************************************
                JSR     ada_init                ; Initialize codec
		JMP     *	
                INCLUDE 'ada_init.asm'		; Used to include codec initialization routines
                iir     nsec,xbuf,coef
                END