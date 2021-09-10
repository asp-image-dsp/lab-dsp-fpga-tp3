;----------------------------------------------------------------------
; file        iir_testbench.asm
; author      Grupo 2
; date        20210909
; description Testbench for the IIR subroutine
;-----------------------------------------------------------------------
          INCLUDE     'coef.txt'

;=======================================================================
; CONSTANTS
;=======================================================================

;=======================================================================
; X MEMORY SPACE
;=======================================================================
          ORG         X:$0000
          BADDR       M,5
coef      DC	        mu*alpha
          DC      	  sigma*alpha
          DC	        gamma
          DC	        -beta	
          DC	        alpha

;=======================================================================
; Y MEMORY SPACE
;=======================================================================
          ORG         Y:$0000
x_buffer  DSM         2
y_buffer  DSM         2

          ORG         Y:$0100
x_start   DC          0.1
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
          DC          0
x_end     DC          0

          ORG         Y:$1000
y_start   DS          50

;=======================================================================
; PROGRAM MEMORY SPACE
;=======================================================================
          ORG         P:$0000
          INCLUDE     'iir.asm'

          ORG         P:$E000

main      EQU         *
          ; Initialization
          MOVE        #5-1,M0
          MOVE        #2-1,M4
          MOVE        #2-1,M5
          MOVE        #coef,R0
          MOVE        #x_buffer,R4
          MOVE        #y_buffer,R5
          ORI	        #$08,MR

          ; Load the first parameter of the filter
          MOVE        #alpha,X0

          ; Configure the testbench
          MOVE        #x_start,R6
          MOVE        #y_start,R7
          DO          #(x_end-x_start+1),END
          MOVE        Y:(R6)+,Y1
          JSR         iir
          MOVE        X1,Y:(R7)+
END
