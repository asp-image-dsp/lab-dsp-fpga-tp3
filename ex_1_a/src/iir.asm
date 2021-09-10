;----------------------------------------------------------------------
; file        iir.asm
; author      Grupo 2
; date        20210909
; description Second order IIR (direct-form)
;-----------------------------------------------------------------------

;=======================================================================
; iir
;
; Executes a second order IIR using the direct form.
; It is expected that the first time the subroutine is called, X0 is loaded
; with the alpha coefficient. The subroutine expects that the X0 register always
; contains the alpha coefficient.
;
; @param    Y1 Input sample x(n)
; @param    R0 Pointer to the coefficients 
; @param    R4 Pointer to the input samples
; @param    R5 Pointer to the output samples
; @return   X1 Output sample y(n)
;=======================================================================
iir     MPY X0,Y1,A     X:(R0)+,X0      Y:(R4)+,Y0    ; A = alfa * x(n)
        MAC X0,Y0,A     X:(R0)+,X0      Y:(R4),Y0     ; A = A + alfa * mu * x(n-1)
        MAC X0,Y0,A     X:(R0)+,X0      Y:(R5)+,Y0    ; A = A + alfa * sigma * x(n-2)
        MAC X0,Y0,A     X:(R0)+,X0      Y:(R5),Y0     ; A = A + gamma * y(n-1)
        MAC X0,Y0,A     X:(R0)+,X0      Y1,Y:(R4)     ; A = A - beta * y(n-2)
        NOP                                           ; Wait for the pipeline to finish
        MOVE            A,X1            A,Y:(R5)      ; yn = 2 * A (scaling mode is set)
        RTS