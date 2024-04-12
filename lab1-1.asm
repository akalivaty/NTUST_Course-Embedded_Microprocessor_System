    AREA adder, CODE, READONLY ; mark first instruction
    ENTRY

start
    ; unsigned condition
    mov r0, #0
    mov r1, #0xf7000000 ; equivalent to 0xf7
    mov r2, #0
    mov r3, #0x09000000 ; equivalent to 0x09
    adds r5, r1, r3 ; update condition flag (cpsr: nZCv)
    adc r4, r0, r2  ; add with carry

    ; signed condition
    mov r0, #0
    mov r1, #0x7f000000
    mov r2, #0
    mov r3, #0x7f000000
    adds r5, r1, r3 ; update condition flag (cpsr: NzcV)
    adc r4, r0, r2  ; add with carry

    b stop

stop
    mov r0, #0x18               ; angel_SWIreason_ReportException
    ldr r1, =0x20026            ; ADP_Stopped_ApplicationExit
    swi 0x123456                ; ARM semihosting SWI

    end                         ; Mark end of file
