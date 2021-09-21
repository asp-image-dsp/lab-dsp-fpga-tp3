;----------------------------------------------------------------------
; file        iir.asm
; author      Grupo 2
; date        20210919
; description Cascade of second order IIR (direct-form)
;-----------------------------------------------------------------------

;=======================================================================
; iir
;
; Executes a second order IIR using the direct form.
; It is expected that the first time the subroutine is called, X0 is loaded
; with the alpha coefficient. The subroutine expects that the X0 register always
; contains the alpha coefficient of the first second order section, and
; X1 is loaded iwth the beta coefficient of the same section.
;
; @param    Y1 Input sample x(n)
; @param    R0 Pointer to the coefficients 
; @param    R4 Pointer to the previous samples to be used by the filter
; @return   Y1 Output sample y(n)
;=======================================================================
iir     MACRO           nsec
iir_casc
        ORI             #$08,MR                         ; Setting scaling mode for doubling the output
        MOVE            (R4)+                           ; Point to next xbuf (buffer with previous values) entry
        
        DO #nsec,sectn
        MPY X0,Y1,A     X:(R0)+,X0      Y:(R4)+,Y0      ; A = alpha_i * x_i(n)
        MAC X0,Y0,A     X:(R0)+,X0      Y:(R4)+N4,Y0    ; A = A + alpha_i * sigma_i * x_i(n-2)
        MAC X0,Y0,A     X:(R0)+,X0      Y:(R4)+,Y0      ; A = A + alpha_i * mu_i * x_i(n-1)
        MAC X0,Y0,A                     Y:(R4)-N4,Y0    ; A = A + gamma_i * y_i(n-1)
        MAC -X1,Y0,A    X:(R0)+,X1      Y1,Y:(R4)+N4    ; A = A - beta_i * y_i(n-2) and save x(n)
        MOVE A,Y1        X:(R0)+,X0                      ; y_i(n) = 2 * A (scaling mode is set) 
sectn                                                   ; X1 = beta_i+1 and X0 = alpha_i+1
                                                        ; Output y(n) = Y1
        MOVE            #(nsec+1)*2-1,M4                ; Filter order+1
        NOP 
        MOVE                            Y1,Y:(R4)+N4    ; Save y(n)
        MOVE            #1,M4

        RTS

        ENDM