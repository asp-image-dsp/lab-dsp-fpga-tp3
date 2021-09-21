;----------------------------------------------------------------------
; file        iir_testbench.asm
; author      Grupo 2
; date        20210909
; description Testbench for the IIR subroutine
;-----------------------------------------------------------------------
          INCLUDE     'coef.txt'
          INCLUDE     'iir.asm'

;=======================================================================
; CONSTANTS
;=======================================================================
nsec      EQU         4
;=======================================================================
; X MEMORY SPACE
;=======================================================================
          ORG         X:$0000
bits      DS	      1
          BADDR       M,5*nsec
coef
          DC	      beta1
          DC	      alpha1
          DC	      alpha1*sigma1
          DC	      alpha1*mu1	
          DC	      gamma1
          DC	      beta2
          DC	      alpha2
          DC	      alpha2*sigma2
          DC	      alpha2*mu2	
          DC	      gamma2
          DC	      beta3
          DC	      alpha3
          DC	      alpha3*sigma3
          DC	      alpha3*mu3	
          DC	      gamma3
          DC	      beta4
          DC	      alpha4
          DC	      alpha4*sigma4
          DC	      alpha4*mu4	
          DC	      gamma4

;=======================================================================
; Y MEMORY SPACE
;=======================================================================
          ORG         Y:$0000
xbuf      DSM         2*(nsec+1)

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
          ORG         P:$E100
          iir         nsec

          ORG         P:$E000

main      EQU         *
          ; Initialization
          MOVE        #xbuf,R4                ; Pointer to states
          MOVE        #coef,R0                ; Pointer to coefficients
          MOVE        #1,M4                   ; Modulo 2 for xbuf pointer
          MOVE        #5*nsec-1,M0            ; R0 circular pointer modulo 5*nsec
          MOVE        X:(R0)+,X1              ; Save beta1 in X1 for first run
          MOVE        X:(R0)+,X0              ; Save alpha1 in X0 for first run
          MOVE        #2,N4
          ORI	      #$08,MR

          ; Configure the testbench
          MOVE        #x_start,R6
          MOVE        #y_start,R7
          DO          #(x_end-x_start+1),END
          MOVE        Y:(R6)+,Y1
          JSR         iir_casc
          MOVE        Y1,Y:(R7)+
END
